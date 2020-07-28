# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Sperm
# ^ That joke doesn't work anymore
PS1="\[\033[01;31m\]\h \[\033[0m\]:: \[\033[00;34m\]\W \[\033[0m\]= "

export GOPATH="/home/ym/Drive/Projects/Go/"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export DIRENV_LOG_FORMAT=
export WINEPREFIX="$HOME/Drive/.wine"

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
export XDG_DESKTOP_DIR="/tmp"
export _Z_DATA="$HOME/.config/fasd/database"
export _FASD_DATA="$HOME/.config/fasd/database"
export _FASD_MAX=10000
export PATH="$PATH:$HOME/bin:$GOPATH/bin:$CARGO_HOME/bin:$HOME/.local/bin"
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/config"

export FZF_DEFAULT_COMMAND="rg --no-pcre2-unicode --no-config --files --no-messages --no-ignore --hidden --follow -g '!{.git,.cache}'"
export FZF_DEFAULT_OPTS="--reverse --inline-info --preview='~/bin/preview.sh {}' --bind '?:toggle-preview' --tabstop=1 --ansi"
export LESSHISTFILE=-
export WEECHAT_HOME="~/.config/weechat/"
export _JAVA_AWT_WM_NONREPARENTING=1

shopt -s globstar

alias watch_vcd='mpv "-af=channelmap=1-0"'
alias lorw='lorri watch > /tmp/lorri_out 2>&1 & '
alias loli='tail -n 11 /tmp/lorri_out'

# lol use lorri instead
alias hsenv="nix-shell -p '(import <nixpkgs> {}).haskellPackages.ghcWithHoogle (pkgs: (pkgs.callPackage ./default.nix {}).buildInputs)'"
alias c='cat'
alias free='free -h'
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

alias xclip='xclip -selection clipboard'
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
alias orphan='sudo pacman -Rncs $(pacman -Qtdq)'
alias py='python'

alias o='a -e xdg-open'
alias k="killall"
alias less='less -r'
alias mount='sudo mount'
alias umount='sudo umount'
alias fuckingwindows="find . -type f -execdir dos2unix {} \;"
# I have no idea how this one works anymore, good luck future me if this ever stops working
alias recaudio='pacat --record -d "$(pacmd list | grep -P "^\s*name:.*\.monitor" | head -n1 | sed "s/\s*name\: <\(.*\)>/\1/g")" --file-format=wav ~/Media/ARecordings/$(date +"%F_%H-%M-%S").wav'

export ytdf="res:360p,worst-audio"
ytplay() {
	[[ $2 ]] && config="${@:2}" || config="$ytdf"
	ytdl  --filter="$config" -s -o - $1 | mpv --idle -
}

# TODO: use $@
t() {
	choice="$(fasd -l -r $1 | fzf --query="$1 " --select-1 --exit-0 --height=25% --reverse --tac --no-sort --cycle)"
	[[ $? != 0  ]] && return
	[[ -d "$choice" ]] && cd "$choice" || rifle "$choice"
}

# TODO(ym): These sometimes misbehave, possibly due to the way they feed the arguments into other programs
swallow() {
	"$@" & disown && exit
}

spawn() {
	"$@" & disown
}

rem() {
	sudo pacman -Rcns $@
}

zathura() {
	command zathura "$@" & disown
}

ff() {
	find . -iname "$@"
}

links() {
	ls $@ --color always | grep '\->'
}

mydunstify() {
	# docs ig
	appname="$1"
	icon="$2"
	summary="$3"
	content="$4"
	gdbus call -e -d "org.freedesktop.Notifications" -o /org/freedesktop/Notifications -m org.freedesktop.Notifications.Notify "$appname" 0 "$icon" "$summary" "$content" "[]" "{}" 5000
}

timer() {
	for ((i=0; i < $1; i++)); {
		for ((j=0; j < 60; j++)); {
			echo -ne "\r$i:$j"
			sleep 1s
		}
		# it's not a bug it's a feature
		echo
	}
	mpc play
}

delink() {
	# TIL about unset -f, thanks viz
	# TODO: use unset -f to solve this problem
	# NOTE(ym): not local to this function, so it'll get introduced to the environment when you invoke delink
	# and you can't make it local using the `local` keyword either
	# *sigh* bash
	delink_help() {
		echo "usage: delink <options> <symlinks>"
		echo "options: "
		echo " -m: use mv instead of cp"
		echo " -n: use the filename instead of symlink name"
	}

	[[ $# -eq 0 ]] && delink_help && return 0

	OPTIND=1
	local tool="cp -r"
	while getopts "hmn" opt $@; do
		case $opt in
			m) tool="mv" ;;
			n) n=1 ;;
			h) delink_help; return 0 ;;
			*) return 1 ;;
		esac
	done

	for link in "${@:$OPTIND}"; do
		link="$(realpath --no-symlinks $link)"
		[[ -L $link ]] && {
			path="$(realpath -e $link)"
			[[ $n = 1 ]] && filename="${link%/*}/${path##*/}" || filename="$link"
			rm "$link"
			$tool "$path" "$filename"
		} || echo "Broken link or not a symlink: $link"
	done
}

sxiv() {
	[[ $# -eq 0 ]] && args='.' || args="$@"
	command sxiv -ar $args & disown
}

stty -ixon # dont freeze the shel when c-s is pressed
# sudo rmmod pcspkr
if [[  "$TERM" = "linux" ]]; then
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

for i in ~/Projects/fzf/shell/*.bash; do . "$i"; done
. /home/ym/.nix-profile/etc/profile.d/nix.sh # Sourced in .bash_profile too, maybe i should remove this?
# eval "$(fasd --init auto)"
eval "$(direnv hook bash)"
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

[[ ! $DISPLAY && $XDG_VTNR == 1 ]] && startx
