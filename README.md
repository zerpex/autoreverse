# nginx reverse proxy

## Description :
This script automatically install some services to any debian based distro :
- [nginx](https://nginx.org/) : Web server used as a reverse proxy.
- [letsencrypt](https://sabnzbd.org/) : Certificate authority that delivers free certificates.

It concist on 2 scripts :
- first_run.sh will install nginx, letsencrypt and set up nginx to works with the script.
- addSubDomain.sh will generate letsencrypt certificates and nginx configuration in order to secure (https) and redirect a sub-domain to a specific IP:PORT.

## How to use this script :
1- Clone this repository :  
`git clone https://github.com/zerpex/autoreverse.git reverse`

2- Place yourself on the folder :  
`cd reverse`

3- Execute :  
`./first_run.sh`

4- Each time you have to configure a new sub-domain, execute :  
`./addSub_Domain.sh`

## Notes :
- ...

## To do :
- You tell me !
