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
fi

link_with_backup .bash_profile
link_with_backup .emacs.d
link_with_backup .emacs
link_with_backup .emacs-custom.el
link_with_backup .gitignore
link_with_backup .gitconfig

if [[ ! -d ~/bin ]]; then
    mkdir ~/bin
fi

if [[ ! -d ~/projects ]]; then
    mkdir ~/projects
fi

install_elpa

if [[ ! -f ~/bin/lein ]]; then
    cd ~/bin
    wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
    chmod +x lein
fi


if [[ ! -f ~/projects/cljdb ]]; then
    cd ~/projects
    git clone https://github.com/m0smith/cljdb.git
fi


