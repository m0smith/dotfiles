#
# From https://github.com/stuartsierra/dotfiles
# 

set -e

cd `dirname $0`
export DOTFILES=`pwd`

. $DOTFILES/install_functions.sh


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


os=`uname -o`
if [[ "$os" = "Cygwin" ]]; then 
    . $DOTFILES/install_win.sh
else
    os2=`cat /proc/version_signature | cut -d" " -f1`
    if [[ "$os2" = "Ubuntu" ]]; then 
	. $DOTFILES/install_ubuntu.sh
    else 
	echo "os=$os and os2=$os2"
	exit 1
    fi
fi



install_elpa

if [ ! -f ~/.profile.d/profile.dotfilepath ]; then
    echo "export PATH=\${PATH}:$DOTFILES/bin" > ~/.profile.d/profile.dotfilepath
fi

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
    unzip -a /tmp/apache-maven-3.0.5-bin.zip
    rm /tmp/apache-maven-3.0.5-bin.zip
    cd ~/bin
    ln -s ~/opt/apache-maven-3.0.5/bin/mvn mvn
    chmod +x mvn
    echo "Maven installed"
fi

if [[ ! -f ~/bin/ant ]]; then
    pname=apache-ant-1.9.2
    zname=${pname}-bin.zip
    cd /tmp
    wget http://apache.mirrors.tds.net/ant/binaries/$zname
    cd ~/opt
    unzip -q /tmp/$zname
    rm /tmp/$zname
    cd ~/bin
    ln -s ~/opt/$pname/bin/ant ant
    chmod +x ant
    echo "Ant installed"
fi




if [[ ! -d ~/projects/cljdb ]]; then
    cd ~/projects
    git clone https://github.com/m0smith/cljdb.git
fi



clone_malabar_mode
install_malabar_mode
