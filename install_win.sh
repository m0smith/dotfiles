##
## Only run in Cygwin
##
#set -x

function cygwin_requires {
    if [[ ! -e "/usr/bin/$1" ]]; then
	echo "Missing $1"
	cat <<EOF
Before running this, be sure and install the latest cygwin:
      emacs, emacs-el, ctags, git, wget curl, openssh, zip, unzip, subversion.

Also set HOME in the computer propeties to %HOMEDRIVE%%HOMEPATH%

To get git to work through a firewall try:
    export https_proxy=http://user:pass@host:port

EOF
	exit 1
    fi
}

os=`uname -o`
if [[ "$os" = "Cygwin" ]]; then 

    link_with_backup2 mswindows/.bashrc_cygwin .bashrc_os

    cygwin_requires "emacs"
    cygwin_requires "curl"
    cygwin_requires "wget"
    cygwin_requires "unzip"
    cygwin_requires "zip"
    cygwin_requires "ctags"
    cygwin_requires "git"

    ## Setup home as per: http://stackoverflow.com/questions/225764/safely-change-home-directory-in-cygwin/10321615#10321615
    cd /
    if [[ ! -h "home" ]]; then
	if [[ -e "home" ]]; then
	    mv home oldhome
	fi
        ln -s `cygpath -H` home

    fi

    if [[ ! -h "/usr/local/bin64" ]]; then
	if [[ -e "/usr/local/bin64" ]]; then
	    mv /usr/local/bin64 /usr/local/bin64old
	fi
	d=`cygpath -u "c:\Program Files"`
        ln -s "$d" /usr/local/bin64

    fi

    if [[ ! -h "/usr/local/bin86" ]]; then
	if [[ -e "/usr/local/bin86" ]]; then
	    mv /usr/local/bin86 /usr/local/bin64old
	fi
	d=`cygpath -u "c:\Program Files (x86)"`
        ln -s "$d"  /usr/local/bin86

    fi



else
    echo "Only works in Cygwin not $os"
fi
