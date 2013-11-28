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

	cd ~/.emacs.d/$mver/lisp
	emacs -batch -L . -f batch-byte-compile *.el
    fi
}

function install_dotfile_path {
    if [ ! -f ~/.profile.d/profile.dotfilepath ]; then
	echo "export PATH=\${PATH}:$DOTFILES/bin" > ~/.profile.d/profile.dotfilepath
    fi
    chmod +x $DOTFILES/bin/* 
}

function install_lein {
    if [[ ! -f ~/bin/lein ]]; then
	cd ~/bin
	wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
	chmod +x lein
    fi

    if [[ ! -f ~/bin/lein-exec ]]; then
	cd ~/bin
	wget https://raw.github.com/kumarshantanu/lein-exec/master/lein-exec
	chmod +x lein-exec
    fi
}

function install_mvn {
    if [[ ! -f ~/bin/mvn ]]; then
	cd /tmp
	wget http://psg.mtu.edu/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip
	cd ~/opt
	unzip -a /tmp/apache-maven-3.0.5-bin.zip
	rm /tmp/apache-maven-3.0.5-bin.zip
	cd ~/bin
	ln -s ~/opt/apache-maven-3.0.5/bin/mvn mvn
	chmod +x mvn
	echo "Maven 3.0.5 installed"
    fi
}
function install_ant {
    if [[ ! -f ~/bin/ant ]]; then
	pname=apache-ant-1.9.2
	zname=${pname}-bin.zip
	cd /tmp
	wget http://apache.mirrors.tds.net/ant/binaries/$zname
	cd ~/opt
	unzip -q /tmp/$zname
	rm /tmp/$zname
	cd ~/bin
	ln -s ~/opt/$pname/bin/ant ant
	chmod +x ant
	echo "Ant 1.9.2 installed"
    fi
}

function install_cljdb {
    if [[ ! -d ~/projects/cljdb ]]; then
	cd ~/projects
	git clone https://github.com/m0smith/cljdb.git
    fi
}




