#
# From https://github.com/stuartsierra/dotfiles
# 

set -e

cd `dirname $0`
export DOTFILES=`pwd`

. $DOTFILES/install_functions.sh

os=`uname -o`
if [[ "$os" = "Cygwin" ]]; then 
    . $DOTFILES/install_win.sh
else
    os2=`cat /proc/version_signature | cut -d" " -f1`
    if [[ "$os" = "Ubuntu" ]]; then 
	. $DOTFILES/install_ubuntu.sh
    fi
fi

link_with_backup .bash_profile
link_with_backup .emacs.d
link_with_backup .emacs
link_with_backup .emacs-custom.el
link_with_backup .gitignore
link_with_backup .gitconfig
link_with_backup .lein


create_dir ~/bin
create_dir~/projects
create_dir ~/opt

install_elpa


if [[ ! -f ~/bin/lein ]]; then
    cd ~/bin
    wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
    chmod +x lein
fi

if [[ ! -f ~/bin/lein-exec ]]; then
    cd ~/bin
    wget https://raw.github.com/kumarshantanu/lein-exec/master/lein-exec
    chmod +x lein-exec

fi

if [[ ! -f ~/bin/mvn ]]; then
    cd /tmp
    wget http://psg.mtu.edu/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip
    cd ~/opt
    unzip /tmp/apache-maven-3.0.5-bin.zip
    rm /tmp/apache-maven-3.0.5-bin.zip
    cd ~/bin
    ln -s ~/opt/apache-maven-3.0.5/bin/mvn mvn
    chmod +x mvn
fi


if [[ ! -d ~/projects/cljdb ]]; then
    cd ~/projects
    git clone https://github.com/m0smith/cljdb.git
fi


