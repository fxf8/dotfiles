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

    function mkcd ()
        mkdir -p $argv[1] && cd $argv[1]
    end

    function mkpd ()
        mkdir -p $argv[1] && pushd $argv[1]
    end

    function mkts ()
        pushd $(tempenv -n $argv[1])
    end

    set -x fzf_fd_opts --hidden --exclude=.git

    function _fzf_home_depth_2 ()
        set fzf_fd_opts --base-directory $HOME --hidden --exclude=.git --max-depth=2 --type d -a
        _fzf_search_directory
        set -x fzf_fd_opts --hidden --exclude=.git
    end

    bind --mode insert \cp _fzf_home_depth_2
    fzf_configure_bindings --directory=\co
end

set PREV_COMMANDS_RUN 0
set fish_greeting

# aliases

alias clipboard="xclip -sel clip" 
alias icat="kitty +kitten icat"

export PATH="/usr/local/shortcuts:$PATH"

thefuck --alias | source
