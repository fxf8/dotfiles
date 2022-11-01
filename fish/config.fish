if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.fishrc
end

set PREV_COMMANDS_RUN 0
set fish_greeting

# aliases

alias clipboard="xclip -sel clip" 
alias icat="kitty +kitten icat"
alias mt="source /usr/local/bin/source-tkn"

export PATH="/usr/local/shortcuts:$PATH"
