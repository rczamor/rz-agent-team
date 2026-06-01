---
name: DigitalOcean + Hetzner + Linode community tutorials
role: devops-eng
type: publication
researched: 2026-04-16
---

# DigitalOcean + Hetzner + Linode community tutorials

## Why they matter to the DevOps Eng
VPS-provider tutorials are the single most practical source of "how do I actually do X on a Linux box" instructions — UFW rules, Nginx reverse proxy configs, Certbot/Let's Encrypt setup, Postgres backups, unattended-upgrades, SSH hardening, swap files, fail2ban. Hostinger's docs are thinner than DigitalOcean's, but the underlying Ubuntu/Debian VPS is identical — so DO/Hetzner/Linode tutorials map one-to-one. For a DevOps Eng running one VPS with Nginx fronting Langfuse, Ollama, Paperclip, and Postgres, these libraries are the "just tell me the commands" reference that bypasses the abstraction layers.

## Signature works & primary sources
- DigitalOcean Community — https://www.digitalocean.com/community/tutorials — ~8000 tutorials, best-in-class for Ubuntu/Nginx/Docker.
- "How To Secure Nginx with Let's Encrypt on Ubuntu" — https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04
- "How To Configure Nginx as a Reverse Proxy on Ubuntu 22.04" — https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-reverse-proxy-on-ubuntu-22-04
- "How To Secure a Containerized Node.js App with Nginx, Let's Encrypt, and Docker Compose" — https://www.digitalocean.com/community/tutorials/how-to-secure-a-containerized-node-js-application-with-nginx-let-s-encrypt-and-docker-compose
- Hetzner Community — https://community.hetzner.com/tutorials — strong on firewall, Docker, Postgres backups.
- Linode Docs — https://www.linode.com/docs/guides/ — "Securing Your Server" guide is the canonical Ubuntu hardening walkthrough.

## Core principles (recurring patterns)
- **Nginx is the front door.** One `server {}` block per subdomain, TLS terminated at Nginx, everything behind it on 127.0.0.1:port.
- **Let's Encrypt via Certbot, auto-renewed via systemd timer.** Never manually renew; never let a cert expire.
- **UFW deny-by-default.** Allow 22, 80, 443; deny everything else; Docker bypasses UFW so expose services on 127.0.0.1, not 0.0.0.0.
- **SSH hardening on day 1.** Key-only auth, disable root login, disable password auth, change port if noisy.
- **Unattended security upgrades on.** `unattended-upgrades` auto-applies security patches; restart via cron or `needrestart`.
- **Backups or it didn't happen.** `pg_dump` + offsite copy (S3/Backblaze) on cron; test restores quarterly.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Nginx reverse-proxy block for a new subdomain** (`/etc/nginx/sites-available/langfuse.conf`):
  ```nginx
  server {
    listen 80;
    server_name langfuse.example.com;
    return 301 https://$host$request_uri;
  }
  server {
    listen 443 ssl http2;
    server_name langfuse.example.com;
    ssl_certificate     /etc/letsencrypt/live/langfuse.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/langfuse.example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    client_max_body_size 20m;
    location / {
      proxy_pass http://127.0.0.1:3000;
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_read_timeout 300s;
    }
  }
  ```
- **Let's Encrypt issuance + renewal checklist:**
  ```
  sudo certbot --nginx -d langfuse.example.com --email ops@example.com --agree-tos --redirect
  sudo systemctl list-timers | grep certbot      # verify renewal timer
  sudo certbot renew --dry-run                   # test renewal flow
  ```
- **UFW day-1 setup:**
  ```
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw allow 80,443/tcp
  sudo ufw enable
  ```
- **Postgres backup cron** (`/etc/cron.d/pg-backup`):
  ```
  0 3 * * * postgres /usr/bin/pg_dump -Fc app | gzip > /var/backups/pg/app-$(date +\%Y\%m\%d).sql.gz && find /var/backups/pg -mtime +14 -delete
  15 3 * * * root rclone copy /var/backups/pg b2:rz-backups/pg --max-age 2d
  ```
- **SSH hardening `/etc/ssh/sshd_config` deltas:**
  ```
  PermitRootLogin no
  PasswordAuthentication no
  PubkeyAuthentication yes
  KbdInteractiveAuthentication no
  AllowUsers deploy
  ```
- **New-VPS day-1 checklist** (commit to `/ops/runbooks/new-vps.md`): create non-root user, paste SSH key, SSH-harden, UFW, unattended-upgrades, fail2ban, swap file, Docker install, Nginx install, Certbot install, Tailscale (optional).

## Where they disagree with others
- Vs. Hightower's "fewer moving parts" advice: the DO/Linode tutorial style tends to add things (fail2ban, monitoring agents, log shippers) that may be over-kill for a dev-team VPS.
- Vs. managed-platform defaults (Vercel, Fly.io): these tutorials assume you're doing it yourself, which means more power but more ops surface area.
- Across providers: DigitalOcean's tutorials are the most beginner-friendly; Hetzner's are terser and assume more Linux fluency; Linode's hardening guide is the most security-paranoid.

## Pointers to source material
- https://www.digitalocean.com/community/tutorials
- https://community.hetzner.com/tutorials
- https://www.linode.com/docs/guides/
- Tutorial collection: "How To Secure Nginx with Let's Encrypt" — https://www.digitalocean.com/community/tutorial-collections/how-to-secure-nginx-with-let-s-encrypt
- DO's "Initial Server Setup with Ubuntu" — reference day-1 walkthrough.
