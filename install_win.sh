
##
## Only run in Cygwin
##
#set -x

os=`uname -o`
if [[ "$os" = "Cygwin" ]]; then 

    cd /
    if [[ ! -d "oldhome" ]]; then
	if [[ -e "home" ]]; then
	    mv home oldhome
	    ln -s `cygpath -H` home
	fi
    fi

else
    echo "Only works in Cygwin not $os"
fi
