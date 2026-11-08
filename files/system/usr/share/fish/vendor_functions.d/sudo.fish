function sudo --description 'sudo is not available on Battlemage; use run0'
    set -l warn (set_color --bold yellow)
    set -l cmd (set_color --bold cyan)
    set -l reset (set_color normal)

    echo >&2
    echo -s "  " $warn "⚠  sudo is not available on Battlemage." $reset >&2
    echo -s "     Use " $cmd "run0" $reset " instead. Run " $cmd "battlemage-help" $reset " for more info." >&2
    echo >&2
    return 1
end
