if status is-interactive

    alias ls="eza -x --icons=always"
    alias la="eza -xa --icons=always"
    alias ll="eza -la --icons=always"
    alias lt="eza -TRa --icons=always"
    alias cd="z"
    alias battlemage-update='run0 fish -c "bootc update"'

    set -gx FZF_DEFAULT_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head --200'"
    
    zoxide init fish | source
    fzf --fish | source
end
