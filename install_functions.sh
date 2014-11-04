#
# From https://github.com/stuartsierra/dotfiles
# 

function add_to_path {
    export PATH=${PATH}:$1
}

function backup {
    local file="$1"
    if [ -L "$file" ]; then
	rm "$file"
    elif [ -e "$file" ]; then
	mv "$file" "$file.bak"
    fi
}

function myln {
    local src="$1"
    local rawtarget="$2"
    if [ -d "$rawtarget" ]; then
	LINKCMD="$LINKDIR"
    else
	LINKCMD="$LINK"
    fi
    if [ "$os" == "Cygwin" ]; then
	src=`cygpath -w "$1"`
	target=`cygpath -w "$2"`
	echo 	$LINKCMD "$target" "$src"
	$LINKCMD "$target" "$src"
    else
	target="$rawtarget"
	$LINKCMD "$src" "$target"

    fi

}

function link_with_backup_raw {
    local source="$1"
    local target="$2"
    backup "$target"
    myln "$source" "$target"

}
function link_with_backup {

    local filename="$1"
    local source="$DOTFILES/$filename"
    local target="$HOME/$filename"
    link_with_backup_raw "$source" "$target"
}

function link_with_backup2 {
    local filename="$1"
    local targetname="$2"
    local source="$DOTFILES/$filename"
    local target="$HOME/$targetname"
    link_with_backup_raw "$source" "$target"
}

function install_elpa {
    rm -rf "$DOTFILES/.emacs.d/elpa"
    DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs  -nw --script "$DOTFILES/install_elpa.el"
}

function byte_compile {
    DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs --batch --eval '(byte-recompile-directory "~/.emacs.d/init.d" 0)' 
}

function create_dir {
    if [ ! -d "$1" ]; then
	mkdir -p "$1"
    fi
}

function install_jdibug {
    cd /tmp
    wget http://jdibug.googlecode.com/files/jdibug-0.5.tar.bz2
    cd ~/.emacs.d
    tar jxvf /tmp/jdibug-0.5.tar.bz2
    rm /tmp/jdibug-0.5.tar.bz2
}


function install_malabar_mode {
    if [ -d $HOME/projects/malabar-mode ]; then
	if [ "$os" = "Cygwin" ]; then 
	    w=`which emacs`
	    echo `cygpath -w $w`" -nw %* " > ~/projects/malabar-mode/emacs.bat
	fi
	cd ~/projects/malabar-mode
	mvn  clean package
	p=`pwd`
	cd ~/.emacs.d/
	rm -rf malabar*
	unzip "$p/target/malabar-*-dist.zip"
	mver=`ls -dt mala* | head -1`

	echo "(setq  malabar-dir \"~/.emacs.d/$mver\")" > ~/.emacs.d/init.d/malabar-mode-dir.el
	echo "(add-to-list 'load-path (expand-file-name (format \"%s/lisp\" malabar-dir)))" >> ~/.emacs.d/init.d/malabar-mode-dir.el
	 if [ "$os" = "Cygwin" ]; then 
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
	rm ~/.profile.d/profile.dotfilepath
    fi
    echo "export PATH=\${PATH}:${DOTFILES}/bin" > ~/.profile.d/profile.dotfilepath
    echo "export DOTFILES=${DOTFILES}"  >> ~/.profile.d/profile.dotfilepath
    chmod +x $DOTFILES/bin/* 
}

function install_lein {
    if [ ! -f ~/bin/lein ]; then
	cd ~/bin
	wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
	chmod +x lein
    fi

    if [ ! -f ~/bin/lein-exec ]; then
	cd ~/bin
	wget https://raw.github.com/kumarshantanu/lein-exec/master/lein-exec
	chmod +x lein-exec
    fi
}

##
## install_jad
##   Creates a link to the right jad executable for this environment
##    Requires JAD_EXE be set to either jad or jad.exe for linux and windows
##
function install_jad {
    if [ ! -f ~/bin/${JAD_EXE} ]; then
	link_with_backup2 opt/jad/${JAD_EXE} bin/${JAD_EXE}
	chmod +x ~/bin/${JAD_EXE}
    fi
}

## install_mvn_version
##    Download, extract and add a version of maven to the path
## $1 = URL to maven release
## $2 = MAven verion number

function install_mvn_version {
    mtdir=/tmp/$2.$$
    mkdir -p "$mtdir"
    cd "$mtdir"
    wget "$1"
    z=`ls *.zip`
    cd ~/opt
    unzip -a "$mtdir/$z"
    rm -rf "$mtdir"
    cd ~/bin
    myln ~/opt/apache-maven-$2/bin/mvn mvn-$2
    chmod +x mvn*
}

##
## install_mvn
##   Install version 3.0.5 and 3.1.1 of maven with 3.0.5 bein the active one

function install_mvn {
    if [ ! -f ~/bin/mvn ]; then
	mavendist=http://psg.mtu.edu/pub/apache/maven
	zip305=$mavendist/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip 
	zip311=$mavendist/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.zip 
	install_mvn_version $zip305 3.0.5
	install_mvn_version $zip311 3.1.1
	myln mvn-3.0.5 mvn
	chmod +x mvn*
	echo "Maven 3.0.5 and 3.1.1 installed with 3.0.5 active"
    fi
}

##
## install_ant
##   Dowload, extract and add ant to the PATH

function install_ant {
    if [ ! -f ~/bin/ant ]; then
	pname=apache-ant-1.9.2
	zname=${pname}-bin.zip
	cd /tmp
	wget http://apache.mirrors.tds.net/ant/binaries/$zname
	cd ~/opt
	unzip -q /tmp/$zname
	rm /tmp/$zname
	cd ~/bin
	myln ~/opt/$pname/bin/ant ant
	chmod +x ant
	echo "Ant 1.9.2 installed"
    fi
}

function install_cljdb {
    if [ ! -d ~/projects/cljdb ]; then
	cd ~/projects
	git clone https://github.com/m0smith/cljdb.git
	DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs --batch --eval '(byte-recompile-directory "~/projects/cljdb" 0)' 
    fi
}


function install_org_present {
    if [ ! -d ~/projects/org-present ]; then
	cd ~/projects
	git clone https://github.com/rlister/org-present.git
	DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs --batch --eval '(byte-recompile-directory "~/projects/org-present" 0)' 
    fi
}

function install_maven_pom_mode {
    if [ ! -d ~/projects/maven-pom-mode ]; then
	cd ~/projects
	git clone https://github.com/m0smith/maven-pom-mode.git
	DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/foo emacs --batch --eval '(byte-recompile-directory "~/projects/maven-pom-mode" 0)' 
    fi
}

function create_gpg_keys {
    which gpg
    gpg --list-keys
    p=`gpg --list-keys | awk '/pub/' `
    if [ "${p}x" = "x" ]; then
	gpg --gen-key
    fi
    gpg --list-keys
    k=`gpg --list-keys | awk '/^pub/ { split( $2, a , "/"); print a[2];}'`
    gpg --keyserver hkp://pool.sks-keyservers.net --send-keys $k
}



