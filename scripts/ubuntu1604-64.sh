#!/bin/bash

export YAMCS_VERSION=3.2.2+r6405b1e-10
export YAMCS_CFS_VERSION=1.0.3
export ECLIPSE_VERSION=oxygen-M7-linux-gtk-x86_64

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Write version file
echo "Windhover Workshop v${VBOX_VERSION_ID}" > ~/VERSION

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install g++ g++-multilib gcc-multilib g++-multilib git gitk openjdk-8-jdk cinnamon maven rpm nodejs-legacy npm alien doxygen vagrant 
sudo npm -g install bower gulp

# Install NTP so Jenkins can use the VM for builds without complaining about file timestamp problems.
sudo apt-get install -y ntp

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
cd ${WORKSPACE}
wget http://jenkins.windhoverlabs.lan/releases/yamcs/yamcs-${YAMCS_VERSION}.noarch.rpm
sudo useradd -r yamcs
sudo alien --scripts -i yamcs-${YAMCS_VERSION}.noarch.rpm
sudo chown -R root:root /opt/yamcs
sudo rm -Rf /opt/yamcs/cache
sudo rm -Rf /opt/yamcs/etc/*
sudo cp yamcs/* /opt/yamcs/etc/
sudo rm -Rf /opt/yamcs/log
sudo rm -Rf /opt/yamcs/mdb
rm yamcs-${YAMCS_VERSION}.noarch.rpm

# Install YAMCS Studio
###wget http://www.windhoverlabs.com/releases/yamcs-studio/yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
###tar -xzf yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz
###sudo mv yamcs-studio-1.0.0-SNAPSHOT /opt/yamcs-studio
###sudo chown -R root:root /opt/yamcs-studio
###rm yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz

# Install YAMCS CFS plugin
cd ${WORKSPACE}
wget http://jenkins.windhoverlabs.lan/releases/yamcs-cfs/yamcs-cfs-${YAMCS_CFS_VERSION}.jar
sudo cp yamcs-cfs-${YAMCS_CFS_VERSION}.jar /opt/yamcs/lib
sudo chown -R root:root /opt/yamcs/lib
rm yamcs-cfs-${YAMCS_CFS_VERSION}.jar

# Install Sage
git clone git@bitbucket.org:windhoverlabs/sage.git
sudo cp -R sage /opt/yamcs/
sudo rm -Rf sage
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
wget http://jenkins.windhoverlabs.lan/external-packages/eclipse/eclipse-cpp-${ECLIPSE_VERSION}.tar.gz
echo "WORKSHOP_BASEDIR = $WORKSHOP_BASEDIR"
tar -xzf eclipse-cpp-${ECLIPSE_VERSION}.tar.gz
sudo mv eclipse /opt/
sudo chown root:root /opt/eclipse
echo "export PATH=/opt/eclipse/:$PATH" >> ~/.bashrc
rm eclipse-cpp-${ECLIPSE_VERSION}.tar.gz

# Install additional development tools
sudo apt-get install -y valgrind gcovr lcov xsltproc graphviz  

# Install some nice to have stuff
sudo apt-get install -y gedit htop gkrellm 

# Configure git 
sudo apt-get install -y meld
sudo git config --global push.default simple
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

# Install dependencies for PX4 and Gazebo
sudo apt-get install -y libimage-exiftool-perl
sudo apt-get install -y catkin
sudo apt-get install -y python-jinja2
sudo apt-get install -y python-empy
sudo apt-get install -y python-pip python-dev build-essential 
sudo -H pip install --upgrade pip 
sudo -H pip install --upgrade virtualenv 
sudo -H pip install catkin_pkg
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y gazebo8 libgazebo8 libgazebo8-dev
sudo apt-get install -y protobuf-compiler python-protobuf
sudo apt-get install -y ant openjdk-8-jdk openjdk-8-jre 
sudo apt-get remove -y modemmanager
sudo apt-get install -y python-argparse git git-core wget zip python-empy qtcreator cmake build-essential genromfs
sudo apt-get install -y python-dev
sudo apt-get install -y libeigen3-dev libopencv-dev
sudo apt-get install -y python-serial openocd flex bison libncurses5-dev autoconf texinfo libftdi-dev libtool zlib1g-dev
sudo apt-get install -y gcc-5-arm-linux-gnueabihf g++-5-arm-linux-gnueabihf
#sudo ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/arm-linux-gnueabihf-gcc
#sudo ln -s /usr/bin/arm-linux-gnueabihf-g++-5 /usr/bin/arm-linux-gnueabihf-g++
sudo apt-get install -y gstreamer1.0-* libgstreamer1.0-*
sudo apt-get install -y libimage-exiftool-perl

# Install dependencies for running the ADS-B receiver in Commander
sudo apt-get install -y rtl-sdr librtlsdr-dev
git clone https://github.com/mutability/dump1090.git
cd dump1090
sudo dpkg-buildpackage -b
cd ..
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
sudo debconf-set-selections /vagrant/scripts/dump1090-mutability-preseed.txt
sudo dpkg -i dump1090-mutability_1.15~dev_*.deb

# Install missing airliner build dependencies
sudo apt-get install -y linux-libc-dev:i386

# Install Commander requirements
sudo apt-get install -y python redis-server jq
sudo -H pip install Django==1.10.2
sudo -H pip install asgiref==1.1.1
sudo -H pip install asgi-redis==1.2.1
sudo -H pip install channels==0.17.3
sudo -H pip install daphne==1.3.0
sudo -H pip install multiprocessing==2.6.2.1
sudo -H pip install psutil==3.4.2
sudo -H pip install pypugjs==4.2.2
sudo -H pip install requests==2.18.4
sudo -H pip install websocket-client==0.44.0
sudo -H pip install coloredlogs==9.0
sudo -H pip install redis_lock==0.2.0

cd ${WORKSHOP_BASEDIR}
wget http://jenkins.windhoverlabs.lan/external-packages/pypugjs/pypugjs-4.2.2.tar.gz
tar -xvzf pypugjs-4.2.2.tar.gz
cd pypugjs-4.2.2
sudo -H python setup.py install

