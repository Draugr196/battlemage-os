function battlemage-help --description 'Show Battlemage built-in commands and tips'
    set -l accent (set_color --bold brmagenta)
    set -l head (set_color --bold white)
    set -l cmd (set_color --bold cyan)
    set -l key (set_color --bold yellow)
    set -l dim (set_color brblack)
    set -l link (set_color --underline blue)
    set -l reset (set_color normal)

    function __bm_section --no-scope-shadowing
        echo
        echo -s "  " $accent "◆ " $head $argv[1] $reset
        echo -s "  " $dim "──────────────────────────────────────────────" $reset
    end

    function __bm_row --no-scope-shadowing
        printf "    %s%-22s%s %s\n" $cmd $argv[1] $reset $argv[2]
    end

    function __bm_key --no-scope-shadowing
        printf "    %s%-22s%s %s\n" $key $argv[1] $reset $argv[2]
    end

    echo
    echo -s "  " $accent "⚔  " $head "Battlemage Help" $reset

    __bm_section "Updating the system"
    __bm_row "battlemage-update" "Update the whole system in one step"

    __bm_section "Running as root: run0 replaces sudo"
    echo -s "    " $dim "Battlemage uses systemd's run0 instead of sudo." $reset
    __bm_row "run0 <command>" "Run a single command as root"
    __bm_row "run0" "Open a root shell"
    __bm_row "run0 -u <user> <cmd>" "Run a command as another user"

    __bm_section "Navigation: cd is powered by zoxide"
    echo -s "    " $dim "cd remembers where you go and jumps by partial name." $reset
    __bm_row "cd <path>" "Works like a normal cd"
    __bm_row "cd <keyword>" "Jump to the best match, e.g. cd proj"
    __bm_row "cd <kw1> <kw2>" "Narrow the match with more keywords"
    __bm_row "cdi" "Pick a directory interactively"
    __bm_row "cd -" "Go back to the previous directory"

    __bm_section "Fuzzy finding with fzf"
    __bm_key "Ctrl+R" "Search command history"
    __bm_key "Ctrl+T" "Find a file and insert its path"
    __bm_key "Alt+C" "Find a directory and cd into it"
    echo -s "    " $dim "Type to filter, ↑/↓ to move, Enter to select, Esc to cancel." $reset

    echo
    functions --erase __bm_section __bm_row __bm_key
end
