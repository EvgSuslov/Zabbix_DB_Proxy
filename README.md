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

date.timezone = "your_time_zone"
...
max_execution_time = 300
...
post_max_size = 16M
...
max_input_time = 300
...
max_input_vars = 10000  
```bash
systemctl enable php7.***-fpm
```
```bash
systemctl restart php7.***-fpm
```

```bash
nano /etc/nginx/sites-enabled/default
```
in location we add  

```bash
index  index.php;
```
in server section we add
```bash
location ~ \.php$ {
              set $root_path /var/www/html;
              fastcgi_buffer_size 32k;
              fastcgi_buffers 4 32k;
              fastcgi_pass unix:/run/php/php7.***-fpm.sock;
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $root_path$fastcgi_script_name;
              include fastcgi_params;
              fastcgi_param DOCUMENT_ROOT $root_path;
      }
 ```
   
whrere /7.*** / is your php version

checkout nginx settings 
```bash
nginx -t
```
and restart nginx

```bash
systemctl restart nginx
```

create index.php

```bash
nano /var/www/html/index.php
```
cp thin in

```php
<?php phpinfo(); ?>
```

in brouser type http:// server IP-addres /  
and we see default php page  
###### For default zabbix server insallation

```bash
cat /etc/os-release | grep VERSION_ID
```  
find your relise on https://repo.zabbix.com/

```bash
wget https://repo.zabbix.com/zabbix/6.1/ubuntu/pool/main/z/zabbix-release/***
```  
where *** your VERSION_ID  
```bash
dpkg -i zabbix-release_*.deb
```
```bash
apt update
```
installing all server stuff
```bash
apt install zabbix-frontend-php zabbix-get zabbix-sql-scripts zabbix-server-mysql
```   


## 2 Database
### you must stop zabbix server service before anything you do with DB
#### Step 1: Check requirements and update system
You will need the following:

Ubuntu 20.04|18.04 installed on your machine.
A user with sudo privileges.
```bash 
sudo apt update && sudo apt upgrade
```
install if nessary:
```bash
sudo apt -y install gnupg2 wget vim
```
check out you psql version, you will need the latest one(14+)
```bash
sudo apt-cache search postgresql | grep postgresql
```
For this guide, we are interested in the latest release version PostgreSQL 14 which is not provided by the default repositories and thus we will consider adding another repository.  

```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```
```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```
```bash
sudo apt -y update
```
Now that we have added the repository to our system, proceed and install PostgreSQL 14 using the command below.  
```bash
sudo apt -y install postgresql-14
```

```bash
root:# systemctl status postgresql
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor prese
   Active: active (exited) 
 Main PID: 31925 (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 4656)
   CGroup: /system.slice/postgresql.service
 ```
Verify the installed PostgreSQL version.  
```bash
sudo -u postgres psql -c "SELECT version();"
```

install time scale db

whatch closely for postgresql.conf  
yo must add in your postgresql.conf  
also add your main zabbix server ip insted of local host  
```bash
shared_preload_libraries = 'timescaledb
```
```psql
You are now connected to database "zabbix" as user "postgres".
zabbix=# CREATE EXTENSION IF NOT EXISTS timescaledb;
FATAL:  extension "timescaledb" must be preloaded
HINT:  Please preload the timescaledb library via shared_preload_libraries.

This can be done by editing the config file at: /etc/postgresql/14/main/postgresql.conf
and adding 'timescaledb' to the list in the shared_preload_libraries config.
        # Modify postgresql.conf:
        shared_preload_libraries = 'timescaledb
 ```

add it in pg_hba.conf
```bash
host zabbix zabbix 0.0.0.0/0 scram-sha-256
```

