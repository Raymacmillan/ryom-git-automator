#!/usr/bin/env bash

ryom_save() {
    # 1. Repository Guardrail
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${YELLOW}[NOTICE]${NC} Not a Git repository."
        read -p "Initialize now? (y/n/q): " init_choice
        check_quit "$init_choice"
        [[ "$init_choice" != "y" ]] && return
        git init &>/dev/null && git branch -M main &>/dev/null
        echo -e "${GREEN}[SUCCESS]${NC} Initialized on 'main'."
    fi

    # 2. Branch Navigation
    while true; do
        CURRENT_BRANCH=$(git branch --show-current)
        BRANCH_TAG="${YELLOW}( $CURRENT_BRANCH)${NC}"
        
        echo -e "\n${BLUE}>>> Navigation $BRANCH_TAG${NC}"
        echo -e "Options: (s)tay, (c)hange, (n)ew, or (q)uit"
        read -p "> " branch_action
        check_quit "$branch_action"

        case $branch_action in
            c)
                mapfile -t branches < <(git branch --format='%(refname:short)')
                echo -e "${YELLOW}Select branch number (or 'q'):${NC}"
                select b in "${branches[@]}" "Cancel"; do
                    [[ -n "$REPLY" ]] && check_quit "$REPLY"
                    if [[ "$b" == "Cancel" ]]; then break;
                    elif [[ -n "$b" ]]; then
                        git checkout "$b" && break 2 
                    fi
                done ;;
            n)
                read -p "New branch name: " NEW_B
                check_quit "$NEW_B"
                [[ -n "$NEW_B" ]] && git checkout -b "$NEW_B" ;;
            s) break ;; 
        esac
    done

    # 3. File Discovery (Deep Search)
    mapfile -t files < <(git ls-files --others --modified --exclude-standard)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${GREEN}[CLEAN]${NC} Nothing to save on $BRANCH_TAG."
        return
    fi

    # 4. Atomic vs Global Strategy
    echo -e "\n${BLUE}>>> Strategy Select $BRANCH_TAG${NC}"
    echo -e "1) Single Commit (All files)\n2) Atomic Commits (One-by-one)\n3) Quit"
    read -p "#? " strat
    check_quit "$strat"

    if [[ "$strat" == "1" ]]; then
        git add .
        _get_commit_details "$BRANCH_TAG"
        _perform_commit "$PREFIX: $DESC"
    elif [[ "$strat" == "2" ]]; then
        for file in "${files[@]}"; do
            echo -e "\n${BLUE}>>> Working on:${NC} ${YELLOW}$file${NC} $BRANCH_TAG"
            read -p "Action: (c)ommit, (s)kip, or (q)uit: " act
            check_quit "$act"
            if [[ "$act" == "c" ]]; then
                git add "$file"
                _get_commit_details "$BRANCH_TAG"
                _perform_commit "$PREFIX: $DESC"
            fi
        done
    fi
}

# --- Internal Helpers with Omni-Quit ---

_get_commit_details() {
    local tag=$1
    echo -e "${YELLOW}Type (feat/fix/docs/refactor) or 'q':${NC}"
    read -p "> " T
    check_quit "$T"
    PREFIX=$T
    
    echo -e "${YELLOW}Message for $tag:${NC}"
    read -p "> " D
    check_quit "$D"
    DESC=$D
}

_perform_commit() {
    echo -ne "${YELLOW}[COMMITTING]${NC} ... "
    git commit -m "$1" &>/dev/null
    echo -e "${GREEN}DONE${NC}"
}