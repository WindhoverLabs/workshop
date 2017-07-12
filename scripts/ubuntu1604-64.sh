#!/bin/bash

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install g++ g++-multilib git gitk openjdk-8-jdk cinnamon maven libc-bin libc-dev-bin libc6-dev rpm nodejs-legacy npm alien doxygen
sudo npm -g install bower gulp

# Setup locales.  The most current Ubuntu 16.04 version has a bug causing the terminal
# to not open.  These steps will correct it.
sudo dpkg-reconfigure -f noninteractive tzdata
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure -f noninteractive locales
sudo localectl set-locale LANG="en_US.UTF-8"

# Install Oracle JDK 8
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
echo 'export JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> ~/.bashrc
source ~/.bashrc

# Make the desktop look good
sudo apt-get install -y xubuntu-desktop
sudo apt-get purge -y ubuntu-desktop unity-*
sudo apt-get -y autoremove

# Install YAMCS
sudo useradd -r yamcs
sudo alien --scripts -i yamcs-3.2.2+r54d5450-10.noarch.rpm
sudo chown -R root:root /opt/yamcs
sudo rm -Rf /opt/yamcs/cache
sudo rm -Rf /opt/yamcs/etc/*
sudo cp yamcs/* /opt/yamcs/etc/
sudo rm -Rf /opt/yamcs/log
sudo rm -Rf /opt/yamcs/mdb

# Install YAMCS Studio
###wget http://www.windhoverlabs.com/releases/yamcs-studio/yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
###tar -xzf yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
###sudo mv yamcs-studio-1.0.0-SNAPSHOT /opt/yamcs-studio
###sudo chown -R root:root /opt/yamcs-studio
###rm yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz

# Install YAMCS CFS plugin
sudo cp yamcs-cfs-1.0.3.jar /opt/yamcs/lib
sudo chown -R root:root /opt/yamcs/lib

# Install Sage
###tar -xzf sage-1.0.0+2.tar.gz
###cd sage
###npm install
###bower install
###cd $WORKSHOP_BASEDIR
###sudo mv sage /opt/sage
###sudo chown -R root:root /opt/sage
###rm -Rf sage-1.0.0+2.tar.gz

# Install Eclipse
echo "WORKSHOP_BASEDIR = $WORKSHOP_BASEDIR"
tar -xzf eclipse-cpp-oxygen-M7-linux-gtk-x86_64.tar.gz
sudo mkdir /opt/eclipse
sudo mv eclipse /opt/eclipse/4.7
sudo chown root:root /opt/eclipse
echo "export PATH=/opt/eclipse/4.7:$PATH" >> ~/.bashrc

# Install additional development tools
sudo apt-get install -y libc6-dbg:i386 valgrind gcovr gcov xsltproc 

# Install some nice to have stuff
sudo apt-get install -y gedit htop gkrellm 

# Configure git 
sudo apt-get install -y meld
git config --global push.default simple
sudo git config --global merge.tool meld
sudo git config --global  diff.guitool meld

# Install Airliner build dependencies
sudo apt-get install -y cmake

# Install TFTP server
sudo apt-get install -y xinetd tftpd tftp
sudo cp /vagrant/etc/xinetd.d/tftp /etc/xinetd.d
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot
sudo service xinetd restart

# Install XSDK dependencies
sudo apt-get install -y libncurses-dev xvfb chrpath socat autoconf libtool texinfo libsdl1.2-dev libglib2.0-dev zlib1g:i386 tofrodos iproute gawk gcc git-core make net-tools libncurses5-dev zlib1g-dev flex bison lib32z1 lib32ncurses5 lib32stdc++6 libselinux1 libbz2-1.0:i386 lib32ncurses5 lib32z1
# The following is a work around to get petalinux tools to work on ubuntu.
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Setup and build the softsim build
#${CFS_MISSION}/build/softsim/scripts/setup.sh
#${CFS_MISSION}/build/softsim/scripts/build.sh

