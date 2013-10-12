
set -e

cd `dirname $0`
export DOTFILES=`pwd`

source $DOTFILES/install_functions.sh

link_with_backup .emacs
link_with_backup .emacs-custom.el
