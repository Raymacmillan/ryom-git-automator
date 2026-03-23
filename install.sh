#!/usr/bin/env bash
set -e

# Load core for colors if available locally
[[ -f "lib/core.sh" ]] && source "lib/core.sh"

REAL_PATH="$(readlink -f bin/ryom)"
TARGET="/usr/local/bin/ryom"

echo -e "${BLUE}>>> Installing Ryom CLI...${NC}"
read -p "Proceed with installation? (y/q): " inst_choice

# Since check_quit might not be sourced yet, we do a manual check
[[ "$inst_choice" == "q" ]] && echo "Installation aborted." && exit 0

if sudo ln -sf "$REAL_PATH" "$TARGET"; then
    echo -e "${GREEN}[SUCCESS]${NC} 'ryom' is now a global command."
else
    echo -e "${RED}[FATAL]${NC} Permissions denied."
    exit 1
fi