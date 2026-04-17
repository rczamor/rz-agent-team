---
name: Julia Evans
role: devops-eng
type: individual
researched: 2026-04-16
---

# Julia Evans

## Why they matter to the DevOps Eng
Julia Evans is the best working explainer of Linux, networking, DNS, and debugging fundamentals — which happen to be 80% of what can go wrong on a single VPS. When Nginx is 502-ing, Postgres won't accept connections, or a cert isn't renewing, the actual fix comes from the fundamentals she covers: `strace`/`tcpdump`/`dig`/`ss`, how DNS resolution actually works, how TLS handshakes fail, how Linux processes share state. Her zines are short, concrete, and immediately actionable — exactly the format a DevOps Eng wants at 1am. She's also the primary advocate of "debug with verified facts, not guesses," which is the single most valuable habit for ops work.

## Signature works & primary sources
- *How DNS Works!* zine (2022) — https://wizardzines.com/zines/dns/ — directly applicable to every Nginx/Let's Encrypt/Cloudflare issue.
- *Bite Size Networking!* zine — https://wizardzines.com/zines/bite-size-networking/ — tcpdump, netstat/ss, packet flows.
- *The Pocket Guide to Debugging* (2022) — https://wizardzines.com/zines/debugging-guide/ — the "verify, don't guess" methodology.
- *Your Linux Toolbox* (O'Reilly print edition) — box set of the free zines.
- *How Git Works!* (2024) — https://wizardzines.com/zines/how-git-works/
- *Bite Size Linux* / *Linux Debugging Tools* — https://wizardzines.com/zines/
- Blog: https://jvns.ca — long-form posts on Bash, terminals, strace, SSL certs.

## Core principles (recurring patterns)
- **Debug with verified facts, not guesses.** Run the command, read the output, write down what you learned. Don't theorize from the symptom.
- **Make the computer less mysterious.** Every "magic" failure has a concrete mechanism — a syscall, a packet, a process, a file descriptor.
- **Short feedback loops win.** `curl -v`, `dig`, `tcpdump -i any port 443`, `docker exec -it <c> sh` — reach for these before dashboards.
- **The fundamentals compose.** Understanding DNS + TLS + HTTP + processes + filesystems covers nearly every VPS incident.
- **Write it down.** Zines exist because "I learned this once and keep forgetting" is universal. Keep an ops notebook.

## Concrete templates, checklists, or artifacts the agent can reuse
- **"Is it DNS?" checklist** (spoiler: it's always DNS):
  ```
  dig +trace example.com           # full resolution path
  dig @1.1.1.1 example.com         # bypass local resolver
  dig example.com CAA              # Let's Encrypt needs this
  getent hosts example.com         # what the OS actually resolves
  cat /etc/resolv.conf             # what resolver is being used
  ```
- **TLS/cert debugging one-liner**:
  ```
  openssl s_client -connect host:443 -servername host < /dev/null 2>&1 | \
    openssl x509 -noout -dates -subject -issuer
  ```
- **"What is this process doing?" checklist** on the VPS: `ps auxf`, `ss -tlnp`, `lsof -p <pid>`, `strace -p <pid> -f -e trace=network` (use sparingly in prod).
- **Container networking debug**: `docker exec <c> nslookup <other-service>`, check the Docker Compose network name, verify `expose` vs. `ports`, try `docker network inspect <name>`.
- **Ops notebook template** — one markdown file per incident/weird-thing-learned, grep-able forever: `date / symptom / commands run / output / conclusion / fix`.

## Where they disagree with others
- Vs. observability-platform vendors (Datadog, New Relic): Evans is pro-dashboards but emphatic that you should also know the raw commands — a dashboard won't help when the box is so broken dashboards can't load.
- Vs. "senior engineers don't read man pages": she reads man pages on camera. The fundamentals are never beneath you.
- Vs. AI-first debugging: she'd say run the command and read the output yourself before asking an LLM to guess.

## Pointers to source material
- Main site: https://jvns.ca
- Zine shop: https://wizardzines.com
- Free zines index: https://wizardzines.com/zines/
- Mastodon: https://social.jvns.ca/@b0rk
- Her "how to ask good questions" post — https://jvns.ca/blog/good-questions/ — useful for incident comms.
