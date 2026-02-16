#!/bin/bash
# sync.sh — Push workspace files from repo to EC2
# Usage: ./deploy/sync.sh [agent-id]
# If no agent-id is given, syncs all workspaces + shared skills

set -euo pipefail

EC2_HOST="ubuntu@3.141.85.81"
SSH_KEY="~/Downloads/openclaw-key.pem"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

sync_agent() {
  local agent_id="$1"
  local src="$REPO_DIR/workspaces/$agent_id/"
  local dest="~/.openclaw/workspace-$agent_id/"

  if [ ! -d "$src" ]; then
    echo "ERROR: No workspace found at $src"
    exit 1
  fi

  echo "Syncing $agent_id → $dest"
  ssh -i "$SSH_KEY" "$EC2_HOST" "mkdir -p $dest"
  rsync -avz --delete \
    -e "ssh -i $SSH_KEY" \
    --exclude='.gitkeep' \
    "$src" "$EC2_HOST:$dest"
  echo "✓ $agent_id synced"
}

sync_shared_skills() {
  local src="$REPO_DIR/shared-skills/"
  local dest="~/.openclaw/skills/"

  echo "Syncing shared skills → $dest"
  ssh -i "$SSH_KEY" "$EC2_HOST" "mkdir -p $dest"
  rsync -avz --delete \
    -e "ssh -i $SSH_KEY" \
    --exclude='.gitkeep' \
    "$src" "$EC2_HOST:$dest"
  echo "✓ Shared skills synced"
}

if [ $# -eq 0 ]; then
  echo "Syncing ALL workspaces..."
  for dir in "$REPO_DIR"/workspaces/*/; do
    agent_id=$(basename "$dir")
    [ "$agent_id" = "_shared" ] && continue
    sync_agent "$agent_id"
  done
  sync_shared_skills
  echo ""
  echo "All workspaces synced. Restart gateway to pick up changes:"
  echo "  ssh -i $SSH_KEY $EC2_HOST 'systemctl --user restart openclaw-gateway.service'"
else
  sync_agent "$1"
  echo ""
  echo "Restart gateway to pick up changes:"
  echo "  ssh -i $SSH_KEY $EC2_HOST 'systemctl --user restart openclaw-gateway.service'"
fi
