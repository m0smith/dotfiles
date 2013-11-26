#
# From https://github.com/stuartsierra/dotfiles
# 

function add_to_path {
    export PATH=${PATH}:$1
}

function backup {
    local file="$1"
    if [[ -L "$file" ]]; then
	rm "$file"
    elif [[ -e "$file" ]]; then
	mv "$file" "$file.bak"
    fi
}

function link_with_backup {
    local filename="$1"
    local source="$DOTFILES/$filename"
    local target="$HOME/$filename"
    backup "$target"
    ln -s "$source" "$target"
}

function link_with_backup2 {
    local filename="$1"
    local targetname="$2"
    local source="$DOTFILES/$filename"
    local target="$HOME/$targetname"
    backup "$target"
    ln -s "$source" "$HOME/$targetname"
}

function install_elpa {
    rm -rf "$DOTFILES/.emacs.d/elpa"
   DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs  -nw --script "$DOTFILES/install_elpa.el"
}

function create_dir {
    if [[ ! -d "$1" ]]; then
	mkdir -p "$1"
    fi
}

function clone_malabar_mode {
    if [[ ! -d ~/projects/malabar-mode ]]; then
	cd ~/projects
	## git clone https://github.com/dstu/malabar-mode.git
	## git clone https://github.com/blackd/malabar-mode.git
	git clone https://github.com/m0smith/malabar-mode.git --branch buzztaiki
    else
	cd ~/projects/malabar-mode
	git pull
    fi
}


function install_malabar_mode {
    if [[ -d ~/projects/malabar-mode ]]; then
	if [[ "$os" = "Cygwin" ]]; then 
	    w=`which emacs`
	    echo `cygpath -w $w`" -nw %* " > ~/projects/malabar-mode/emacs.bat
	fi
	cd ~/projects/malabar-mode
	mvn -Dmaven.test.skip=true clean package
	p=`pwd`
	cd ~/.emacs.d/
	rm -rf malabar*
	unzip "$p/target/malabar-*-dist.zip"
	mver=`ls -dt mala* | head -1`

	echo "(setq  malabar-dir \"~/.emacs.d/$mver\")" > ~/.emacs.d/init.d/malabar-mode-dir.el
	echo "(add-to-list 'load-path (expand-file-name (format \"%s/lisp\" malabar-dir)))" >> ~/.emacs.d/init.d/malabar-mode-dir.el
	 if [[ "$os" = "Cygwin" ]]; then 
	     echo "(setq malabar-util-path-separator \";\")" > ~/.emacs.d/init.d/malabar-mode-cygwin.el
	     echo "(setq malabar-util-path-filter 'cygwin-convert-file-name-to-windows)" >> ~/.emacs.d/init.d/malabar-mode-cygwin.el
	     echo "(setq malabar-util-groovy-file-filter 'malabar-util-reverse-slash)"  >> ~/.emacs.d/init.d/malabar-mode-cygwin.el
	 fi

	cd ~/.emacs.d/$mver
	find ./ -name '*.el' | xargs emacs -nw -batch -f batch-byte-compile
    fi
}

