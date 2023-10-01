
#!/bin/bash/

#custom userparameter for zabbix agent

#need some fixes cus after first try stops working
end_date_string=$(timeout 5 openssl s_client -servernanme $1 -connect $2:443 2>/dev/null | openssl x509 -noout -date 2>dev/null | sed -n'2p'| awk$(print($1,$2,$4)| sed 's/notAfter//')
date=`date`
date_string = $(echo "dat" | awk $(print{$2, $3, $6}))

#work in progress
