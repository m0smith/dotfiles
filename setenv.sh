export os=`uname -o`

if [[ "$os" = "Cygwin" ]]; then 
    export LINK="./elevate /c mklink"
    export LINKDIR="./elevate /c mklink /d"
else
    export LINK="ln -s"
    export LINKDIR="$LINK"
fi

