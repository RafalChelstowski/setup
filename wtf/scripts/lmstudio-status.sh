#!/bin/bash
# Shows LM Studio server status and loaded models
# Graceful fallback if lms not installed or server not running
# Uses ANSI color codes for wtfutil

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
WHITE='\033[37m'
GRAY='\033[90m'

LMS_PATH="$HOME/.lmstudio/bin/lms"

# Check if lms exists
if [ ! -x "$LMS_PATH" ]; then
  echo -e "${GRAY}LM Studio not installed${RESET}"
  exit 0
fi

# Check server status
server_status=$("$LMS_PATH" server status 2>&1)

if echo "$server_status" | grep -q "not running\|error\|Error"; then
  echo -e "${BOLD}${WHITE}Server:${RESET} ${RED}Offline${RESET}"
  exit 0
fi

# Extract port
port=$(echo "$server_status" | grep -oE 'port [0-9]+' | grep -oE '[0-9]+')
echo -e "${BOLD}${WHITE}Server:${RESET} ${GREEN}Running${RESET} (port ${CYAN}${port:-1234}${RESET})"
echo ""

# Get loaded models
models=$("$LMS_PATH" ps 2>&1)

if echo "$models" | grep -q "No models"; then
  echo -e "${BOLD}${WHITE}Models:${RESET} ${GRAY}(none loaded)${RESET}"
else
  echo -e "${BOLD}${WHITE}Loaded Models:${RESET}"
  # Parse the model table output, skip header
  echo "$models" | tail -n +3 | while read -r line; do
    if [ -n "$line" ]; then
      # Extract fields: IDENTIFIER, MODEL, STATUS, SIZE, CONTEXT
      id=$(echo "$line" | awk '{print $1}')
      status=$(echo "$line" | awk '{print $3}')
      size=$(echo "$line" | awk '{print $4" "$5}')
      ctx=$(echo "$line" | awk '{print $6}')
      
      # Shorten model name if too long
      short_id=$(echo "$id" | sed 's/.*\///' | cut -c1-30)
      
      # Color status
      if [ "$status" = "IDLE" ]; then
        status_colored="${GREEN}${status}${RESET}"
      elif [ "$status" = "RUNNING" ]; then
        status_colored="${YELLOW}${status}${RESET}"
      else
        status_colored="${GRAY}${status}${RESET}"
      fi
      
      echo -e "${CYAN}${short_id}${RESET}"
      echo -e "  ${YELLOW}${size}${RESET} | ctx:${CYAN}${ctx}${RESET} | ${status_colored}"
    fi
  done
fi
