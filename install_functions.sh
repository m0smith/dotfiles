#
# From https://github.com/stuartsierra/dotfiles
# 

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

function install_elpa {
    rm -rf "$DOTFILES/.emacs.d/elpa"
    emacs --script "$DOTFILES/install_elpa.el"
}

function create_dir {
    if [[ ! -d "$1" ]]; then
	mkdir -p "$1"
    fi
}
