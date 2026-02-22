#!/bin/bash
set -euo pipefail

# Dev server management script
# Handles start/stop/status/restart of dev server
# Config: set PORT env var to override default (3000)
# Dev command: stored in package.json as "dev:raw"

PID_FILE=".dev/dev.pid"
LOG_FILE="logs/dev.log"
PORT="${PORT:-3000}"
SURVIVAL_CHECK_MS=2000

ensure_log_dir() {
  mkdir -p "$(dirname "$LOG_FILE")"
}

start_server() {
  if [ -f "$PID_FILE" ]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" > /dev/null 2>&1; then
      echo "Dev server already running (PID: $pid)"
      exit 1
    else
      echo "Cleaning stale PID file"
      rm -f "$PID_FILE"
    fi
  fi

  # Kill any stale processes on port
  if lsof -ti:$PORT > /dev/null 2>&1; then
    echo "Cleaning stale process on port $PORT"
    lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
    sleep 1
  fi

  ensure_log_dir

  # Start dev server in background
  nohup npm run dev:raw > "$LOG_FILE" 2>&1 &
  local pid=$!

  # Save PID
  mkdir -p .dev
  echo "$pid" > "$PID_FILE"

  # Wait for survival check
  sleep $(echo "scale=3; $SURVIVAL_CHECK_MS/1000" | bc)

  # Confirm process still alive
  if ps -p "$pid" > /dev/null 2>&1; then
    echo "Dev server started (PID: $pid)"
    echo "Logs: $LOG_FILE"
  else
    rm -f "$PID_FILE"
    echo "Dev server failed to start (check $LOG_FILE)"
    exit 1
  fi
}

stop_server() {
  if [ ! -f "$PID_FILE" ]; then
    # No PID file, but check if something is on the port
    if lsof -ti:$PORT > /dev/null 2>&1; then
      echo "No PID file, but process found on port $PORT - killing"
      lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
      sleep 1
    fi
    echo "Dev server not running"
    exit 0
  fi

  local pid=$(cat "$PID_FILE")

  if ! ps -p "$pid" > /dev/null 2>&1; then
    echo "Dev server not running (cleaning stale PID file)"
    rm -f "$PID_FILE"
    # Still check port
    if lsof -ti:$PORT > /dev/null 2>&1; then
      echo "Cleaning orphaned process on port $PORT"
      lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
    fi
    exit 0
  fi

  # Kill entire process tree
  pkill -P "$pid" 2>/dev/null || true
  kill -TERM "$pid" 2>/dev/null || true

  # Wait for process to exit (max 5 seconds)
  local count=0
  while ps -p "$pid" > /dev/null 2>&1 && [ $count -lt 50 ]; do
    sleep 0.1
    count=$((count + 1))
  done

  # Force kill if still running
  if ps -p "$pid" > /dev/null 2>&1; then
    kill -9 "$pid" 2>/dev/null || true
    pkill -9 -P "$pid" 2>/dev/null || true
  fi

  # Force kill anything on the port
  if lsof -ti:$PORT > /dev/null 2>&1; then
    lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
    sleep 1
  fi

  rm -f "$PID_FILE"
  echo "Dev server stopped"
}

status_server() {
  if [ ! -f "$PID_FILE" ]; then
    echo "Dev server not running"
    exit 0
  fi

  local pid=$(cat "$PID_FILE")

  if ps -p "$pid" > /dev/null 2>&1; then
    echo "Dev server running (PID: $pid, port: $PORT)"
    echo "Logs: $LOG_FILE"
  else
    echo "Dev server not running (stale PID file cleaned)"
    rm -f "$PID_FILE"
  fi
}

restart_server() {
  echo "Restarting dev server..."
  stop_server
  sleep 1
  start_server
}

case "${1:-}" in
  start)
    start_server
    ;;
  stop)
    stop_server
    ;;
  status)
    status_server
    ;;
  restart)
    restart_server
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart}"
    exit 1
    ;;
esac
