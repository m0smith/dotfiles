##
## Setup OS specific bash options

link_with_backup2 ubuntu/.bashrc_ubuntu .profile.d/bashrc_ubuntu

#
# Useful and necessary
#


sudo apt-get install emacs24 emacs24-el git ssh xterm wget software-properties-common x11-apps unzip

#
# Java
# See http://www.ubuntugeek.com/how-to-install-oracle-java-7-in-ubuntu-12-04.html
#
java_package=oracle-java7-installer

dpkg -s "$java_package" >/dev/null 2>&1 || {
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install "$java_package"
}
