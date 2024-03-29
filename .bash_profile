# Japanese input
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx

wineserver -p

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 24h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null

alias pkexec='pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY'
source ~/.bashrc

# if [ -e /home/ym/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ym/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# export GUIX_PROFILE="/home/ym/.config/guix/current"
# . "$GUIX_PROFILE/etc/profile"
# export PATH="$PATH:/home/ym/.config/guix/current/bin"
