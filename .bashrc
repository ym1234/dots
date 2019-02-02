# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Sperm
PS1='\W> '

localectl set-x11-keymap us,ar pc104 dvorak,qwerty grp:ctrls_toggle,terminate:ctrl_alt_bksp

set menu-complete-display-prefix on
set completion-ignore-case on
set show-all-if-ambiguous on
set colored-stats on
set bell-style none
export GOPATH="/home/ym/Drive/Projects/Go/"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"

export XDG_DESKTOP_DIR="/tmp"
export _FASD_DATA="$HOME/.config/fasd/database"
export _FASD_MAX=10000
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$CARGO_HOME/bin
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim -c "set ft=man" -'
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/config"

export FZF_DEFAULT_COMMAND="rg --no-pcre2-unicode --no-config --files --no-messages --no-ignore --hidden --follow -g '!{.git,.cache}'"
export FZF_DEFAULT_OPTS="--reverse --inline-info --preview='~/bin/preview.sh {}' --bind '?:toggle-preview' --tabstop=1 --ansi"
export LESSHISTFILE=-
export WEECHAT_HOME="~/.config/weechat/"
export _JAVA_AWT_WM_NONREPARENTING=1

alias ncpamixer="ncpamixer --config=$HOME/.config/ncpamixer/ncpamixer.conf"
alias ls='exa'
alias lt='exa -T'
alias ll='exa -l'
alias llt='exa -lT'
alias la='exa -la'
alias lat='exa -lTa'

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../.."

alias cbsp='nvim ~/.config/bspwm/bspwmrc ~/.config/bspwm/external_rules ~/.config/sxhkd/sxhkdrc'
alias csh='nvim ~/.bashrc ~/.bash_profile'
alias cvi='nvim ~/.config/nvim/init.vim'

alias v='f -e nvim'
alias vi='nvim'

alias gr='go run $(find . -maxdepth 1 -not -iname \*_test.go -iname \*.go)'
alias md='mkdir -p'
alias ss='source ~/.bashrc'
alias rd='rm -r'

alias gi='git init'
alias gs='git status'
alias gl='git log --all --decorate --oneline --graph'
alias ga='git add'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gaa='git add -A'
alias gup='gaa; gc; gp'

alias cfg='git --git-dir=$HOME/Documents/dots/ --work-tree=$HOME'
alias up='yay -Syyu'
alias orphan='sudo pacman -Rncs $(pacman -Qtdq)'
alias py='python'

alias o='a -e xdg-open'
alias k="killall"
# alias less='less -rRFX'
alias mount='sudo mount'
alias umount='sudo umount'
alias fuckingwindows="find . -type f -execdir dos2unix {} \;"

export ytdf="res:360p,worst-audio"
ytplay() {
	[ $2 ] && config="${@:2}" || config="$ytdf"
	ytdl  --filter="$config" -s -o - $1 | mpv --idle -
}

t() {
	fasdlist=$( fasd -l -r $1 | fzf --query="$1 " --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)
	directory=$(file "$fasdlist" | grep directory)
	[[ $directory == "" ]] && xdg-open "$fasdlist" || cd "$fasdlist"
}

rem() {
	sudo pacman -Rcns "$@"
}

zathura() {
	command zathura "$@" & disown
}

ff() {
	find . -iname "$@"
}

links() {
	ls -al $@ --color always | grep '\->'
}

# TODO(ym): implement the options
delink() {
	[[ $# -eq 0 ]] && {
		echo "usage: delink <options> <symlinks>"
		echo "options: (Not implemented yet)"
		echo " -m: use mv instead of cp"
		echo " -n: use the filename instead of symlink name"
		exit 0
	}
	for link; do
		[[ -L $link && -e $link ]] && {
			path="$(readlink -f $link)"
			rm $link
			cp -r $path $link
		} || echo "Broken link or not a symlink: $link"
	done
}

sxiv() {
	[[ $# -eq 0 ]] && {
		command sxiv -a -r . & disown
	} || {
		command sxiv -a "$@" & disown
	}
}

if [ "$TERM" = "linux" ]; then
	echo -en "\e]P01D1F21" # black
	echo -en "\e]P8282A2E" # darkgrey
	echo -en "\e]P1A54242" # darkred
	echo -en "\e]P9CC6666" # red
	echo -en "\e]P28C9440" # darkgreen
	echo -en "\e]PAB5BD68" # green
	echo -en "\e]P3DE935F" # brown
	echo -en "\e]PBF0C674" # yellow
	echo -en "\e]P45F819D" # darkblue
	echo -en "\e]PC81A2BE" # blue
	echo -en "\e]P585678F" # darkmagenta
	echo -en "\e]PD85678F" # magenta
	echo -en "\e]P65E8D87" # darkcyan
	echo -en "\e]PE8ABEB7" # cyan
	echo -en "\e]PFdedede" # lightgrey
	echo -en "\e]P7C5C8C6" # white
	setterm -blength 0     # stop the fucking bell
	clear                  # for background artifacting
fi

for i in $GOPATH/src/github.com/junegunn/fzf/shell/*.bash; do
	source $i
done
eval "$(fasd --init auto)"

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then
	startx
fi
