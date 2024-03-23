#!/bin/bash
source ~/.bashrc
FLAG_FILE="/workspace/.init_flag"

mkdir -p /workspace/app
cd /workspace/app
if [ ! -f "$FLAG_FILE" ] && [ -n "$STARTUP_CMD_ONCE" ]; then
  echo "Running startup command once: $STARTUP_CMD_ONCE"
  eval $STARTUP_CMD_ONCE
  touch $FLAG_FILE
  if [ -d ".git" ]; then
    if git remote | grep origin > /dev/null; then
      echo "Remote origin already exists"
    else
      git remote add origin https://oauth2:$PAT@gitlab.com/$REPO.git
    fi
  else
      git init
      git remote add origin https://oauth2:$PAT@gitlab.com/$REPO.git
  fi
  git fetch
fi
if [ -n "$STARTUP_CMD" ]; then
  echo "Running startup command: $STARTUP_CMD"
  eval $STARTUP_CMD
fi
git checkout $BRANCH
git pull
if [ -f yarn.lock ]; then
  PKG_MANAGER="yarn"
elif [ -f pnpm-lock.yaml ]; then
  PKG_MANAGER="pnpm"
else
  PKG_MANAGER="npm"
fi
$PKG_MANAGER install
$PKG_MANAGER start
