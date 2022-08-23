# Zabbix_DB_Proxy
instalation process for Zabbix Server + Zabbix Proxy + exteranal database for Zabbix  

![Ubuntu](https://img.shields.io/badge/Ubuntu-Ubuntu%2018.04%20LTS-orange)![Zabbix](https://img.shields.io/badge/Zabbix-Zabbix--6.x-red)  

##Practice

1.Get ready 3 VMs running Ububntu Linux  
2. Get install on 1st VM Zabbix server with nginx + Agent2  
3. Get install on 2nd VM external DataBase(postgresql + timescaledb extention) + Agent2  
4. Get install on 3rd VM Zabbix proxy + MariaDB + Agent2  
5. Set up all around  
6. ...  

## Instalation process


  Zabbix instalation 
  Database instalation
  Zabbix server & Zabbix Agent run

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




