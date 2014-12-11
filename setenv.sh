export os=`uname -o`

if [[ "$os" = "Cygwin" ]]; then 
    export LINK="mswindows/installer/elevate.exe /c mklink"
    export LINKDIR="mswindows/installer/elevate.exe /c mklink /d"
else
    export LINK="ln -s"
    export LINKDIR="$LINK"
fi

