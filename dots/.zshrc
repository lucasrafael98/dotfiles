export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

source ~/Documents/.etc/env.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/gitstatus.zsh
source ~/.config/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ~/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
zvm_after_init_commands+=('[ -f ~/.config/zsh/fzf-keybinds.zsh ] && source ~/.config/zsh/fzf-keybinds.zsh')
zvm_after_init_commands+=('[ -f ~/.config/zsh/completion.zsh ] && source ~/.config/zsh/completion.zsh')

HISTFILE=~/.config/zsh/history
HISTSIZE=100000000
SAVEHIST=100000000
WORDCHARS='*?_[]~=&;!$%^(){}<>'
export EDITOR=nvim
export LESSHISTFILE=
export FZF_DEFAULT_COMMAND="find -L -type f | rg -v .git/ | sed -E 's/^\.\///g'"
export PGSERVICEFILE="$HOME/.config/psql/pg_service.conf"
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

# make tab completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

unsetopt beep 
unsetopt extendedglob

export PATH=$GOPATH/bin:~/.local/bin:~/.local/share/kafka/bin:$PATH
export GOROOT=/usr/lib/go/
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

# https://github.com/romkatv/powerlevel10k/issues/1092#issuecomment-723039693
# Display $1 in terminal title.
function set-term-title() {
	emulate -L zsh
	if [[ -t 1 ]]; then
		print -rn -- $'\e]0;'${(V)1}$'\a'
	elif [[ -w $TTY ]]; then
		print -rn -- $'\e]0;'${(V)1}$'\a' >$TTY
	fi
}

# When a command is running, display it in the terminal title.
function set-term-title-preexec() {
	set-term-title ${(V%):-"$1: %2~"}
}

# When no command is running, display the current directory in the terminal title.
function set-term-title-precmd() {
	set-term-title ${(V%):-"zsh: %2~"}
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec set-term-title-preexec
add-zsh-hook precmd set-term-title-precmd

alias rm='rm -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias ls='exa'
alias la='exa -la'
alias v='nvim'
alias sv='sudo nvim'
alias jsed="sed -E 's/^\\\"|\\\\|\\\"$//g'"
alias b64e='base64 | xargs | tr -d " "'
alias gb='fzf-git-checkout'
alias redis="iredis --iredisrc $HOME/.config/iredis/rc"
alias bat='batcat'

setopt PROMPT_SUBST
# kitty doesn't make bold colors bright.
bgreen=$'%{\033[38;5;10m%}'
bblue=$'%{\033[38;5;12m%}'
PS1=$'%B$bgreen%n%{\e[0m%}%b  %B$bblue%2~%{\e[0m%}%b$(gitstatus) %# '
