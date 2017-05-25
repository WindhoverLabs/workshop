#!/bin/bash

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install g++ g++-multilib git gitk openjdk-8-jdk cinnamon maven libc-bin libc-dev-bin libc6-dev rpm nodejs-legacy npm alien
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
sudo alien --scripts -i yamcs-3.2.2+rd8e5dcf-10.noarch.rpm
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

# Setup and build the softsim build
#${CFS_MISSION}/build/softsim/scripts/setup.sh
#${CFS_MISSION}/build/softsim/scripts/build.sh

