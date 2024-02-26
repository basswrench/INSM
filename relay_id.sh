#!/usr/bin/expect -f

# Connect to telnet session
spawn telnet 192.168.0.54 23

# Expect the telnet prompt
expect "Escape character is '^]'"

# Send the "id" command and expect the output
send "id\r"

# Capture the output of the 'id' command
expect {
    -re "id\r\n(.*\r\n=).*" {
        set telnet_data $expect_out(1,string)
        puts "Telnet output received: $telnet_data"
        # Format data for Zabbix sender
        set hostname "192.168.0.54"
        set key "telnet_751"  ;# Modify this key value as needed
        set zabbix_data "$hostname $key \"$telnet_data\""
        puts "Data formatted for Zabbix sender: $zabbix_data"

        # Send data to Zabbix server
        spawn zabbix_sender -z 192.168.0.50 -p 10051 -s "$hostname" -k "$key" -o "$telnet_data" -vv
        expect {
            timeout { puts "Timeout occurred while waiting for zabbix_sender response" }
            eof { puts "Data sent to Zabbix" }
        }
    }
    timeout { puts "Timeout occurred while waiting for telnet response" }
    "Connection closed by foreign host" { puts "Connection closed by foreign host." }
    default { puts "Unexpected output from telnet session: $expect_out(buffer)" }
}
