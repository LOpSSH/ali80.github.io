---
layout: post
title: Nginx Proxy Manager
date: 2022-10-07 19:08 +0330
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
