##
## Only run in Cygwin
##
#set -x

cat <<EOF
Before running this, be sure and install the latest cygwin:
      emacs, emacs-el, ctags, git, wget curl, openssh, zip, unzip, subversion.

Also set HOME in the computer propeties to %HOMEDRIVE%%HOMEPATH%

To get git to work through a firewall try:
    export https_proxy=http://user:pass@host:port

EOF

os=`uname -o`
if [[ "$os" = "Cygwin" ]]; then 

    ## Setup home as per: http://stackoverflow.com/questions/225764/safely-change-home-directory-in-cygwin/10321615#10321615
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
