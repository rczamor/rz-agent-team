#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "${SCRIPT_DIR}/.env.local" ]]; then
  echo "error: ${SCRIPT_DIR}/.env.local not found" >&2
  exit 1
fi

set -a; source "${SCRIPT_DIR}/.env.local"; set +a

: "${HOSTINGER_HOST:?HOSTINGER_HOST is empty in .env.local}"
: "${HOSTINGER_USER:?HOSTINGER_USER is empty in .env.local}"
: "${HOSTINGER_SSH_KEY:?HOSTINGER_SSH_KEY is empty in .env.local}"

KEY_PATH="$(eval echo "${HOSTINGER_SSH_KEY}")"

if ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null
fi

if ! ssh-add -l 2>/dev/null | grep -q "${KEY_PATH}"; then
  ssh-add "${KEY_PATH}"
fi

exec ssh -p "${HOSTINGER_PORT:-22}" \
  -i "${KEY_PATH}" \
  -o ServerAliveInterval=30 \
  "${HOSTINGER_USER}@${HOSTINGER_HOST}" "$@"
