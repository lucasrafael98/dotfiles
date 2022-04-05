if [ -e /home/jlr/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jlr/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/gitstatus.zsh
source ~/.config/zsh/zsh-completions/zsh-completions.plugin.zsh

fpath=(~/.nix-profile/share/zsh/site-functions $fpath)
HISTFILE=~/.config/zsh/history
HISTSIZE=100000000
SAVEHIST=100000000
WORDCHARS='*?_[]~=&;!$%^(){}<>'
export EDITOR=nvim
export LESSHISTFILE=
export PGSERVICEFILE="$HOME/.config/psql/pg_service.conf"

autoload -Uz compinit
compinit -d ~/.config/zsh/zcompdump
zstyle :compinstall filename '/home/jlr/.zshrc'

unsetopt beep 
unsetopt extendedglob
bindkey -e
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

export PATH=$PATH:~/go/bin:~/.local/bin
export GOROOT=$(go env GOROOT)

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

setopt PROMPT_SUBST
PS1='%B%F{green}%n%f%b  %B%F{blue}%2~%f%b$(gitstatus) %# '
