---
layout: post
title: Nginx Proxy Manager
date: 2022-10-07 19:08 +0330
tags: [nginx]
categories: []
---


## serve static content
[ref](https://github.com/NginxProxyManager/nginx-proxy-manager/issues/280)

complete @ikomhoog answer, thanks to @ikomhoog . 👍

1. add volume like
    > /opt/websites:/mnt/user/appdata/NginxProxyManager/websites
2. set the details to 1.1.1.1:1 or everything you like.
3. then in advance section add these lines:

```bash
location / {
    root  /mnt/user/appdata/NginxProxyManager/pouyaio;
}
```
or this whichc is not working properly
```bash
root /mnt/user/appdata/NginxProxyManager/websites;
index index.html;
location / {
    try_files $uri /index.html /index.html;
}
```

> don't forget to run docker-compose up -d
{: .prompt-tip }
you can use it in a subdomain or main domain, have fun.

## docker-compose file
```yaml
services:
    nginxpm:
        container_name: nginxpm
        image: 'jc21/nginx-proxy-manager:latest'
        restart: unless-stopped
        ports:
        - '80:80'
        - '81:81'
        - '443:443'
        volumes:
        - ./data:/data
        - ./letsencrypt:/etc/letsencrypt
```
## add basic auth
add following to advanced section
```bash
auth_basic "Authorization required";
auth_basic_user_file /data/access/{{access_list_id}};
proxy_set_header Authorization "";
deny all;
satisfy any;
```
to find access list id, go to `/data/access` folder