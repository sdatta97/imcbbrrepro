#!bin/bash

sudo mkdir /mydata
sudo /usr/local/etc/emulab/mkextrafs.pl /mydata
sudo chmod a+r /mydata
sudo chmod a+w /mydata
cd /mydata
git clone -o google-bbr -b v2alpha  https://github.com/google/bbr.git
cd bbr/

sudo apt update; sudo apt -y install libelf-dev libssl-dev libncurses-dev 
flex bison pkg-config gcc
sudo apt-get -y install binutils ca_certificates

sudo make menuconfig # select options
sudo vim .config
CONFIG_MODULE_SIG_KEY=""
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_REVOCATION_KEYS=""
CONFIG_MODULE_SIG_ALL=n
CONFIG_DEBUG_INFO_BTF=n
sudo make -j $(nproc)
sudo make modules -j $(nproc)
sudo make modules_install -j $
