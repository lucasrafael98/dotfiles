export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

if [ -e /home/jlr/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jlr/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
source ~/Documents/.etc/env.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/gitstatus.zsh
source ~/.config/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ~/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
zvm_after_init_commands+=('[ -f ~/.nix-profile/share/fzf/completion.zsh ] && source ~/.nix-profile/share/fzf/completion.zsh')
zvm_after_init_commands+=('[ -f ~/.nix-profile/share/fzf/key-bindings.zsh ] && source ~/.nix-profile/share/fzf/key-bindings.zsh')

fpath=(~/.nix-profile/share/zsh/site-functions $fpath)
HISTFILE=~/.config/zsh/history
HISTSIZE=100000000
SAVEHIST=100000000
WORDCHARS='*?_[]~=&;!$%^(){}<>'
export EDITOR=nvim
export LESSHISTFILE=
export FZF_DEFAULT_COMMAND="find -L -type f | rg -v .git/ | sed -E 's/^\.\///g'"
export PGSERVICEFILE="$HOME/.config/psql/pg_service.conf"
# https://unix.stackexchange.com/questions/187402/nix-package-manager-perl-warning-setting-locale-failed
export LOCALE_ARCHIVE="$(nix profile list | rg glibc-locales | awk '{print $4}')/lib/locale/locale-archive"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export GOPATH="$XDG_DATA_HOME"/go
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export KDEHOME="$XDG_CONFIG_HOME"/kde

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit -d $HOME/.config/zsh/zcompdump
zstyle :compinstall filename '/home/jlr/.zshrc'
complete -C aws_completer aws
eval "$(zoxide init zsh)"
rm ~/.zcompdump

# make tab completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

unsetopt beep 
unsetopt extendedglob

export PATH=$PATH:$GOPATH/bin:~/.local/bin
export GOROOT=$HOME/.nix-profile/share/go/
. "$HOME/.local/share/cargo/env"

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

alias rm='rm -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias ls='exa'
alias la='exa -la'
alias v='nvim'
alias sv='sudo nvim'
alias jsed="sed -E 's/^\\\"|\\\\|\\\"$//g'"
alias jbat='bat -l json'
alias b64e='base64 | xargs | tr -d " "'
alias gb='fzf-git-checkout'
alias redis="iredis --iredisrc $HOME/.config/iredis/rc"

setopt PROMPT_SUBST
# kitty doesn't make bold colors bright.
bgreen=$'%{\033[38;5;10m%}'
bblue=$'%{\033[38;5;12m%}'
PS1=$'%B$bgreen%n%{\e[0m%}%b  %B$bblue%2~%{\e[0m%}%b$(gitstatus) %# '
