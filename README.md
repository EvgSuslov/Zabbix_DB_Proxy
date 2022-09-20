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
nano /etc/php/7.*/fpm/php.ini  
```
whrere /7.* / is your php version  

date.timezone = "your_time_zone"  

max_execution_time = 300  

post_max_size = 16M  

max_input_time = 300  

max_input_vars = 10000  

```bash
systemctl enable php7.*-fpm
```
```bash
systemctl restart php7.*-fpm
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
apt install zabbix-frontend-php zabbix-get zabbix-sql-scripts zabbix-server-pgsql
```   
# 2. Install Postgresql database
## To install Postgresql check out this article How to install PostgreSQL 14 on Ubuntu 20.04|21.10

###Create a file repository for Postgresql
```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```
Next is to import GPG key
```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```
After this, we need to update our system again.
```bash 
apt update
```
And lastly install Postgresql 14 with the following command;
```bash
sudo apt install postgresql-14 -y
```
Once installed login into Postgresql shell;
```bash
sudo -i -u postgres
```
We now need to create a database user with permissions like this:
```bash
sudo -u postgres createuser --pwprompt zabbix
```
Setup the database Zabbix with previously created user.
```bash
sudo -u postgres createdb -O zabbix -E Unicode -T template0 zabbix
```
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
apt install zabbix-sql-scripts zabbix-agent
```
After this we now need to import initial schema and data. Enter your initial created password when prompted.
```bash
zcat /usr/share/doc/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
```
# 5. Configure database for Zabbix server
Open your preferred text editor and edit the following /etc/zabbix/zabbix_server.conf. I am using vim as text editor.
```bash
sudo vi /etc/zabbix/zabbix_server.conf
```
retype this
```bash
DBPassword=your_password
```
install time scale db
```bash
apt install gnupg postgresql-common apt-transport-https lsb-release wget
```
```bash
/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
```
```bash
echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list
```
```bash
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add -
```
```bash
apt update
```
```bash
apt install timescaledb-2-postgresql-14
```

whach closely for postgresql.conf

yo must add in your postgresql.conf  
also add your main zabbix server ip or '*' insted of local host  
```bash
shared_preload_libraries = 'timescaledb'
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
```bash
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

listen_addresses = '*'          # what IP address(es) to listen on;
                                        # comma-separated list of addresses;
                                        # defaults to 'localhost'; use '*' for all
                                        # (change requires restart)
port = 5432                             # (change requires restart)
max_connections = 100                   # (change requires restart)
#superuser_reserved_connections = 3     # (change requires restart)
unix_socket_directories = '/var/run/postgresql' # comma-separated list of directories
                                        # (change requires restart)
#unix_socket_group = ''                 # (change requires restart)
#unix_socket_permissions = 0777         # begin with 0 to use octal notation
```
# 3. zabbix proxy
zabbix repo install
```bash
wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1%2Bubuntu22.04_all.deb
```
```bash
dpkg -i zabbix-release_6.2-1+ubuntu22.04_all.deb
```
```bash
apt update
```
#### zabbix install
```bash
 apt install zabbix-proxy-mysql zabbix-sql-scripts
 ```
#### install DB
 ```bash
sudo apt-get update
```
```bash
sudo apt-get install mysql-server
```
follow steps by Y or N in the following command:
```bash
sudo mysql_secure_installation
```
check database status
```bash
systemctl status mysql.service
```
```bash
sudo systemctl mysql start
```
thing
```bash
mysqladmin -p -u root version
```
it will return
```bash
mysqladmin  Ver 8.42 Distrib 5.7.16, for Linux on x86_64
Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Server version      5.7.16-0ubuntu0.16.04.1
Protocol version    10
Connection      Localhost via UNIX socket
UNIX socket     /var/run/mysqld/mysqld.sock
Uptime:         30 min 54 sec
Threads: 1  Questions: 12  Slow queries: 0  Opens: 115  Flush tables: 1  Open tables: 34  Queries per second avg: 0.006
```
#### create DB
 ```mysql
 # mysql -uroot -p
password
mysql> create database zabbix_proxy character set utf8mb4 collate utf8mb4_bin;
mysql> create user zabbix@localhost identified by 'password';
mysql> grant all privileges on zabbix_proxy.* to zabbix@localhost;
mysql> set global log_bin_trust_function_creators = 1;
mysql> quit;
```
#### zab_zaql_prox
```bash
cat /usr/share/doc/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix_proxy
```
```mysql
# mysql -uroot -p
password
mysql> set global log_bin_trust_function_creators = 0;
mysql> quit;
```
DB settings
```bash
nano /etc/zabbix/zabbix_proxy.conf
```
```bash
DBPassword=password
```
start
```bash
# systemctl restart zabbix-proxy
# systemctl enable zabbix-proxy
```
# 3 last step Agent2
## Zabbix Agent2
lets install zabbix agent for servers. Than we will configure PSK encryption.

agent 2 isntalling and configure
previosly we alreadey installed zabbix repo so:
```bash
apt install zabbix-agent2
```
open conf:
```bash
nano /etc/zabbix/zabbix_agent2.conf
```
type 127.0.0.1 for local zabbix server agent and your main zabbix server IP addres 
```bash
Server=127.0.0.1
```
```bash
systemctl enable zabbix-agent2
```
```bash
systemctl restart zabbix-agent2
```
lets switsh for web vercion. go to "settings - hosts" we will see 1 configured server 'zabbix server'

in host section we will see our main server

on the right you will see green ZBX button - it ok, if not google how to fix:

Zabbix agent - status ok

agent is working and configured.

### PSK encryption on Agents
Чтобы обезопасить передачу данных между сервером и агентом, настроим шифрование по PSK ключу.

На агенте открываем конфигурационный файл:
```bash
nano /etc/zabbix/zabbix_agentd.conf
```
ctrl+w for ez search
```
TLSConnect=psk
...
TLSAccept=psk
...
TLSPSKIdentity=PSK 001
...
TLSPSKFile=/etc/zabbix/agent_key.psk
```
open key gen:
```bash
openssl rand -hex 32 > /etc/zabbix/agent_key.psk
```
check and save whats inside:
```bash
cat /etc/zabbix/agent_key.psk
```

restart agent:
```bash
systemctl restart zabbix-agent
```
enter in web zabbix settings. hosts list:

click on our server or host with agent2 installed on

go to Encryption. find PSK button, click it, enter yor id TLSPSKIdentity, cp your key

click refresh

boom. encrypted. 
repeat for all agents.


# Zabbix Proxy
## zabbix proxy + maria db + zabbix agent  




