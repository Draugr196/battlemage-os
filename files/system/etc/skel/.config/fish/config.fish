if status is-interactive

    alias ls="eza -x --icons=always"
    alias la="eza -xa --icons=always"
    alias ll="eza -la --icons=always"
    alias lt="eza -TRa --icons=always"
    alias cd="z"
    alias battlemage-update='run0 fish -c "bootc update"'

    set -gx FZF_DEFAULT_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head --200'"
    
    set -g fish_greeting "Welcome to Battlemage OS! Run (set_color yellow)battlemage-help(set_color --reset) for a list of added/altered commands."

    function battlemage-help
        echo "Updates: Manual updates can be triggered by running (set_color yellow)battlemage-update(set_color --reset)."
        echo "Priviledged Access: (set_color yellow)Sudo(set_color --reset) has been replaced with (set_color yellow)run0(set_color --reset). Run0 is integrated into the latest versions of Systemd and allows elevation with out risky subuids."
        echo "Fuzzy Find: Fzf command binds have been added and cd has been aliased to run Zoxide instead for enhanced searching (ie cd projects could point to /home/user/git/projects)."
        echo "Shell: The default shell for Battlemage is the Friendly Interactive SHell (fish). Configs can be found at ~/.config/fish. Documentation is at fishshell.com"
    end

    zoxide init fish | source
    fzf --fish | source
end
