#!/bin/bash

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Source the main setvars.sh script to get all the CFS environment variables
#cd ..
#source setvars.sh

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install eclipse eclipse-cdt g++ g++-multilib git gitk openjdk-8-jdk cinnamon maven libc-bin libc-dev-bin libc6-dev rpm nodejs-legacy npm alien
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
sudo apt-get install -y cinnamon-desktop-environment
#  Hack to change desktop image
#sudo cp /usr/share/backgrounds/Black_hole_by_Marek_Koteluk.jpg /usr/share/images/desktop-base/desktop-background

# Install YAMCS
wget http://www.windhoverlabs.com/releases/yamcs/yamcs-0.29.5+.noarch.rpm
sudo useradd -r yamcs
sudo alien --scripts -i yamcs-0.29.5+.noarch.rpm
rm yamcs-0.29.5+rbdbf495-10.noarch.rpm
sudo chown -R root:root /opt/yamcs
sudo rm -Rf /opt/yamcs/cache
sudo rm -Rf /opt/yamcs/etc
sudo rm -Rf /opt/yamcs/log
sudo rm -Rf /opt/yamcs/mdb

# Install YAMCS Studio
wget http://www.windhoverlabs.com/releases/yamcs-studio/yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
tar -xzf yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
sudo mv yamcs-studio-1.0.0-SNAPSHOT /opt/yamcs-studio
sudo chown -R root:root /opt/yamcs-studio
rm yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz

# Install YAMCS CFS plugin
wget http://www.windhoverlabs.com/releases/yamcs-cfs/yamcs-cfs-1.0.1.jar
sudo mv yamcs-cfs-1.0.1.jar /opt/yamcs/lib
sudo chown -R root:root /opt/yamcs/lib

# Install Sage
wget http://www.windhoverlabs.com/releases/sage/sage-1.0.0.tar.gz
tar -xzf sage-1.0.0+2.tar.gz
cd sage
npm install
bower install
cd ..
sudo mv -R sage /opt/sage
sudo chown -R root:root /opt/sage
rm -Rf sage-1.0.0+2.tar.gz

# Install Eclipse
wget http://mirror.csclub.uwaterloo.ca/eclipse/technology/epp/downloads/release/oxygen/M2/eclipse-cpp-oxygen-M2-linux-gtk-x86_64.tar.gz
tar -xzf eclipse-cpp-oxygen-M2-linux-gtk-x86_64.tar.gz
sudo mv eclipse /opt/eclipse/4.7
sudo chown -R root:root /opt/eclipse
echo 'export PATH="/opt/eclipse/4.7:\$PATH"'>>~/.bashrc
rm eclipse-cpp-oxygen-M2-linux-gtk-x86_64.tar.gz

# Setup and build the softsim build
#${CFS_MISSION}/build/softsim/scripts/setup.sh
#${CFS_MISSION}/build/softsim/scripts/build.sh

