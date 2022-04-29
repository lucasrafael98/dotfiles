if [ -e /home/jlr/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jlr/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"

GENCOMPL_PY=python3

source ~/work/env.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/gitstatus.zsh
source ~/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
source ~/.config/zsh/zsh-completion-generator/zsh-completion-generator.plugin.zsh
source ~/.nix-profile/share/fzf/completion.zsh
source ~/.nix-profile/share/fzf/key-bindings.zsh

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
export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit -d ~/.config/zsh/zcompdump
zstyle :compinstall filename '/home/jlr/.zshrc'
complete -C aws_completer aws
eval "$(zoxide init zsh)"

# make tab completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

unsetopt beep 
unsetopt extendedglob
bindkey -e
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

export PATH=$PATH:~/go/bin:~/.local/bin
export GOROOT=$HOME/.nix-profile/share/go/

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
alias la='exa -la@'
alias v='nvim'
alias sv='sudo nvim'
alias upd='sudo apt update && sudo apt full-upgrade && flatpak update && nix-channel --update && nix-env -u'
alias cleancache='rm -rf ~/.cache' # && sudo rm -rf /var/cache'
alias jsed="sed -E 's/^\\\"|\\\\|\\\"$//g'"
alias jbat='bat -l json'
alias b64e='base64 | xargs | tr -d " "'
alias gb='fzf-git-checkout'

setopt PROMPT_SUBST
# kitty doesn't make bold colors bright.
bgreen=$'%{\033[38;5;10m%}'
bblue=$'%{\033[38;5;12m%}'
PS1=$'%B$bgreen%n%{\e[0m%}%b  %B$bblue%2~%{\e[0m%}%b$(gitstatus) %# '
