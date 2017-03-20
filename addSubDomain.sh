#!/bin/bash

SRV_IP="163.172.229.129"

#--- Define text colors
CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"

echo -e "${CYELLOW}What full domain has to be added ?$CEND"
read FULLDOMAIN
echo " "

echo -e "${CYELLOW}What is the target IP adress of the service ?$CEND"
read TIP
echo " "

echo -e "${CYELLOW}What is the target port of the service ?$CEND"
read TPORT
echo " "

SDOMAIN=`echo $FULLDOMAIN | awk -F. '{print $1}'`
DOMAIN=`echo $FULLDOMAIN | awk -F. '{print $2"."$3}'`

NSREPLY=`nslookup $FULLDOMAIN | tail -n2 | head -n1  | awk '{print $2}'`

if [ "$NSREPLY" == "$SRV_IP" ]; then

        /opt/letsencrypt/letsencrypt-auto certonly -a webroot --webroot-path=/usr/share/nginx/html -d $FULLDOMAIN

        if [ -f /etc/letsencrypt/live/$FULLDOMAIN/fullchain.pem ]; then
                if [ -f /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf ]; then
                        echo "nginx config file already exist for that domain."
                        echo "check /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf before reloading nginx."
                else
                        cp ./files/sample.conf /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf
                        sed -i -- 's/FDQN/'"$FULLDOMAIN"'/g' /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf
                        sed -i -- 's/TIP/'"$TIP"'/g' /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf
                        sed -i -- 's/TPORT/'"$TPORT"'/g' /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf
                        echo -e "[ ${CGREEN}ok$CEND ] /etc/nginx/conf.d/$DOMAIN-$SDOMAIN.conf Generated."
                        mkdir -p /var/log/nginx/$FULLDOMAIN
                        echo -e "[ ${CGREEN}ok$CEND ] /var/log/nginx/$FULLDOMAIN created."
                        /etc/init.d/nginx reload
                        echo " "
                        echo -e "[ ${CGREEN}OK$CEND ] $FULLDOMAIN configured and redirected on $TIP:$TPORT"
                fi
        else
                echo -e "[ ${CRED}KO$CEND ] Certificates files does not exist. Please check letsencrypt logs."
        fi
else
        echo -e "[ ${CRED}KO$CEND ] DNS are not set as expected ("$SRV_IP"). Please set your DNS records first."
        echo "DNS reply : " $NSREPLY
fi
