#!/bin/bash
# Detects running test watchers: jest, vitest, playwright, cypress, pytest
# Output format: PID, Memory, CPU%, Time, Framework (with ANSI colors)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
WHITE='\033[37m'
GRAY='\033[90m'

# Capture process list with elapsed time
ps_output=$(ps -eo pid,pcpu,rss,etime,command 2>/dev/null)

# Function to format elapsed time (from ps etime format to compact)
format_time() {
  local etime="$1"
  # etime formats: MM:SS, HH:MM:SS, D-HH:MM:SS
  if [[ "$etime" =~ ^([0-9]+)-([0-9]+):([0-9]+):([0-9]+)$ ]]; then
    # Days format: D-HH:MM:SS
    echo "${BASH_REMATCH[1]}d${BASH_REMATCH[2]}h"
  elif [[ "$etime" =~ ^([0-9]+):([0-9]+):([0-9]+)$ ]]; then
    # Hours format: HH:MM:SS
    local hours="${BASH_REMATCH[1]}"
    local mins="${BASH_REMATCH[2]}"
    if [[ "$hours" -gt 0 ]]; then
      echo "${hours}h${mins}m"
    else
      echo "${mins}m"
    fi
  elif [[ "$etime" =~ ^([0-9]+):([0-9]+)$ ]]; then
    # Minutes format: MM:SS
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
  mem=$(echo "scale=0; $rss / 1024" | bc)
  
  # Format elapsed time
  time_fmt=$(format_time "$etime")
  
  # Identify the test framework
  framework=""
  if [[ "$cmd_full" =~ node.*jest|jest\.js|jest-worker ]] && [[ ! "$cmd_full" =~ majest ]]; then
    framework="jest"
  elif [[ "$cmd_full" =~ node.*vitest|vitest\.mjs ]]; then
    framework="vitest"
  elif [[ "$cmd_full" =~ playwright ]]; then
    framework="playwright"
  elif [[ "$cmd_full" =~ cypress ]]; then
    framework="cypress"
  elif [[ "$cmd_full" =~ python.*pytest|pytest ]]; then
    framework="pytest"
  fi
  
  if [[ -n "$framework" ]]; then
    # Color for memory: green <500MB, yellow <2000MB, red >=2000MB
    if [[ $mem -lt 500 ]]; then
      mem_color="$GREEN"
    elif [[ $mem -lt 2000 ]]; then
      mem_color="$YELLOW"
    else
      mem_color="$RED"
    fi
    
    # Color for CPU: white <10%, yellow <50%, red >=50%
    cpu_int=${cpu%.*}
    if [[ $cpu_int -lt 10 ]]; then
      cpu_color="$WHITE"
    elif [[ $cpu_int -lt 50 ]]; then
      cpu_color="$YELLOW"
    else
      cpu_color="$RED"
    fi
    
    result+=$(printf "${WHITE}%6s${RESET} ${mem_color}%6sMB${RESET} ${cpu_color}%5.1f%%${RESET} ${GRAY}%6s${RESET}  ${MAGENTA}%s${RESET}\n" \
      "$pid" "$mem" "$cpu" "$time_fmt" "$framework")
    result+=$'\n'
  fi
done < <(echo "$ps_output" | grep -E 'jest|vitest|playwright|cypress|pytest' | grep -v 'grep\|Helper\|Renderer\|test-watchers\|bash.*-c' | head -10)

if [[ -z "$result" ]]; then
  echo -e "${GRAY}(none running)${RESET}"
else
  echo -e "${BOLD}${WHITE}   PID     MEM    CPU    TIME  FRAMEWORK${RESET}"
  echo -e "$result"
fi
