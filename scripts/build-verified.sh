#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${SITES_ENV_READY:-}" != "1" ]]; then
  exec "${script_dir}/sites-env.sh" -- "$0" "$@"
fi

# GNU timeout; Homebrew's coreutils installs it as gtimeout on macOS.
timeout_bin="$(command -v timeout || command -v gtimeout || true)"
[[ -n "${timeout_bin}" ]] || {
  echo "build-verified.sh requires GNU timeout. On macOS: brew install coreutils." >&2
  exit 69
}

vinext="${SITES_PROJECT_ROOT}/node_modules/.bin/vinext"
if [[ ! -x "${vinext}" ]]; then
  echo "vinext is unavailable. Run npm run install:ci (npm ci outside CI) and wait for it to finish before building." >&2
  exit 69
fi

echo "Running bounded vinext build..."
"${timeout_bin}" \
  --signal=TERM \
  --kill-after="${SITES_BUILD_KILL_AFTER:-10s}" \
  "${SITES_BUILD_TIMEOUT:-3m}" \
  "${vinext}" build

"${script_dir}/validate-artifact.sh"
