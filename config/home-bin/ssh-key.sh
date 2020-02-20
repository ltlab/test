#!/bin/bash

COLOR_SH="$HOME/bin/color.sh"

if [ -e $COLOR_SH ] ; then
	source $COLOR_SH
	#echo -e $RED_BOLD"Including Color.sh"$ENDCOLOR
fi

echo -en $YELLOW_BOLD"[ SSH ] Enter email: "$ENDCOLOR
read EMAIL

SSH_CONFIG="$HOME/.ssh/config"
TMP_CONFIG="./tmp-ssh-config"
RSA_KEY="id_rsa-$EMAIL"
GIT_CONFIG="$HOME/.gitconfig"
GIT_CONFIG_ADD="$HOME/.gitconfig-$EMAIL"

echo -en $YELLOW_BOLD"[ SSH ] RSA_KEY => $HOME/.ssh/$RSA_KEY ? [y/n] "$ENDCOLOR
read answer

if [[ "$answer" != [Yy] ]] ; then
	exit 0;
fi

if [[ ! -f "$HOME/.ssh/$RSA_KEY" ]] ; then
	ssh-keygen -q -t rsa -b 4096 -N "" -C "$EMAIL" -f $HOME/.ssh/$RSA_KEY
else
	echo -e $YELLOW_BOLD"[ SSH ] key found '$HOME/.ssh/$RSA_KEY'"
fi
echo -e $RED_BOLD
file $HOME/.ssh/$RSA_KEY*
echo -e $ENDCOLOR

#ssh-add $HOME/.ssh/$RSA_KEY

if [[ ! -e "$SSH_CONFIG" ]] ; then
	cat << EOF > $TMP_CONFIG
Host *
    PreferredAuthentications publickey
##    ServerAliveInterval 300
##    ServerAliveCountMax 1
	IdentityFile ~/.ssh/$RSA_KEY
EOF
fi

cat << EOF >> $TMP_CONFIG

Host github.com
    User git
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/$RSA_KEY

Host gitlab.com
    User git
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/$RSA_KEY
EOF

if [[ -z "$( grep $EMAIL $SSH_CONFIG )" ]] ; then
	cat $TMP_CONFIG >> $SSH_CONFIG
fi
chmod 0600 $SSH_CONFIG
rm -f $TMP_CONFIG

echo -en $YELLOW_BOLD"[ GIT ] Enter working path( ~/work/ ) "$ENDCOLOR
read WORK_PATH

if [[ -z "$WORK_PATH" ]] ; then
	WORK_PATH="~/work/"
fi

if [[ -z "$( grep $EMAIL $GIT_CONFIG )" ]] ; then
	echo "[includeIf \"gitdir:$WORK_PATH\"]" >> $GIT_CONFIG
	echo "	path = .gitconfig-$EMAIL" >> $GIT_CONFIG
fi

NAME_LINE=$( grep "[[:space:]]name" $GIT_CONFIG )

echo "[user]" > $GIT_CONFIG_ADD
echo "$NAME_LINE" >> $GIT_CONFIG_ADD
echo "	email = $EMAIL" >> $GIT_CONFIG_ADD
echo "	#signingkey = 7104CF72"

echo -e $GREEN_BOLD"FILE: $GIT_CONFIG"$ENDCOLOR
tail -n 10 $GIT_CONFIG
echo -e $GREEN_BOLD"FILE: $GIT_CONFIG_ADD"$ENDCOLOR
cat $GIT_CONFIG_ADD

echo -e $YELLOW_BOLD"[ SSH ] Register ssh public key( $HOME/.ssh/$RSA_KEY.pub ) to github.com and gitlab.com."$ENDCOLOR
