#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <spring_tag> <avatar_tag>"
  exit 1
fi

SPRING_TAG_NEW="$1"
AVATAR_TAG_NEW="$2"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"

if [[ ! -f .env.prod ]]; then
  echo ".env.prod not found. copy from .env.prod.example first."
  exit 1
fi

cp .env.prod .env.prod.bak

awk -v spring_tag="$SPRING_TAG_NEW" -v avatar_tag="$AVATAR_TAG_NEW" '
  BEGIN { spring_done=0; avatar_done=0 }
  /^SPRING_TAG=/ { print "SPRING_TAG=" spring_tag; spring_done=1; next }
  /^AVATAR_TAG=/ { print "AVATAR_TAG=" avatar_tag; avatar_done=1; next }
  { print }
  END {
    if (!spring_done) print "SPRING_TAG=" spring_tag
    if (!avatar_done) print "AVATAR_TAG=" avatar_tag
  }
' .env.prod > .env.prod.tmp && mv .env.prod.tmp .env.prod

docker compose --env-file .env.prod pull spring fastapi worker
docker compose --env-file .env.prod up -d spring fastapi worker

echo "rollback complete"
docker compose --env-file .env.prod ps
