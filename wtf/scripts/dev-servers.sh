#!/bin/bash
# Detects running dev servers: yarn, npm, pnpm, vite, esbuild, next, webpack, turbo, storybook
# Output format: PID, PORT, Memory, CPU%, Time, Command (with ANSI colors)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
WHITE='\033[37m'
GRAY='\033[90m'

# Get listening ports (PID:PORT format, one per line)
port_data=$(lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null | tail -n +2 | awk '{
  pid=$2
  port=$9
  gsub(/.*:/, "", port)
  if (pid && port ~ /^[0-9]+$/) print pid":"port
}')

# Function to get ports for a PID (max 3, comma-separated)
get_ports() {
  local target_pid="$1"
  local ports=""
  local count=0
  while IFS=: read -r pid port; do
    if [[ "$pid" == "$target_pid" ]]; then
      if [[ -z "$ports" ]]; then
        ports="$port"
      else
        ports="$ports,$port"
      fi
      ((count++))
      if [[ $count -ge 3 ]]; then
        ports="$ports+"
        break
      fi
    fi
  done <<< "$port_data"
  if [[ -z "$ports" ]]; then
    echo "-"
  else
    echo "$ports"
  fi
}

# Function to format elapsed time (from ps etime format to compact)
format_time() {
  local etime="$1"
  # etime formats: MM:SS, HH:MM:SS, D-HH:MM:SS
  if [[ "$etime" =~ ^([0-9]+)-([0-9]+):([0-9]+):([0-9]+)$ ]]; then
    echo "${BASH_REMATCH[1]}d${BASH_REMATCH[2]}h"
  elif [[ "$etime" =~ ^([0-9]+):([0-9]+):([0-9]+)$ ]]; then
    local hours="${BASH_REMATCH[1]}"
    local mins="${BASH_REMATCH[2]}"
    if [[ "$hours" -gt 0 ]]; then
      echo "${hours}h${mins}m"
    else
      echo "${mins}m"
    fi
  elif [[ "$etime" =~ ^([0-9]+):([0-9]+)$ ]]; then
    local mins="${BASH_REMATCH[1]}"
    local secs="${BASH_REMATCH[2]}"
    if [[ "$mins" -gt 0 ]]; then
      echo "${mins}m${secs}s"
    else
      echo "${secs}s"
    fi
  else
    echo "$etime"
  fi
}

# Capture process list with elapsed time
ps_output=$(ps -eo pid,pcpu,rss,etime,command 2>/dev/null)

# Process the list
result=""
while IFS= read -r line; do
  if [[ -z "$line" ]]; then continue; fi
  
  pid=$(echo "$line" | awk '{print $1}')
  cpu=$(echo "$line" | awk '{print $2}')
  rss=$(echo "$line" | awk '{print $3}')
  etime=$(echo "$line" | awk '{print $4}')
  cmd_full=$(echo "$line" | awk '{for(i=5;i<=NF;i++) printf "%s ", $i}')
  
  # Calculate memory in MB
  mem=$((rss / 1024))
  
  # Get port(s) for this PID
  port=$(get_ports "$pid")
  
  # Format elapsed time
  time_fmt=$(format_time "$etime")
  
  # Build simplified command
  cmd=""
  for part in $cmd_full; do
    part="${part##*/}"
    [[ ${#part} -gt 30 ]] && continue
    [[ "$part" == --* ]] && continue
    cmd="$cmd $part"
    [[ ${#cmd} -gt 30 ]] && break
  done
  
  if [[ -n "$cmd" ]]; then
    # Color for memory
    if [[ $mem -lt 500 ]]; then
      mem_color="$GREEN"
    elif [[ $mem -lt 2000 ]]; then
      mem_color="$YELLOW"
    else
      mem_color="$RED"
    fi
    
    # Color for CPU
    cpu_int=${cpu%.*}
    if [[ $cpu_int -lt 10 ]]; then
      cpu_color="$WHITE"
    elif [[ $cpu_int -lt 50 ]]; then
      cpu_color="$YELLOW"
    else
      cpu_color="$RED"
    fi
    
    result+=$(printf "${WHITE}%6s${RESET} ${CYAN}%-15s${RESET} ${mem_color}%6sMB${RESET} ${cpu_color}%5.1f%%${RESET} ${GRAY}%7s${RESET} ${CYAN}%s${RESET}\n" \
      "$pid" "$port" "$mem" "$cpu" "$time_fmt" "$cmd")
    result+=$'\n'
  fi
done < <(echo "$ps_output" | grep -E 'yarn|npm run|pnpm|vite|esbuild|next dev|webpack|turbo|storybook' | grep -v 'grep\|Helper\|Renderer\|dev-servers\|bash.*-c' | head -10)

if [[ -z "$result" ]]; then
  echo -e "${GRAY}(none running)${RESET}"
else
  echo -e "${BOLD}${WHITE}   PID PORT               MEM    CPU     TIME COMMAND${RESET}"
  echo -e "$result"
fi
