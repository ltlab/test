#!/bin/sh

DATE_TAG=$(date +"%Y%m%d")
TIME_TAG=$(date +"_%H%M%S")
DATE_TAG1=$(date +"%F")
TIME_TAG1=$(date +"_%T")

rm -f elechole-setting_*
#touch elechole-setting_$DATE_TAG$TIME_TAG.tar.gz
cp -a ~/bin/* ~/setting/usr_setting/script/
cp ~/.vimrc ~/setting/usr_setting/elechole-config/
cp ~/.bashrc ~/setting/usr_setting/elechole-config/
cp ~/.profile ~/setting/usr_setting/elechole-config/
#cp ~/.bash_profile ~/setting/usr_setting/elechole-config/
cp ~/.gitconfig ~/setting/usr_setting/elechole-config/

# Remove ELF Files
find ./setting/test_src/ -exec file {} \; | grep -i elf | sed 's/://' | awk '{print $1}' | xargs rm -vf

#tar -zcvf elechole-setting_$DATE_TAG.tar.gz ./setting/ ./.vim/ ./bin/ .vimrc .bashrc .profile .bash_profile .gitconfig .subversion
tar -zcvf elechole-setting_$DATE_TAG.tar.gz ./setting/ ./.vim/ ./bin/ .vimrc .bashrc .profile .gitconfig .subversion .vim_backup/ .screenrc .tmux.conf .ctags \
	.config/powerline \
	--exclude="*.swp" --exclude="cscope.*" --exclude="tags" --exclude="*~" --exclude="view"

#./firefox-FEBE/
#echo "TAG: $DATE_TAG TAG1: $DATE_TAG1  TAG: $TIME_TAG  TAG1: $TIME_TAG1"

#rm -f /tftpboot/elechole-setting_*
#mv elechole-setting_$DATE_TAG.tar.gz /tftpboot
