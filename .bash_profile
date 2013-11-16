##
## Put your local edits in .profile.  It will be not be overwritten by
## the install scripts

export PATH=${HOME}/bin:$PATH


if [[ -f ~/.bashrc_os ]]; then
    . ~/.bashrc_os
fi

if [[ -f ~/.profile ]]; then
    . ~/.profile
fi
