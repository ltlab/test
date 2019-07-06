#/bin/sh
echo "/usr/bin/pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME "$@""
/usr/bin/pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME "$@"

#pksudo.sh VirtualBox %U
