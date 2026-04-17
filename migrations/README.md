# agent_memory migrations

SQL migrations for the dedicated `agent-memory-postgres` container on the Hostinger VPS.

## Where this lives

Container `agent-memory-postgres` runs from `/docker/agent-memory/docker-compose.yml` on the VPS:

- **Image:** `postgres:17`
- **Host bind:** `127.0.0.1:54330` → container `:5432` (loopback only — not publicly exposed)
- **Database:** `agent_memory`
- **User:** `agent_memory` (owner — full DDL rights)
- **Password:** in `/docker/agent-memory/.env` on the VPS (not committed)
- **Volume:** `/docker/agent-memory/data` (host) → `/var/lib/postgresql/data` (container)
- **Network:** `agent-memory_default` — other services that need access (openclaw fleet, future tooling) must be attached to this network

## Connection string for in-cluster services

From a container on the `agent-memory_default` network:

```
postgresql://agent_memory:<PASSWORD>@agent-memory-postgres:5432/agent_memory
```

From the VPS host or Postgres clients tunneling via SSH:

```
postgresql://agent_memory:<PASSWORD>@127.0.0.1:54330/agent_memory
```

## Migration ordering

Numbered with a 4-digit prefix. Apply in lexical order. There is no migration runner yet; apply by hand:

```bash
# Copy migration into the container and run it
ssh root@srv1535988 "cat > /tmp/{file}.sql" < migrations/{file}.sql
ssh root@srv1535988 "docker cp /tmp/{file}.sql agent-memory-postgres:/tmp/{file}.sql"
ssh root@srv1535988 "docker exec agent-memory-postgres psql -U agent_memory -d agent_memory -v ON_ERROR_STOP=1 -f /tmp/{file}.sql"
```

Use `-v ON_ERROR_STOP=1` so a partial migration aborts loudly instead of leaving the schema half-applied.

## Convention

- Forward-only migrations. No down-migrations.
- File naming: `{NNNN}_{snake_case_description}.sql` — 4 digits, lowercase.
- Each file should be idempotent (`CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, etc.) so re-running is safe.
- Schema-qualify everything — every object lives in the `agent_memory` schema, never in `public`.
- Add a header comment per file: what it changes, why, and any operational notes.

## Backup

Embedded Postgres data is on the VPS root disk. **There is no automated backup yet.** A future change should add `pg_dump` to a cron and ship the dumps off-VPS (S3, B2, or similar).
