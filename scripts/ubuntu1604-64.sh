#!/bin/bash

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install g++ g++-multilib git gitk openjdk-8-jdk cinnamon maven libc-bin libc-dev-bin libc6-dev rpm nodejs-legacy npm alien doxygen vagrant libc6-dbg libc6-dbg:i386
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
sudo alien --scripts -i yamcs-3.2.2+r6405b1e-10.noarch.rpm
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
sudo cp -R /vagrant/sage /opt/yamcs/
cd /opt/yamcs
sudo chown -R vagrant:vagrant sage
cd sage
npm install
bower install
ln -s /opt/yamcs/sage/sage /opt/yamcs/sage/node_modules/sage
cd ..
sudo chown -R root:root sage
cd ${WORKSHOP_BASEDIR}

# Install Eclipse
echo "WORKSHOP_BASEDIR = $WORKSHOP_BASEDIR"
tar -xzf eclipse-cpp-oxygen-M7-linux-gtk-x86_64.tar.gz
sudo mkdir /opt/eclipse
sudo mv eclipse /opt/eclipse/4.7
sudo chown root:root /opt/eclipse
echo "export PATH=/opt/eclipse/4.7:$PATH" >> ~/.bashrc

# Install additional development tools
sudo apt-get install -y libc6-dbg:i386 valgrind gcovr lcov xsltproc graphviz  

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

# Install dependencies for PX4 and Gazebo
sudo apt-get install -y python-jinja2
sudo apt-get install -y python-empy
sudo apt-get install -y python-pip python-dev build-essential 
sudo pip install --upgrade pip 
sudo pip install --upgrade virtualenv 
sudo pip install catkin_pkg
sudo apt-get install -y gazebo7 libgazebo7 libgazebo7-dev
sudo apt-get install -y protobuf-compiler python-protobuf
sudo apt-get install -y ant openjdk-8-jdk openjdk-8-jre 
sudo apt-get remove -y modemmanager
sudo apt-get install -y python-argparse git git-core wget zip python-empy qtcreator cmake build-essential genromfs
sudo apt-get install -y python-dev
sudo apt-get install -y libeigen3-dev libopencv-dev
sudo apt-get install -y python-serial openocd flex bison libncurses5-dev autoconf texinfo     libftdi-dev libtool zlib1g-dev
sudo apt-get install -y gcc-5-arm-linux-gnueabihf
sudo apt-get install -y g++-5-arm-linux-gnueabihf
sudo ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/arm-linux-gnueabihf-gcc
sudo ln -s /usr/bin/arm-linux-gnueabihf-g++-5 /usr/bin/arm-linux-gnueabihf-g++

# Install dependencies for running the ADS-B receiver in Commander
sudo apt-get install -y rtl-sdr librtlsdr-dev
git clone https://github.com/mutability/dump1090.git
cd dump1090
sudo dpkg-buildpackage -b
cd ..
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
sudo debconf-set-selections /vagrant/scripts/dump1090-mutability-preseed.txt
sudo dpkg -i dump1090-mutability_1.15~dev_*.deb



