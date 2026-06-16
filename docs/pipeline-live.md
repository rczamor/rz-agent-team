# Agent Pipeline — LIVE

The autonomous agent pipeline is live as of 2026-06-10.

- **Claude reasoning**: LLM-driven task decomposition and decision-making via claude-sonnet-4-6.
- **Shell/exec**: Workers execute shell commands and filesystem operations inside sandboxed environments.
- **SNI-proxy egress containment**: Outbound traffic is filtered through an SNI-aware proxy; only allowlisted hostnames are reachable.
