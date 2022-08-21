# Do not load these options if the session is not interactive.
if [[ $- != *i* ]]; then
	return 1
fi

# Set emacs mode.
bindkey -e

# use end-of-line instead of autosuggest-accept to preserve syntax highlighting
bindkey '^[[Z' end-of-line

zstyle :compinstall filename '$ZDOTDIR/.zshrc'

autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt glob_dots

export HISTPATH="$XDG_STATE_HOME/zsh"
export HISTFILE="$HISTPATH/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000

if [[ ! -d "$HISTPATH" ]]; then
	mkdir -p "$HISTPATH"
fi

export LESSHISTFILE=-
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias vim='nvim'
alias vimdiff='nvim -d -c "tabdo windo set nolist"'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias history='history -i'
alias tb='nc termbin.com 9999'
alias ls='exa -g --group-directories-first'

case "$OSTYPE" in
"linux"*)
	alias ip='ip -color=auto'
	alias dmesg='dmesg --color=always'
	alias weechat='firejail --private=${HOME}/jails/weechat -- weechat'
	;;
"darwin"*)
	alias brewup='brew cleanup; brew doctor && brew update && brew upgrade'
	;;
esac

source "$ZDOTDIR/history-complete.zsh"
source "$ZDOTDIR/zinit-install.zsh"

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Launch tmux if not already running within tmux.
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
	tmux;
fi
