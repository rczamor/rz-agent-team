#!/usr/bin/env python3
"""
Agent fire-bridge: the thin connector between n8n and the OpenClaw dispatcher.
n8n's "Ready for agent build" branch POSTs here; we return 202 immediately and
kick agent-team-dispatch.py in the background (flock inside it prevents overlap).
Event-driven — NOT a poller/cron. Bound to the n8n docker-gateway IP only (internal).
"""
import http.server, subprocess, json, os, hmac

TOKEN = open("/etc/agent-fire-bridge.token").read().strip()
# Fail closed: refuse to serve with an empty/short token (else an empty token file
# would make the auth check accept any request with no/empty X-Fire-Token header).
if len(TOKEN) < 16:
    raise SystemExit("agent-fire-bridge: refusing to start — token missing or too short")
BIND_IP = "172.18.0.1"   # n8n_default bridge gateway (host side) — internal only
BIND_PORT = 9191
DISPATCHER = "/usr/local/sbin/agent-team-dispatch.py"
RUNLOG = "/var/log/agent-team-dispatch.run"

class Handler(http.server.BaseHTTPRequestHandler):
    def _reply(self, code, msg):
        body = json.dumps({"status": msg}).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    def do_GET(self):
        if self.path == "/health":
            return self._reply(200, "ok")
        self._reply(404, "not found")
    def do_POST(self):
        if not hmac.compare_digest(self.headers.get("X-Fire-Token", ""), TOKEN):
            return self._reply(403, "forbidden")
        if self.path != "/fire":
            return self._reply(404, "not found")
        # fire-and-forget: dispatcher self-serializes via flock + dispatched.json
        subprocess.Popen(["/usr/bin/python3", DISPATCHER],
                         stdout=open(RUNLOG, "a"), stderr=subprocess.STDOUT,
                         start_new_session=True)
        self._reply(202, "dispatch-triggered")
    def log_message(self, *a):
        pass

if __name__ == "__main__":
    http.server.HTTPServer((BIND_IP, BIND_PORT), Handler).serve_forever()
