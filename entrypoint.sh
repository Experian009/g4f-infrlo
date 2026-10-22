#!/bin/sh
# gpt4free (Render / Docker hosts).
# - Picks a writable base dir for g4f's config/cache (prefers /data,
#   falls back to /tmp if /data is not writable).
# - If the HAR_JSON env var is set, seeds the ChatGPT session file into
#   the cookies dir before starting.
# - Starts the g4f API server on $PORT (default 8080) under xvfb-run:
#   the ChatGPT provider launches a headed browser over CDP and needs a
#   (virtual) display.
set -e

BASE=/data
if ! mkdir -p "$BASE" 2>/dev/null; then
  BASE=/tmp
fi

export G4F_CONFIG_DIR="$BASE/g4f"
export G4F_CACHE_DIR="$BASE/g4f-cache"
mkdir -p "$G4F_CONFIG_DIR/cookies" "$G4F_CACHE_DIR"

if [ -n "$HAR_JSON" ]; then
  printf '%s' "$HAR_JSON" > "$G4F_CONFIG_DIR/cookies/chatgpt.har"
  echo "entrypoint: seeded chatgpt.har from HAR_JSON"
fi

echo "entrypoint: G4F_CONFIG_DIR=$G4F_CONFIG_DIR PORT=${PORT:-8080}"
exec xvfb-run -a -s "-screen 0 1280x800x24" python -m g4f api --port "${PORT:-8080}"
