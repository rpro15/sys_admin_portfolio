# MikroTik RouterOS export (sanitized)
/interface vlan
add interface=bridge-lan name=vlan10-corp vlan-id=10
add interface=bridge-lan name=vlan20-guest vlan-id=20

/ip address
add address=192.168.10.1/24 interface=vlan10-corp network=192.168.10.0
add address=192.168.20.1/24 interface=vlan20-guest network=192.168.20.0

/ip pool
add name=pool-vlan10 ranges=192.168.10.100-192.168.10.199
add name=pool-vlan20 ranges=192.168.20.100-192.168.20.199

/ip dhcp-server
add address-pool=pool-vlan10 interface=vlan10-corp lease-time=8h name=dhcp-vlan10
add address-pool=pool-vlan20 interface=vlan20-guest lease-time=4h name=dhcp-vlan20

/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.10.10 gateway=192.168.10.1 domain=corp.local
add address=192.168.20.0/24 dns-server=192.168.10.10 gateway=192.168.20.1
