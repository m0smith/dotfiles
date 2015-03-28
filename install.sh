#!/bin/bash
# From https://github.com/stuartsierra/dotfiles
# 

export CYGWIN="winsymlinks:nativestrict"
set -e

cd `dirname $0`
export DOTFILES=`pwd`


. $DOTFILES/setenv.sh
. $DOTFILES/install_functions.sh

fix_home
link_with_backup .bash_profile
link_with_backup .emacs.d
link_with_backup .emacs
link_with_backup .emacs-custom.el
link_with_backup .gitignore
link_with_backup .gitconfig
link_with_backup .lein

create_dir ~/bin
create_dir ~/projects
create_dir ~/opt
create_dir ~/var/reg
create_dir ~/.emacs.d/init.d
create_dir ~/.profile.d

add_to_path ~/bin

if [ "$os" == "Cygwin" ]; then 
    . $DOTFILES/install_win.sh
else
    os2=`cat /proc/version_signature | cut -d" " -f1`
    if [ "$os2" == "Ubuntu" ]; then 
	. $DOTFILES/install_ubuntu.sh
    else 
	echo "os=$os and os2=$os2"
	exit 1
    fi
fi


install_elpa

install_dotfile_path
install_lein
install_mvn
install_ant
install_jad
install_cljdb
install_org_present
install_maven_pom_mode
byte_compile

## install_jdibug # BROKEN

create_gpg_keys

chmod +x ~/bin/* 

. ~/.bash_profile

