#!/usr/bin/env python3
"""
Agent-team dispatcher (host cron). Polls Linear for issues in "Ready for agent build",
has the Conductor (Opus) route each to a worker, fires that worker to execute, and
writes results back to Linear. Internal-only: does NOT depend on the dead external
webhook or the crippled heartbeats. flock-guarded so runs never overlap.
"""
import json, os, re, subprocess, sys, time, urllib.request, fcntl, datetime

LINEAR_KEY = None
for line in open("/docker/openclaw-conductor/.env"):
    if line.startswith("LINEAR_API_KEY="):
        LINEAR_KEY = line.strip().split("=", 1)[1].strip('"').strip("'")
READY_STATE = "92aed341-4ced-43ee-afff-ef97fb60074a"   # Ready for agent build
INPROGRESS  = "b4dcc556-9419-485d-a73c-e4b5ccb6330d"   # In Progress
INREVIEW    = "4ebbcad7-3403-4594-a7ea-022d07c6183f"   # In Review
WORKERS = ["backend-eng","ui-eng","data-eng","ai-eng","devops-eng","qa-eng","tech-writer","designer","pm","growth"]
STATE_DIR = "/var/lib/agent-team"; os.makedirs(STATE_DIR, exist_ok=True)
DISPATCHED = os.path.join(STATE_DIR, "dispatched.json")
LOG = "/var/log/agent-team-dispatch.log"

def log(m):
    line = f"{datetime.datetime.utcnow().isoformat()}Z {m}"
    print(line, flush=True)
    open(LOG, "a").write(line + "\n")

def linear(query, variables=None):
    body = json.dumps({"query": query, "variables": variables or {}}).encode()
    req = urllib.request.Request("https://api.linear.app/graphql", data=body,
        headers={"Authorization": LINEAR_KEY, "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def ready_issues():
    q = '{ issues(filter:{state:{id:{eq:"%s"}}}, first:20){ nodes{ id identifier title description } } }' % READY_STATE
    d = linear(q)
    return d.get("data", {}).get("issues", {}).get("nodes", [])

def set_state(issue_id, state_id):
    linear("mutation($i:String!,$s:String!){ issueUpdate(id:$i, input:{stateId:$s}){ success } }",
           {"i": issue_id, "s": state_id})

def comment(issue_id, body):
    linear("mutation($i:String!,$b:String!){ commentCreate(input:{issueId:$i, body:$b}){ success } }",
           {"i": issue_id, "b": body})

def fire(role, message, result_path_host, timeout=240):
    """Write message to the container's data dir, run an agent turn, return parsed result file (or None)."""
    cont = f"openclaw-{role}-openclaw-1"
    data = f"/docker/openclaw-{role}/data/.openclaw"
    open(f"{data}/_msg.txt", "w").write(message)
    subprocess.run(["chown", "1000:1000", f"{data}/_msg.txt"])
    if os.path.exists(result_path_host):
        os.remove(result_path_host)
    cmd = ("cd /data && HOME=/data timeout %d openclaw agent --agent main "
           "--message \"$(cat /data/.openclaw/_msg.txt)\" --json >/data/.openclaw/_turn.json 2>/dev/null; echo RC=$?") % timeout
    subprocess.run(["docker","exec","-u","node",cont,"sh","-c",cmd], timeout=timeout+40)
    if os.path.exists(result_path_host):
        try:
            return json.load(open(result_path_host))
        except Exception as e:
            log(f"  result parse fail ({role}): {e}")
    return None

ROUTE_FOOTER = ("\n\nYou MUST finish by writing your routing decision as JSON to a file with this exact bash command "
    "(no markdown): printf '%s' '{\"worker\":\"<one of "+",".join(WORKERS)+">\",\"brief\":\"<concrete, self-contained execution instructions for that worker>\"}' > /data/.openclaw/_route.json . Then reply 'routed'.")

WORK_FOOTER = ("\n\nEXECUTION CONTEXT: repo rczamor/rz-agent-team; a valid GitHub token is at /data/.openclaw/.ghtoken "
    "(export GITHUB_TOKEN=$(cat /data/.openclaw/.ghtoken)); never merge to main (branch + PR only); Slack #agent-team is C0ATF5LV88J "
    "via $SLACK_BOT_TOKEN. Do the work now using your bash tool. FINISH by writing JSON to /data/.openclaw/_work.json via: "
    "printf '%s' '{\"summary\":\"<what you did>\",\"pr_url\":\"<url or empty>\",\"ok\":true}' > /data/.openclaw/_work.json . Then reply 'done'.")

def main():
    if not LINEAR_KEY:
        log("NO LINEAR KEY"); return
    lock = open(os.path.join(STATE_DIR, ".lock"), "w")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        log("another run in progress; exit"); return
    dispatched = set(json.load(open(DISPATCHED))) if os.path.exists(DISPATCHED) else set()
    issues = ready_issues()
    log(f"poll: {len(issues)} issue(s) in Ready-for-agent-build")
    for it in issues:
        iid, ident, title = it["id"], it["identifier"], it.get("title","")
        if iid in dispatched:
            continue
        desc = (it.get("description") or "")[:1500]
        log(f"DISPATCH {ident}: {title}")
        set_state(iid, INPROGRESS)
        comment(iid, "🤖 Agent team picked this up — Conductor is routing it.")
        # 1) conductor routes
        route = fire("conductor",
            f"New ticket {ident}: {title}\n\n{desc}\n\nDecide the single best worker role and write a precise execution brief." + ROUTE_FOOTER,
            "/docker/openclaw-conductor/data/.openclaw/_route.json", timeout=140)
        worker = (route or {}).get("worker") if route else None
        brief  = (route or {}).get("brief") if route else None
        if worker not in WORKERS:
            worker, brief = "backend-eng", f"Handle ticket {ident}: {title}. {desc}"
            log(f"  routing fallback -> {worker}")
        else:
            log(f"  conductor routed -> {worker}")
        comment(iid, f"🧭 Conductor routed this to **{worker}**.")
        # 2) worker executes
        work = fire(worker, f"You are the {worker} agent. Ticket {ident}: {title}\n\n{brief}" + WORK_FOOTER,
                    f"/docker/openclaw-{worker}/data/.openclaw/_work.json", timeout=240)
        if work and work.get("ok"):
            pr = work.get("pr_url") or ""
            comment(iid, f"✅ **{worker}** completed the work.\n\n{work.get('summary','')}\n\n{('PR: '+pr) if pr else ''}")
            set_state(iid, INREVIEW)
            log(f"  {ident} done; pr={pr}")
        else:
            comment(iid, f"⚠️ {worker} did not report a clean completion. Needs human check.")
            log(f"  {ident} worker incomplete")
        dispatched.add(iid)
        json.dump(sorted(dispatched), open(DISPATCHED, "w"))
    log("poll done")

if __name__ == "__main__":
    main()
