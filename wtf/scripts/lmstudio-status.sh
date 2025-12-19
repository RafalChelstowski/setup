#!/bin/bash
# Shows LM Studio server status and loaded models (detailed view)
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

# Get loaded models in JSON format for detailed info
models_json=$("$LMS_PATH" ps --json 2>&1)

# Check if any models are loaded
if echo "$models_json" | grep -q '^\[\]$\|No models\|error'; then
  echo -e "${GRAY}(no models loaded)${RESET}"
  exit 0
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  # Fallback to basic output if jq not installed
  echo -e "${GRAY}Install jq for detailed model info${RESET}"
  "$LMS_PATH" ps 2>&1 | tail -n +3
  exit 0
fi

# Parse JSON and display detailed info for each model
echo "$models_json" | jq -r '.[] | @base64' | while read -r model_b64; do
  # Decode the model JSON
  model=$(echo "$model_b64" | base64 --decode)
  
  # Extract fields
  display_name=$(echo "$model" | jq -r '.displayName // .identifier')
  params=$(echo "$model" | jq -r '.paramsString // "?"')
  quant=$(echo "$model" | jq -r '.quantization.name // "?"')
  status=$(echo "$model" | jq -r '.status // "unknown"')
  size_bytes=$(echo "$model" | jq -r '.sizeBytes // 0')
  ctx=$(echo "$model" | jq -r '.contextLength // 0')
  max_ctx=$(echo "$model" | jq -r '.maxContextLength // 0')
  vision=$(echo "$model" | jq -r '.vision // false')
  tool_use=$(echo "$model" | jq -r '.trainedForToolUse // false')
  queued=$(echo "$model" | jq -r '.queued // 0')
  last_used_ms=$(echo "$model" | jq -r '.lastUsedTime // 0')
  
  # Calculate size in GB
  size_gb=$((size_bytes / 1024 / 1024 / 1024))
  
  # Format context (K suffix)
  ctx_k=$((ctx / 1024))
  max_ctx_k=$((max_ctx / 1024))
  
  # Format last used time
  if [[ "$last_used_ms" != "0" && "$last_used_ms" != "null" ]]; then
    last_used_sec=$((last_used_ms / 1000))
    now_sec=$(date +%s)
    diff_sec=$((now_sec - last_used_sec))
    
    # Calculate relative time
    if [[ $diff_sec -lt 60 ]]; then
      relative="${diff_sec}s ago"
    elif [[ $diff_sec -lt 3600 ]]; then
      relative="$((diff_sec / 60))m ago"
    elif [[ $diff_sec -lt 86400 ]]; then
      relative="$((diff_sec / 3600))h ago"
    else
      relative="$((diff_sec / 86400))d ago"
    fi
    
    # Get absolute time
    absolute=$(date -r "$last_used_sec" "+%H:%M" 2>/dev/null || echo "?")
    last_used_str="${absolute} (${relative})"
  else
    last_used_str="-"
  fi
  
  # Color status
  case "$status" in
    "idle"|"IDLE")
      status_colored="${GREEN}IDLE${RESET}"
      ;;
    "running"|"RUNNING")
      status_colored="${YELLOW}RUNNING${RESET}"
      ;;
    *)
      status_colored="${GRAY}${status}${RESET}"
      ;;
  esac
  
  # Format vision/tool indicators
  if [[ "$vision" == "true" ]]; then
    vision_str="${GREEN}✓${RESET}"
  else
    vision_str="${GRAY}✗${RESET}"
  fi
  
  if [[ "$tool_use" == "true" ]]; then
    tool_str="${GREEN}✓${RESET}"
  else
    tool_str="${GRAY}✗${RESET}"
  fi
  
  # Color queue (yellow if > 0)
  if [[ "$queued" -gt 0 ]]; then
    queue_str="${YELLOW}${queued}${RESET}"
  else
    queue_str="${WHITE}${queued}${RESET}"
  fi
  
  # Output formatted model info
  echo -e "${CYAN}${BOLD}${display_name}${RESET} ${GRAY}(${params}, ${quant})${RESET}"
  echo -e "  ${WHITE}Size:${RESET} ${YELLOW}${size_gb}GB${RESET} ${WHITE}| Context:${RESET} ${CYAN}${ctx_k}K${RESET}/${GRAY}${max_ctx_k}K${RESET} | ${status_colored}"
  echo -e "  ${WHITE}Vision:${RESET} ${vision_str} ${WHITE}| Tools:${RESET} ${tool_str} ${WHITE}| Queue:${RESET} ${queue_str}"
  echo -e "  ${WHITE}Last used:${RESET} ${GRAY}${last_used_str}${RESET}"
done
