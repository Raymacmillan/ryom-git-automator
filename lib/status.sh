#!/usr/bin/env bash

ryom_status() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        die "Not a Git repository. Run 'ryom save' to initialize."
    fi

    CURRENT_BRANCH=$(git branch --show-current)
    BRANCH_TAG="${YELLOW} $CURRENT_BRANCH${NC}"
    
    echo -e "\n${BLUE}========== RYOM DASHBOARD ==========${NC}"
    echo -e "${CYAN}[CONTEXT]${NC} Currently on $BRANCH_TAG"
    
    # Check Remote Sync Status
    UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "none")
    if [[ "$UPSTREAM" == "none" ]]; then
        echo -e "${YELLOW}[REMOTE]${NC}  No upstream linked."
    else
        BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
        AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
        echo -e "${CYAN}[SYNC]${NC}    Ahead: $AHEAD | Behind: $BEHIND"
    fi

    # File Stats
    MODIFIED=$(git diff --name-only | wc -l)
    UNTRACKED=$(git ls-files --others --exclude-standard | wc -l)
    STAGED=$(git diff --cached --name-only | wc -l)

    echo -e "\n${BLUE}>>> Workspace Stats:${NC}"
    echo -e "  - Staged:   ${GREEN}$STAGED${NC}"
    echo -e "  - Modified: ${YELLOW}$MODIFIED${NC}"
    echo -e "  - New:      ${RED}$UNTRACKED${NC}"
    
    TOTAL=$((MODIFIED + UNTRACKED + STAGED))
    if [[ $TOTAL -eq 0 ]]; then
        echo -e "\n${GREEN}✨ Workspace is clean.${NC}"
    else
        echo -e "\n${YELLOW}Advice:${NC} You have $TOTAL unsaved changes. Run 'ryom save'."
    fi
    echo -e "${BLUE}====================================${NC}\n"
}