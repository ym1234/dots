#!/bin/bash
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#xinput set-prop 11 296 1 0 &
#xinput set-prop 11 290 1 &
#xinput set-prop 11 317 0 &
# xsetr rate 260 55 &
#localectl set-x11-keymap us,ar pc104 dvorak,qwerty grp:ctrls_toggle,terminate:ctrl_alt_bksp
#setxkbmap -model pc104 -layout 'us(dvorak-intl),us(alt-intl),ar' -option grp:alt_shift_toggle,terminate:ctrl_alt_bksp
fcitx5 -d
sxhkd -m -1 &
battery &
frovo.py &
python ~/fun/nhk_server/server.py &
redshift &
# while :; do mpc idle &> /dev/null; mpd_status &> /dev/null; done &
# aw-server-rust &
# aw-watcher-window &
# aw-watcher-afk &
lxqt-policykit-agent &
keepassxc &
mpris-proxy &
exec bspwm
