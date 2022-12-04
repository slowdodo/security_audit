#!/bin/bash

# scan all global IP addresses
nmap -sV --script=banner 0.0.0.0/0

# loop through all the hosts that were scanned
for host in $(nmap -sV --script=banner 0.0.0.0/0 | grep "Nmap scan report" | awk '{print $5}'); do
    # print the hostname and IP address of the scanned host
    hostname=$(nmap -sV --script=banner $host | grep "Hostname:" | awk '{print $2}')
    echo "Hostname: $hostname, IP Address: $host"

    # get the list of services running on the scanned host
    services=$(nmap -sV --script=banner $host | grep "open" | awk '{print $1}')

    # loop through the list of services
    for service in $services; do
        # print the port and service name of each service
        service_name=$(nmap -sV --script=banner $host | grep $service/tcp | awk '{print $3}')
        echo "Port: $service, Service: $service_name"

        # check if the service has a banner
        if $(nmap -sV --script=banner $host | grep $service/tcp | grep -q "Banner:"); then
            # print the banner of the service
            banner=$(nmap -sV --script=banner $host | grep $service/tcp | grep "Banner:" | awk '{print $2}')
            echo "Banner: $banner"
        fi
    done
done
