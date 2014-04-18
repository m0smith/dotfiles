##
## Put your local edits in .profile.  It will be not be overwritten by
## the install scripts

export PATH=${HOME}/bin:$PATH
export CVS_RSH=ssh
export EDITOR=edit

if [[ -d ~/.profile.d ]]; then
    for f in ~/.profile.d/* ; do
	. $f
    done
fi

if [[ -f ~/.profile ]]; then
    . ~/.profile
fi

alias e=edit
alias em=edit



function set_proxy {
    if [ -z "$PROXY_HOST" -o -z "$PROXY_PORT" ]; then
	echo "Both PROXY_HOST and PROXY_PORT must be set"
	return
    fi
    read -s -p Password: -e p
    local proxy="http://${USER}:$p@${PROXY_HOST}:${PROXY_PORT}"
    export http_proxy="$proxy"
    export https_proxy="$proxy"
    export ftp_proxy="$proxy"
}
