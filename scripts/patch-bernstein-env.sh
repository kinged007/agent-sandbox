#!/usr/bin/env bash
# Re-apply the ephemeral site-packages patch after `uv tool update bernstein`.
# Repo-persistent env is BERNSTEIN_ALLOWED_API_KEY_ENVS, but pi/opencode adapters
# hardcode their allowlist so they still need NINEROUTER_KEY/PI_PROVIDER added.
# OpenAI-agents runner already honors BERNSTEIN_ALLOWED_API_KEY_ENVS.
set -euo pipefail
SP="$(uv tool list 2>/dev/null | grep -oE '/[^ ]+bernstein[^ ]*lib/python[^ ]+' | head -1)"
if [ -z "$SP" ]; then SP="/home/coder/.local/share/uv/tools/bernstein/lib/python3.12/site-packages"; fi
for f in "$SP/bernstein/adapters/pi.py" "$SP/bernstein/adapters/opencode.py"; do
  if [ -f "$f" ] && ! grep -q "NINEROUTER_KEY" "$f"; then
    echo "patch $f"
    # pi.py: ["PI_API_KEY", ...] -> add NINEROUTER_KEY, PI_PROVIDER
    python3 << PY
import pathlib, re
p=pathlib.Path("$f")
t=p.read_text()
t=t.replace('["PI_API_KEY", "ANTHROPIC_API_KEY", "OPENAI_API_KEY", "OPENROUTER_API_KEY"]','["PI_API_KEY", "ANTHROPIC_API_KEY", "OPENAI_API_KEY", "OPENROUTER_API_KEY", "NINEROUTER_KEY", "PI_PROVIDER"]')
# opencode already has extra but ensure PI_PROVIDER present
if "PI_PROVIDER" not in t and "NINEROUTER_KEY" in t:
    t=t.replace('"NINEROUTER_KEY"', '"NINEROUTER_KEY",\n                "PI_PROVIDER"')
p.write_text(t)
print("patched", "$f")
PY
  else
    echo "ok $f"
  fi
done
echo "done — also export BERNSTEIN_ALLOWED_API_KEY_ENVS=NINEROUTER_KEY,PI_PROVIDER before 'bernstein serve'"
