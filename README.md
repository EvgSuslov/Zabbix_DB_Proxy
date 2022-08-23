# Zabbix_DB_Proxy
instalation process for Zabbix Server + Zabbix Proxy + exteranal database for Zabbix  

https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white

# Instalation process

  Zabbix instalation 
  Database instalation
  Zabbix server & Zabbix Agent run

Ok. Firs of all you need to run 3 VMs. 
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

