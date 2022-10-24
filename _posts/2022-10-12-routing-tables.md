---
layout: post
title: Routing Tables
tags: [networking, linux]
date: 2022-10-12 12:20 +0330
---
```bash
$  route -n
# or 
$ netstat -rn 
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.1.24    0.0.0.0         255.255.255.252 U     0      0        0 eth0
192.168.0.0     0.0.0.0         255.255.255.0   U     0      0        0 eth1
192.168.25.0    0.0.0.0         255.255.255.0   U     0      0        0 eth2
0.0.0.0         192.168.1.25    0.0.0.0         UG    0      0        0 eth0
```
