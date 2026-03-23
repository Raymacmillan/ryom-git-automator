#!/usr/bin/env bash

# --- 1. The Standard Sync (Current Branch Handshake) ---
ryom_sync() {
    CURRENT_BRANCH=$(git branch --show-current)
    BRANCH_TAG="${YELLOW}( $CURRENT_BRANCH)${NC}"

    if ! git diff-index --quiet HEAD --; then
        echo -e "${RED}[ERROR]${NC} Uncommitted changes detected."
        read -p "Type 'save' to commit first, or 'q' to quit: " sync_err
        check_quit "$sync_err"
        return
    fi

    echo -e "${BLUE}>>> Syncing $BRANCH_TAG with Remote...${NC}"

    # Fetch updates silently
    echo -ne "${YELLOW}[FETCHING]${NC} Checking updates... "
    git fetch origin &>/dev/null
    echo -e "${GREEN}DONE${NC}"

    echo -e "\n${YELLOW}Integration Strategy:${NC}"
    echo "1) Rebase  2) Merge  3) Push Only  q) Quit"
    read -p "> " sync_choice
    check_quit "$sync_choice"

    case $sync_choice in
        1) git pull --rebase origin "$CURRENT_BRANCH" || _handle_conflict "rebase" ;;
        2) git pull origin "$CURRENT_BRANCH" || _handle_conflict "merge" ;;
        3) echo "Skipping pull..." ;;
    esac

    echo -ne "${YELLOW}[PUSHING]${NC} Sending to GitHub... "
    if git push origin "$CURRENT_BRANCH" &>/dev/null; then
        echo -e "${GREEN}SUCCESS${NC}"
    else
        echo -e "${RED}FAILED${NC}. Try rebasing first."
    fi
}

# --- 2. THE NEW PULL (Inter-branch logic) ---
ryom_pull() {
    echo -e "${BLUE}>>> Fetching Remote Data...${NC}"
    git fetch origin &>/dev/null

    # Get a list of remote branches
    mapfile -t remotes < <(git branch -r | grep "origin/" | grep -v "HEAD" | sed 's/  origin\///')
    
    echo -e "${YELLOW}Which remote branch do you want to pull into your current work?${NC}"
    select rb in "${remotes[@]}" "Cancel"; do
        [[ -n "$REPLY" ]] && check_quit "$REPLY"
        if [[ "$rb" == "Cancel" ]]; then return;
        elif [[ -n "$rb" ]]; then
            TARGET=$rb
            break
        fi
    done

    echo -e "\n${CYAN}[PULL STRATEGY]${NC} for origin/$TARGET:"
    echo "1) Rebase (Linear)  2) Merge (Classic)  q) Quit"
    read -p "> " p_choice
    check_quit "$p_choice"

    echo -ne "${YELLOW}[PULLING]${NC} ... "
    if [[ "$p_choice" == "1" ]]; then
        git pull --rebase origin "$TARGET" &>/dev/null
    else
        git pull origin "$TARGET" &>/dev/null
    fi
    echo -e "${GREEN}DONE${NC}"
}

# --- Internal Conflict Helper ---
_handle_conflict() {
    local mode=$1
    echo -e "\n${RED}!!! CONFLICT !!!${NC}"
    read -p "1) Abort  2) Manual Fix  q) Quit: " c_act
    check_quit "$c_act"

    if [[ "$c_act" == "1" ]]; then
        [[ "$mode" == "rebase" ]] && git rebase --abort || git merge --abort
        echo "Action aborted."
    else
        echo "Fix markers (<<<<), then run 'git $mode --continue'."
        exit 0
    fi
}