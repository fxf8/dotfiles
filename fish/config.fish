if status is-interactive
    # Commands to run in interactive sessions can go here

    alias nv "nvim"
    alias lsa "ls -AChs --group-directories-first"

    set -x PATH "$PATH:$HOME/.cargo/bin" # cargo binaries
    set -x PATH "$PATH:$HOME/go/bin" # golang binaries
    set -x PATH "$PATH:/usr/lib/emscripten"
    set -x PATH "$PATH:$HOME/.local/bin"
    set -x PATH "$PATH:/usr/lib/jvm/java-21-openjdk/bin/"

    set -x ANDROID_HOME "/opt/android-sdk"
    set -x PATH "$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin"

    set -x JAVA_HOME "/usr/lib/jvm/java-8-openjdk/"
    set -x ANDROID_SDK_ROOT "/opt/android-sdk"

    set -x QT_QPA_PLATFORM_PLUGIN_PATH "/opt/android-sdk/emulator/lib64/qt/"



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
