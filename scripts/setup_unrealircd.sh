#!/bin/bash



eco r "Installing UnrealIRCd!!!... .. "
log "Installing UnrealIRCd!!!... .. "




useradd -m unrealircd
gpasswd -a unrealircd irc


cd ~/
wget https://www.unrealircd.org/downloads/unrealircd-6.1.9.1.tar.gz
tar xvf *.gz

cd unreal*

./Config
make;
make install;

cd con* 
cp -r /home/unrealircd/conf/examples/example.conf /home/unrealircd/unrealircd.conf

