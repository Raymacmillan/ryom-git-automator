#!/usr/bin/env bash

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

    # 1. Fetch
    echo -ne "${YELLOW}[FETCHING]${NC} Checking updates... "
    git fetch origin &>/dev/null
    echo -e "${GREEN}DONE${NC}"

    # 2. Strategic Choice
    echo -e "\n${YELLOW}Integration Strategy:${NC}"
    echo "1) Rebase  2) Merge  3) Push Only  q) Quit"
    read -p "> " sync_choice
    check_quit "$sync_choice"

    case $sync_choice in
        1) git pull --rebase origin "$CURRENT_BRANCH" || _handle_conflict "rebase" ;;
        2) git pull origin "$CURRENT_BRANCH" || _handle_conflict "merge" ;;
        3) echo "Skipping pull..." ;;
    esac

    # 3. Push
    echo -ne "${YELLOW}[PUSHING]${NC} Sending to GitHub... "
    if git push origin "$CURRENT_BRANCH" &>/dev/null; then
        echo -e "${GREEN}SUCCESS${NC}"
    else
        echo -e "${RED}FAILED${NC}. Try rebasing first."
    fi
}

_handle_conflict() {
    local mode=$1
    echo -e "\n${RED}!!! CONFLICT !!!${NC}"
    read -p "1) Abort  2) Manual Fix  q) Quit: " c_act
    check_quit "$c_act"

    if [[ "$c_act" == "1" ]]; then
        [[ "$mode" == "rebase" ]] && git rebase --abort || git merge --abort
    else
        echo "Fix markers (<<<<), then run 'git $mode --continue'."
        exit 0
    fi
}