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
