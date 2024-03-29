##
## Setup OS specific bash options

# link_with_backup2 ubuntu/.bashrc_ubuntu .profile.d/bashrc_ubuntu

# export JAD_EXE=jad

#
# Useful and necessary
#


sudo apt-get install git bzr ssh xterm wget curl software-properties-common x11-apps unzip \
                     texinfo npm \
                     # emacs26
sudo apt-get autoremove

#
# Java
# See http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
#
# java_package=oracle-java8-installer

# dpkg -s "$java_package" >/dev/null 2>&1 || {
#     sudo add-apt-repository ppa:webupd8team/java
#     sudo apt-get update
#     sudo apt-get install oracle-java8-installer
# }



