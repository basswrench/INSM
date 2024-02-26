#!/bin/bash

# Read data from output.txt
telnet_data=$(<output.txt)

# Check if data is empty
if [ -z "$telnet_data" ]; then
    echo "No data found in output.txt."
    exit 1
fi

# Format data for Zabbix trapper
hostname="zabbix-server-mysql"
key="telnet_751.sh"
value="$telnet_data"

# Send data to Zabbix server using trapper item
echo "$hostname $key $value" | zabbix_sender -z 192.168.0.50 -s "$hostname" -T -i -
