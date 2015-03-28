export os=`uname -o`

export DOTFILES=`dirname $0`

if [[ "$os" = "Cygwin" ]]; then 
    export LINK="${DOTFILES}/mswindows/installer/elevate.exe /c mklink"
    export LINKDIR="${DOTFILES}/mswindows/installer/elevate.exe /c mklink /d"
else
    export LINK="ln -s"
    export LINKDIR="$LINK"
fi

