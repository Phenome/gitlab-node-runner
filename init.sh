#!/bin/bash
source ~/.bashrc
cd /workspace
FLAG_FILE="/workspace/.init_flag"

if [ ! -f "$FLAG_FILE" ] && [ -n "$STARTUP_CMD_ONCE" ]; then
  echo "Running startup command once: $STARTUP_CMD_ONCE"
  touch $FLAG_FILE
  nvm i $NODE_VERSION
  nvm use $NODE_VERSION
  eval $STARTUP_CMD_ONCE
fi
if [ -n "$STARTUP_CMD" ]; then
  echo "Running startup command: $STARTUP_CMD"
  eval $STARTUP_CMD
fi
git clone https://oauth2:$PAT@gitlab.com/$REPO.git -b $BRANCH app
cd /workspace/app
if [ -f yarn.lock ]; then
  PKG_MANAGER="yarn"
elif [ -f pnpm-lock.yaml ]; then
  PKG_MANAGER="pnpm"
else
  PKG_MANAGER="npm"
fi
$PKG_MANAGER install
$PKG_MANAGER start
