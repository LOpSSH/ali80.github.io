---
layout: post
title: Linux Tips
date: 2022-10-10 00:50 +0330
tags: [linux]
categories: [linux]
---

## copy files to remote machine

copy contents of _site to server's www folder
```bash
rsync -avP _site/ user@server:/home/user/www
or
scp -r _site user@server:/home/user/www
```


## check internet speed

```bash
wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
./speedtest-cli --list
./speedtest-cli --server SERVER_ID
```


## search for files
```bash
# using ripgrep
rg --files | rg file_name
# OR
alias rgf='rg --files | rg'
rg file_name
# OR
ls -R | grep file_name
```
restrict to certain file types
```bash
rg 'nodejs' *.ts
```

show multiple lines
```bash
# context: before and after
rg string -C5
# before
rg string -B5
#after
rg string -A5
```


## netstat
### show used ports
```bash
netstat -plnt
# OR
ss -tulpn
```

## get disk usage
```bash
# ncdu
sudo apt install ncdu
sudo ncdu /
```

## ssh through socks proxy
```bash
ssh user@remotehost -o "ProxyCommand=nc -X 5 -x proxyhost:proxyport %h %p"
```

or add this to `.ssh/config`
```yml
Host server_ip
  HostName server_ip
  User ali
  ProxyCommand nc -X 5 -x 127.0.0.1:10808 %h %p
```