cd /tmp
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask
brew install brew-cask

brew cask install java

which gpg || brew install gnupg    


