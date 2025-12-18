#!/bin/bash
# Detects running dev servers: yarn, npm, pnpm, vite, esbuild, next, webpack, turbo, storybook
# Output format: Memory, CPU%, truncated command (with ANSI colors)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
WHITE='\033[37m'
GRAY='\033[90m'

# Capture process list first to avoid matching ourselves
ps_output=$(ps -eo pid,pcpu,rss,command 2>/dev/null)

result=$(echo "$ps_output" | \
  grep -E 'yarn|npm run|pnpm|vite|esbuild|next dev|webpack|turbo|storybook' | \
  grep -v 'grep\|Helper\|Renderer\|dev-servers\|bash.*-c' | \
  awk -v reset="$RESET" -v red="$RED" -v green="$GREEN" -v yellow="$YELLOW" -v cyan="$CYAN" -v white="$WHITE" '{
    cpu=$2
    mem=$3/1024
    # Build simplified command from $4 onwards
    cmd=""
    for(i=4;i<=NF;i++) {
      part=$i
      # Extract just the binary name from paths
      gsub(/.*\//, "", part)
      # Skip long arguments and flags
      if (length(part) > 30) continue
      if (part ~ /^--/) continue
      cmd=cmd" "part
      # Limit output length
      if (length(cmd) > 40) break
    }
    if (cmd != "") {
      # Color for memory: green <500MB, yellow <2000MB, red >=2000MB
      if (mem < 500) mem_color = green
      else if (mem < 2000) mem_color = yellow
      else mem_color = red
      
      # Color for CPU: white <10%, yellow <50%, red >=50%
      if (cpu < 10) cpu_color = white
      else if (cpu < 50) cpu_color = yellow
      else cpu_color = red
      
      printf "%s%6.0fMB%s %s%5.1f%%%s %s%s%s\n", mem_color, mem, reset, cpu_color, cpu, reset, cyan, cmd, reset
    }
  }' | head -10)

if [ -z "$result" ]; then
  echo -e "${GRAY}(none running)${RESET}"
else
  echo -e "${BOLD}${WHITE}   MEM     CPU   COMMAND${RESET}"
  echo -e "$result"
fi
