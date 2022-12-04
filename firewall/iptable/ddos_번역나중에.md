
To protect against DDOS attacks using iptables, you can use the following commands:  
Limit the number of incoming connections from a single IP address:  
``` bash
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above N -j REJECT
```
where N is the maximum number of connections allowed from a single IP address.

Limit the rate of incoming connections:
Copy code
``` bash
iptables -A INPUT -p tcp --syn -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --syn -m state --state NEW -m recent --update --seconds S --hitcount N -j REJECT
```
where S is the time interval (in seconds) and N is the number of connections allowed within that interval.

# Limit the rate of incoming traffic 
``` bash
iptables -A INPUT -p tcp -m state --state NEW -m limit --limit L/m --limit-burst B -j ACCEPT
```
where L is the maximum rate of incoming traffic (in packets per minute) and B is the maximum burst size.

These commands should be used in combination to effectively protect against DDOS attacks.