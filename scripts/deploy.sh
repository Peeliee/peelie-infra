#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .env.prod ]]; then
  echo ".env.prod not found. copy from .env.prod.example first."
  exit 1
fi

docker compose --env-file .env.prod pull
docker compose --env-file .env.prod up -d

echo "deploy complete"
docker compose --env-file .env.prod ps
