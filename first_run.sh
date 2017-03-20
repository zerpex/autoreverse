#!/bin/bash

#--- Define text colors
CSI="\033["
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"

echo -e "${CYELLOW} upgrading system...$CEND"
sudo apt-get -y update && sudo apt-get -y upgrade

echo -e "${CYELLOW} Installing pre-requsites...$CEND"
sudo apt-get -y install git curl

echo -e "${CYELLOW} Installing nginx...$CEND"
sudo apt-get -y install nginx

echo -e "${CYELLOW} Set basic nginx configuration...$CEND"
mkdir -p /etc/nginx/conf.d/ssl /etc/nginx/conf.d/common

cp files/ssl_conf /etc/nginx/conf.d/ssl/
cp files/common_conf /etc/nginx/conf.d/common/
cp files/default.conf /etc/nginx/conf.d/

echo -e "${CYELLOW} Generating Diffie-Hellman strong parameters (might take a while)...$CEND"
openssl dhparam -out /etc/nginx/conf.d/ssl/dhparams.pem 4096
chmod 600 /etc/nginx/conf.d/ssl/dhparams.pem

echo -e "${CYELLOW} Installing letsencrypt...$CEND"
sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

echo -e "${CYELLOW} Restarting nginx...$CEND"
/etc/init.d/nginx reload
