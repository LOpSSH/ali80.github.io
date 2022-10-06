---
layout: post
title: Ubuntu Server Setup
date: 2022-10-06 19:00 +0330
---
ref: https://gist.github.com/bradtraversy/b8b72581ddc940e0a41e0bc09172d91b

```bash
adduser ali # all use ali
usermod -aG sudo ali # make ali superuser

sudo apt update
sudo apt upgrade -y
sudo apt install nodejs -y
sudo apt install fail2ban -y
```


## install nvm & nodejs
```bash
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
# log out and login again then
nvm install 16.15.1

sudo apt install npm -y &&  sudo npm i -g yarn
npm install -g pnpm
```

## install tmux
```bash
sudo apt install tmux

#commands
tmux a
```

## setup passwordless login

```bash
Ref: https://upcloud.com/community/tutorials/use-ssh-keys-authentication/

mkdir -p ~/.ssh
chmod 700 ~/.ssh # limit access to only yourself

# generate the key
ssh-keygen -t rsa

# Copy the public half of the key pair to your cloud server using the following command
ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
# or for windows
cat ~/.ssh/id_rsa.pub | ssh ali@192.168.1.230 "cat >> ~/.ssh/authorized_keys"

sudo nano /etc/ssh/sshd_config
** How to configure ssh client to use private keys automatically **
Yes, you want to create a ~/.ssh/config file. That lets you define a shortcut name for a host, the username you want to connect as, and which key to use. Here's part of mine, with hostnames obfuscated:

Host 192.168.1.22
    HostName 192.168.1.22
    User pi
    IdentityFile ~/.ssh/pi22
```

## setting alias for your remote machine
```bash
vim ~/.ssh/config
# then add the following section
Host targaryen
    HostName 192.168.1.10
    User daenerys
    Port 7654
    IdentityFile ~/.ssh/targaryen.key

```

## disabling password
```bash
sudo vim /etc/ssh/sshd_config

# Look for where it says
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin prohibit-password


# restart service
sudo systemctl restart sshd
```

## install oh-my-zsh
```bash
# install oh-my-zsh
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### install zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

```bash

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fishy"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    copyfile
)

source $ZSH/oh-my-zsh.sh
```
{:file=".zshrc" }

### setup nginx
```bash
# enable firewall
sudo ufw enable

# open ports on firewall
sudo ufw allow ssh (Port 22)
sudo ufw allow http (Port 80)
sudo ufw allow https (Port 443)

# check firewall status
sudo ufw status

# FIX ufw firewall issue with docker from below link!
# https://github.com/chaifeng/ufw-docker#solving-ufw-and-docker-issues
```

```bash
sudo apt install nginx -y

sudo nano /etc/nginx/sites-available/default
# find location area in the file and replace with this
location / {
        proxy_pass http://localhost:5000;    # or which other port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

# change server name to this
server_name yourdomain.com www.yourdomain.com;

# save and exit and then check the syntax
sudo nginx -t

# restart service
sudo service nginx restart
```

### Let’s Encrypt renewal for Cloudflare & NGINX
ref:[^1] https://github.com/EmptyVisual/letsencrypt-nginx-cloudflare


#### install required packages
```bash
sudo apt install certbot python3-certbot-nginx python3-certbot-dns-cloudflare -y
```
#### Create a new config file
```bash
cd ~/
mkdir .secrets/
nano .secrets/cloudflare.ini
```
Use the following configuration
```bash
dns_cloudflare_email = user@domain.tld
dns_cloudflare_api_key = Global API Key
```
> Obtain your Global API key here: https://dash.cloudflare.com/profile/api-tokens
{: .prompt-tip }



## References
[^1]: And here is the definition.