# Japanese input
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

wineserver -p

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 24h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

alias pkexec='pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY'
source ~/.bashrc

if [ -e /home/ym/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ym/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
