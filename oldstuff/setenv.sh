
export os=`uname`
SCRIPT="$0"

if [ "$SCRIPT" = "-bash" ]; then
    export DOTFILES=~/projects/dotfiles
else
    cd `dirname $0`
    export DOTFILES=`pwd`
fi



echo DOTFILES $DOTFILES

if [ -z "$TILDE" ]; then
    TILDE="$HOME"
fi


if [[ "$os" =~ CYGWIN.* ]]; then 
    export LINK="${DOTFILES}/mswindows/installer/elevate.exe /c mklink"
    export LINKDIR="${DOTFILES}/mswindows/installer/elevate.exe /c mklink /d"
else
    export LINK="ln -s"
    export LINKDIR="$LINK"
fi

