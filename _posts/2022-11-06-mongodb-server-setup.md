---
layout: post
title: mongodb server setup
date: 2022-11-06 19:37 +0330
---


### install mongo using docker
```yml
services:
  mongo:
    image: mongo #:4.4.6
    restart: unless-stopped
    container_name: mongo
    environment:
      MONGO_INITDB_DATABASE: testdb
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
    ports:
      - 27017:27017
    volumes:
      - ./mongo_db:/data/db
      - ./mongod.conf:/etc/mongod.conf
    entrypoint: ["mongod","--config","/etc/mongod.conf"]

  mongo-express:
    image: mongo-express
    container_name: mongo-express
    restart: always
    profiles: ['dev']
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: root
      ME_CONFIG_MONGODB_ADMINPASSWORD: password
      ME_CONFIG_MONGODB_URL: mongodb://root:password@mongo:27017/

```
{:file="docker-compose.yaml" }


```yaml
net:
  port: 27017
  bindIp: 0.0.0.0

# security:
  # authorization: enabled
```
{:file="mongod.conf" }


### create user
login to mongoshell
```bash
use admin
db.createUser(
  {
    user: "ali",
    pwd: "password",
    roles: [ { role: "root", db: "admin" } ]
  }
)

# if you have already created the admin user, you can change the role like this:
use admin;
db.grantRolesToUser('admin', [{ role: 'root', db: 'admin' }])
db.updateUser("admin", {pwd: "newpassowrd"})
```
## check current users
```bash
db.getUsers()
# result
{
  users: [
    {
      _id: 'admin.root',
      userId: new UUID("eeb16fff-14eb-4ef5-8b5a-eeb16fff3312"),
      user: 'root',
      db: 'admin',
      roles: [ { role: 'root', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1
}
```

### enable security
uncomment security lines in `mongod.conf` file