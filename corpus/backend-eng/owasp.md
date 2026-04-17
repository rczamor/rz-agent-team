---
name: OWASP (Open Worldwide Application Security Project)
role: backend-eng
type: organization
researched: 2026-04-16
---

# OWASP

## Why they matter to the Backend Eng
OWASP is the authoritative, non-commercial source for web application security. For any endpoint on SIA (FastAPI) or richezamor.com (Next.js API routes) that handles auth, user input, PII, or money, OWASP's Top 10 and ASVS are the baseline checklist — not aspirational targets. Nearly every real-world breach traces to one of the Top 10. Treat OWASP as a non-negotiable code review lens: before shipping an auth flow, an upload handler, or a serializer, you should be able to say which OWASP categories you've considered and mitigated.

## Signature works & primary sources
- **OWASP Top 10** — https://owasp.org/Top10/ — the ten most critical web application security risks, updated every 3–4 years.
- **OWASP ASVS (Application Security Verification Standard)** — https://owasp.org/www-project-application-security-verification-standard/ — detailed requirements list (L1/L2/L3); the "what to test" spec.
- **OWASP Cheat Sheet Series** — https://cheatsheetseries.owasp.org — topic-specific guides (Authentication, JWT, Session Management, SQL Injection Prevention, CSRF, CORS, Input Validation, Password Storage).
- **OWASP API Security Top 10** — https://owasp.org/API-Security/ — API-specific risks (BOLA, broken auth, excessive data exposure, etc.); more relevant to SIA than the web Top 10.
- **OWASP ZAP** — https://www.zaproxy.org — dynamic scanner for runtime testing.
- **OWASP SAMM** — software assurance maturity model for process-level security.

## Core principles (recurring patterns)
- **OWASP Top 10 (2021 edition — current baseline):**
  - **A01: Broken Access Control** (#1 by incidence) — authorize every request by resource + action; never trust the client ID; default-deny.
  - **A02: Cryptographic Failures** — TLS everywhere; never roll your own crypto; use argon2/bcrypt for passwords; AES-GCM or libsodium for data at rest.
  - **A03: Injection** — parameterized queries only (SQLAlchemy bound params); validate + encode all user input at the boundary.
  - **A04: Insecure Design** — threat-model before coding; security is a design concern, not a late-stage audit.
  - **A05: Security Misconfiguration** — default-secure configs; disable debug in prod; lock down CORS origins; set security headers.
  - **A06: Vulnerable and Outdated Components** — dependabot/renovate; `pip-audit`, `npm audit` in CI; SBOM tracking.
  - **A07: Identification and Authentication Failures** — MFA, rate-limit login, secure session management, short-lived tokens + refresh.
  - **A08: Software and Data Integrity Failures** — signed packages, checked CI/CD pipelines, integrity on updates.
  - **A09: Security Logging and Monitoring Failures** — log auth events, access denials, and admin actions; alert on anomalies.
  - **A10: Server-Side Request Forgery (SSRF)** — allowlist outbound hosts; block internal IP ranges (169.254/16, 10.0.0.0/8, 127.0.0.1).
- **Defense in depth.** No single control is sufficient. Auth + authz + input validation + output encoding + logging, always.
- **Least privilege everywhere.** DB users, IAM roles, API scopes, OAuth grants — grant the minimum.
- **Fail closed, fail loud.** Default-deny for authz; log the denial.

## Concrete templates, checklists, or artifacts the agent can reuse
- **OWASP Top 10 PR checklist (paste into every substantive PR):**
  - [ ] A01: Every new endpoint has explicit authz (decorator, Depends(), or middleware). Object-level check for owner/role.
  - [ ] A02: No secrets in code; TLS enforced; passwords hashed with argon2id; sensitive fields encrypted at rest.
  - [ ] A03: All queries parameterized (SQLAlchemy bound params, never f-strings). Input validated via Pydantic with strict types.
  - [ ] A04: Threat model considered (STRIDE) for new features touching auth, data, or payments.
  - [ ] A05: No debug=True in prod; CORS origins explicit; security headers (CSP, HSTS, X-Frame-Options) present.
  - [ ] A06: No new deps without license check and vuln scan; lockfiles committed.
  - [ ] A07: Login rate-limited; MFA path supported; sessions/JWT have appropriate TTL.
  - [ ] A08: CI signs artifacts; prod deploys reviewed.
  - [ ] A09: Auth success/fail, authz denial, admin action all logged.
  - [ ] A10: Any outbound HTTP call to user-supplied URL is allowlisted / blocks internal IPs.
- **Auth flow template (OAuth2 + PKCE for user login, JWT for service-to-service):**
  - User login: OAuth2 authorization code + PKCE; short-lived access token (15 min) + refresh token (stored httpOnly cookie).
  - Service-to-service: signed JWT with `aud`, `iss`, `exp`, `iat`, `scope`. Verify signature, audience, expiration on every request.
  - Password hashing: `argon2id` with params from OWASP Password Storage Cheat Sheet (memoryCost=19 MiB, timeCost=2, parallelism=1 as 2026 baseline).
- **CORS + security headers defaults for FastAPI:**
  ```python
  app.add_middleware(CORSMiddleware, allow_origins=[APP_ORIGIN], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])
  # Plus a middleware adding: Strict-Transport-Security, X-Content-Type-Options: nosniff, Referrer-Policy: strict-origin, Content-Security-Policy, X-Frame-Options: DENY.
  ```
- **Input-validation pattern:** Pydantic `model_config = ConfigDict(extra="forbid", str_max_length=10_000)`. Never accept `Any`. Validate emails with `EmailStr`, URLs with `HttpUrl`.

## Where they disagree with others
- **OWASP (defense-in-depth, ASVS rigor)** vs. **"move fast" startup culture:** OWASP treats security as non-negotiable; ASVS L1 is the minimum any production app should meet. Skipping this is not a trade-off, it's a bug.
- **OWASP Top 10 (web-centric)** vs. **OWASP API Security Top 10 (API-centric):** SIA is an API, so API Top 10 is more directly applicable (BOLA is more common than XSS for API-only services). Use both.

## Pointers to source material
- Top 10: https://owasp.org/Top10/
- ASVS: https://owasp.org/www-project-application-security-verification-standard/
- Cheat Sheets: https://cheatsheetseries.owasp.org
- API Security Top 10: https://owasp.org/API-Security/
- ZAP scanner: https://www.zaproxy.org
- Local chapters + conferences: AppSec Global, AppSec Days.
