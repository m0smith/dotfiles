


set -e

cd `dirname $0`
export DOTFILES=`pwd`

. $DOTFILES/install_functions.sh

link_with_backup .emacs
link_with_backup .emacs-custom.el
link_with_backup .emacs.d

link_with_backup .gitignore
link_with_backup .gitconfig

