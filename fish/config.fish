if status is-interactive
    # Commands to run in interactive sessions can go here

    alias nv "nvim"
    alias lsa "ls -AChs --group-directories-first"

    export PATH="$PATH:$HOME/.cargo/bin" # cargo binaries
    export PATH="$PATH:$HOME/go/bin" # golang binaries
    export PATH="$PATH:/usr/lib/emscripten"
    export PATH="$PATH:$HOME/.local/bin"
    export PATH="$PATH:/usr/lib/jvm/java-20-openjdk/bin/"

    fish_vi_key_bindings
    bind --mode insert \cf accept-autosuggestion

    export EDITOR="nvim"
end

set PREV_COMMANDS_RUN 0
set fish_greeting

# aliases

alias clipboard="xclip -sel clip" 
alias icat="kitty +kitten icat"

export PATH="/usr/local/shortcuts:$PATH"

thefuck --alias | source
