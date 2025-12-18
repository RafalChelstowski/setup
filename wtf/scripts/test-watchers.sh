#!/bin/bash
# Detects running test watchers: jest, vitest, playwright, cypress, pytest
# Output format: Memory, CPU%, test framework (with ANSI colors)

# ANSI color codes
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
WHITE='\033[37m'
GRAY='\033[90m'

# Capture process list first to avoid matching ourselves
ps_output=$(ps -eo pid,pcpu,rss,command 2>/dev/null)

result=$(echo "$ps_output" | \
  grep -E 'jest|vitest|playwright|cypress|pytest' | \
  grep -v 'grep\|Helper\|Renderer\|test-watchers\|bash.*-c' | \
  awk -v reset="$RESET" -v red="$RED" -v green="$GREEN" -v yellow="$YELLOW" -v magenta="$MAGENTA" -v white="$WHITE" '{
    cpu=$2
    mem=$3/1024
    # Build command string
    cmd_str=""
    for(i=4;i<=NF;i++) cmd_str=cmd_str" "$i
    
    # Identify the test framework from actual binary/script
    framework=""
    if (cmd_str ~ /node.*jest|jest\.js|jest-worker/ && cmd_str !~ /majest/) framework="jest"
    else if (cmd_str ~ /node.*vitest|vitest\.mjs/) framework="vitest"
    else if (cmd_str ~ /playwright/) framework="playwright"
    else if (cmd_str ~ /cypress/) framework="cypress"
    else if (cmd_str ~ /python.*pytest|pytest/) framework="pytest"
    
    if (framework != "") {
      # Color for memory: green <500MB, yellow <2000MB, red >=2000MB
      if (mem < 500) mem_color = green
      else if (mem < 2000) mem_color = yellow
      else mem_color = red
      
      # Color for CPU: white <10%, yellow <50%, red >=50%
      if (cpu < 10) cpu_color = white
      else if (cpu < 50) cpu_color = yellow
      else cpu_color = red
      
      printf "%s%6.0fMB%s %s%5.1f%%%s  %s%s%s\n", mem_color, mem, reset, cpu_color, cpu, reset, magenta, framework, reset
    }
  }' | head -10)

if [ -z "$result" ]; then
  echo -e "${GRAY}(none running)${RESET}"
else
  echo -e "${BOLD}${WHITE}   MEM     CPU   FRAMEWORK${RESET}"
  echo -e "$result"
fi
