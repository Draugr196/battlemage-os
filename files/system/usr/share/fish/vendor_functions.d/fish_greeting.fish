function fish_greeting --description 'Battlemage welcome message'
    status is-interactive; or return

    set -l accent (set_color --bold brmagenta)
    set -l title (set_color --bold white)
    set -l cmd (set_color --bold cyan)
    set -l reset (set_color normal)

    echo
    echo -s "  " $title "Welcome to Battlemage" $reset
    echo -s "  " $accent "──────────────────────────────────────────" $reset
    echo -s "  " $accent "»" $reset " Run " $cmd "battlemage-help" $reset " to list the built-in commands."
    echo
end
