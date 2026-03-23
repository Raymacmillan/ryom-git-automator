#!/usr/bin/env bash

# UI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'  
MAGENTA='\033[0;35m' 
NC='\033[0m'

die() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# Global Quit Function
ryom_quit() {
    echo -e "\n${BLUE}>>> Powering down Ryom CLI...${NC}"
    echo -e "${YELLOW}Stay productive, Philosopher-Builder.${NC}"
    exit 0
}

# Universal Quit Check
check_quit() {
    if [[ "$1" == "quit" || "$1" == "q" ]]; then
        ryom_quit
    fi
}

# Progress Spinner
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}