#!/usr/bin/env bash
# Oldest-first sweep for `hot-fix`-labeled open issues. Claims one per run via a
# `hot-fix:claimed` label so each issue fires once without manual one-shots.
# Output: ISSUE=<n> TITLE=<t> URL=<u> (or NO_MATCH).
set -euo pipefail
REPO="${GITHUB_REPOSITORY:-kinged007/agent-sandbox}"
pick="$(gh issue list --repo "$REPO" --state open --label hot-fix --limit 100 \
  --json number,title,url,labels 2>/dev/null \
  | python3 -c '
import json, sys
d = json.load(sys.stdin)
free = [i for i in d if "hot-fix:claimed" not in {l["name"] for l in i["labels"]}]
if free:
    i = min(free, key=lambda x: x["number"])
    print("|".join([str(i["number"]), i["title"], i["url"]]))
')"
if [ -z "$pick" ]; then echo "NO_MATCH"; exit 0; fi
n="${pick%%|*}"; rest="${pick#*|}"; title="${rest%%|*}"; url="${rest##*|}"
gh issue edit "$n" --repo "$REPO" --add-label "hot-fix:claimed" >/dev/null 2>&1 || echo "warn: could not add hot-fix:claimed label" >&2
echo "ISSUE=$n TITLE=$title URL=$url"
