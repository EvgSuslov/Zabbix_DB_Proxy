# Zabbix_DB_Proxy
instalation process for Zabbix Server + Zabbix Proxy + exteranal database for Zabbix  

![Ubuntu](https://img.shields.io/badge/Ubuntu-Ubuntu%2018.04%20LTS-orange) ![Zabbix](https://img.shields.io/badge/Zabbix-Zabbix--6.x-red)  

## Practice

1.Get ready 3 VMs running Ububntu Linux  
2. Get install on 1st VM Zabbix server with nginx + Agent2  
3. Get install on 2nd VM external DataBase(postgresql + timescaledb extention) + Agent2  
4. Get install on 3rd VM Zabbix proxy + MariaDB + Agent2  
5. Set up all around  
6. ...  

## Instalation process

Ok. First of all you need to run 3 VMs.  
  1st main Zabbix with Zabbix server and Zabbix Agent    
    We will be use Ubuntu server 18.04   
    Run in cli after installation process finished:  
```bash
apt update && apt upgrade -y
``` 
  2nd extarnal database for Zabbix server  
  3rd VM for Zabbix proxy    
  
 For my Linux VMs I usualy use tmux, mc and htop console applications, check them out if you interested.  
 
 # Instalation
  ```bash 
  timedatectl set-timezone your_time_zone 
  ```
  [for your time zone check me out](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "time zones")
  
```bash 
apt install chrony -y
```
```bash 
systemctl enable chrony 
```
```bash 
systemctl start chrony 
```

for fire wall settings run in cli:

```bash
iptables -I INPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
```
```bash
iptables -I INPUT -p tcp --match multiport --dports 10050,10051 -j ACCEPT
```
where:  
port 80 - http and  web requests  
port 443  - for https requests  
port 10050 for GET requests from internal and external zabbix agents  
[for more additional info about default ports check me](https://docs.oracle.com/en/storage/tape-storage/sl4000/slklg/default-port-numbers.html "oracle default ports")  

For save your settings run:  
```bash 
apt install iptables-persistent
```
```bash
netfilter-persistent save
```
```bash
apt update && apt upgrade -y
```

To install zabbix server you need [to go here](https://www.zabbix.com/download?zabbix=6.0&os_distribution=ubuntu&os_version=18.04_bionic&db=postgresql&ws=nginx "offical guide to install zabbix")

#### Install Zabbix repository

```bash
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-3+ubuntu18.04_all.deb
```
```bash
dpkg -i zabbix-release_6.0-3+ubuntu18.04_all.deb
```
```bash
apt update
```
#### Install Zabbix server, frontend, agent
```bash
apt install zabbix-server-pgsql zabbix-frontend-php php7.2-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
```
#### Apache2 remove
if you see somting like this
```bash ..  
NOTICE: You are seeing this message because you have apache2 package installed  
..
```
run 
```bash
sudo apt remove apache2
```
check nginx:
```bash
systemctl status nginx
```
```bash
systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: en
   Active: inactive (dead)
     Docs: man:nginx(8)
 ```
 start and enable nginx
 ```bash 
 systemctl start nginx 
 ```
 ```bash
 systemctl enable nginx
 ```
 
check nginx
```bash
systemctl status nginx
```
```shell
 nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: en
   Active:active (running)
     Docs: man:nginx(8)
 Main PID: 13931 (nginx)
    Tasks: 3 (limit: 4656)
   CGroup: /system.slice/nginx.service
           ├─13931 nginx: master process /usr/sbin/nginx -g daemon on; master_pr
           ├─13932 nginx: worker process
           └─13933 nginx: worker process
```
 
if you still visual apache2 default page, just go for index.html in my repo. replace index.html with default nginx file in /var/lib/html/ index.html

Zabbix interface working om PHP.ini, so we need our PHP to install for zabbix tunning
```bash
apt install php php-fpm php-mysql php-pear php-cgi php-common php-ldap php-mbstring php-snmp php-gd php-xml php-bcmath
```
open php.ini for settings  

```bash
nano /etc/php/7.***/fpm/php.ini  
```  
whrere /7.*** / is your php version


