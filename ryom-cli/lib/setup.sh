#!/usr/bin/env bash

ryom_setup() {
    echo -e "${BLUE}>>> Initializing Ryom Environment Setup...${NC}"
    OS_TYPE=$(uname -s)

    # 1. Dependency Check
    command -v git &> /dev/null || install_pkg "git"
    if [[ "$OS_TYPE" == "Linux" ]] && ! command -v xclip &> /dev/null; then
        install_pkg "xclip"
    fi

    # 2. Identity
    echo -e "${BLUE}>>> Checking Git identity...${NC}"
    EXISTING_NAME=$(git config --global user.name || echo "")
    EXISTING_EMAIL=$(git config --global user.email || echo "")

    if [[ -n "$EXISTING_NAME" ]]; then
        echo -e "${GREEN}[SKIP]${NC} Name: $EXISTING_NAME"
    else
        read -p "Enter Full Name: " USER_NAME
        [[ -z "$USER_NAME" ]] && die "Name is required."
        git config --global user.name "$USER_NAME"
    fi

    if [[ -n "$EXISTING_EMAIL" ]]; then
        echo -e "${GREEN}[SKIP]${NC} Email: $EXISTING_EMAIL"
        USER_EMAIL="$EXISTING_EMAIL"
    else
        while true; do
            read -p "Enter GitHub Email: " USER_EMAIL
            if [[ "$USER_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                git config --global user.email "$USER_EMAIL"
                break
            fi
            echo -e "${RED}[!]${NC} Invalid email format."
        done
    fi

    # 3. SSH
    SSH_DIR="$HOME/.ssh"
    KEY_PATH="$SSH_DIR/id_ed25519"
    [[ ! -d "$SSH_DIR" ]] && mkdir -p "$SSH_DIR" && chmod 700 "$SSH_DIR"

    if [[ -f "$KEY_PATH" ]]; then
        echo -e "${YELLOW}[SKIP]${NC} SSH key already exists."
    else
        echo -e "${BLUE}>>> Generating secure Ed25519 key...${NC}"
        ssh-keygen -t ed25519 -C "${USER_EMAIL:-$EXISTING_EMAIL}" -f "$KEY_PATH"
    fi

    # 4. Clipboard
    echo -ne "${BLUE}>>> Syncing key to clipboard... ${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pbcopy < "$KEY_PATH.pub"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xclip -selection clipboard < "$KEY_PATH.pub"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        clip < "$KEY_PATH.pub"
    fi
    echo -e "${GREEN}COPIED${NC}"

    # 5. Verify
    if ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1 | grep -q "Hi"; then
        echo -e "${GREEN}[SUCCESS]${NC} GitHub connection verified!"
    else
        echo -e "${YELLOW}[NOTICE]${NC} Paste your key into GitHub Settings to finish."
    fi
}