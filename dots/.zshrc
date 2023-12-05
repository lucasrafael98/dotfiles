export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export LANG="en_US.UTF-8" # terminal output is weird in portuguese

HISTFILE=~/.config/zsh/history
HISTSIZE=100000000
SAVEHIST=100000000
WORDCHARS='*?_[]~=&;!$%^(){}<>'
export EDITOR=nvim
export LESSHISTFILE=-
export FZF_DEFAULT_COMMAND="find -L -type f | rg -v .git/ | sed -E 's/^\.\///g'"
export PGSERVICEFILE="$HOME/.config/psql/pg_service.conf"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GOPATH="$XDG_DATA_HOME"/go
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export GOROOT=/usr/lib/go
export PATH=$GOPATH/bin:~/.local/bin:~/.local/share/kafka/bin:~/.local/share/npm/bin:/opt/homebrew/bin:$PATH

if [ "$LR_SYSTEM" = "mac" ]; then
	# stop homebrew spying
	HOMEBREW_NO_AUTO_UPDATE=1
	HOMEBREW_NO_ANALYTICS=1
	export HOMEBREW_NO_AUTO_UPDATE HOMEBREW_NO_ANALYTICS
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export PATH=/opt/homebrew/bin:$PATH
	export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
	. /opt/homebrew/opt/asdf/libexec/asdf.sh
	source /opt/homebrew/share/antigen/antigen.zsh
	antigen bundle robbyrussell/oh-my-zsh plugins/aws
	antigen bundle zsh-users/zsh-syntax-highlighting
	antigen bundle jeffreytse/zsh-vi-mode
	antigen bundle zsh-users/zsh-completions
	antigen bundle lucasrafael98/zsh-git-funcs
	antigen apply
	zvm_after_init_commands+=('source /opt/homebrew/opt/fzf/shell/completion.zsh')
	zvm_after_init_commands+=('source /opt/homebrew/opt/fzf/shell/key-bindings.zsh')
elif [ "$LR_SYSTEM" = "linux" ]; then
	export CARGO_HOME="$XDG_DATA_HOME"/cargo
	export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
	export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
	export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
	export KDEHOME="$XDG_CONFIG_HOME"/kde
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source ~/.config/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
	source ~/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
	source $HOME/.nix-profile/etc/profile.d/nix.sh
	zvm_after_init_commands+=('source /usr/share/doc/fzf/examples/completion.zsh')
	zvm_after_init_commands+=('source /usr/share/doc/fzf/examples/key-bindings.zsh')
	alias sudo='doas'
fi

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit -d $HOME/.config/zsh/zcompdump
zstyle :compinstall filename '/home/jlr/.zshrc'
complete -C aws_completer aws
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
source <(docker completion zsh)
rm -f $HOME/.zcompdump

# make tab completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

unsetopt beep 
unsetopt extendedglob
setopt histignorespace

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
alias jqc='jq --color-output'
alias lessc='less -R'
alias gw='./gradlew'

setopt PROMPT_SUBST
# kitty doesn't make bold colors bright.
bgreen=$'%{\033[38;5;10m%}'
bblue=$'%{\033[38;5;12m%}'

if [ "$LR_SYSTEM" = "mac" ]; then
	logo=""
elif [ "$LR_SYSTEM" = "linux" ]; then
	logo = "󰌽"
fi 

autoload -U colors && colors
PS1=$'%B${bgreen}lucasr%{\e[0m%}%b $logo %B$bblue%2~%{\e[0m%}%b$(gitstatus) %# '
