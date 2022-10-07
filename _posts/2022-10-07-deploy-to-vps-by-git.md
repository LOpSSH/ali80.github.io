---
layout: post
title: Deploy to VPS by Git
date: 2022-10-07 03:56 +0330
---

## setup remote
create `bare` remote repo
```bash
mkdir repo.git
cd repo.git
git init --bare
```

create `post-receive` script
```bash
#!/bin/sh

# for debugging
# set -ex
# set -vx

# the work tree, where the checkout/deploy should happen
TARGET="/home/ali/reploy-dir"

# the location of the .git directory
GIT_DIR="/home/ali/repo.git"

BRANCH="master"

while read oldrev newrev ref
do
        # only checking out the master (or whatever branch you would like to deploy)
        if [ "$ref" = "refs/heads/$BRANCH" ];
        then
                echo "Ref $ref received. Deploying ${BRANCH} branch on server..."
                git --work-tree="${TARGET}" --git-dir="${GIT_DIR}" checkout -f ${BRANCH}

                NOW=$(date +"%Y%m%d-%H%M")
                git tag release_$NOW $BRANCH

                echo "   /==============================="
                echo "   | DEPLOYMENT COMPLETED"
                echo "   | Target branch: $BRANCH"
                echo "   | Target folder: $TARGET"
                echo "   | Tag name     : release_$NOW"
                echo "   \=============================="

                $TARGET/deploy.sh

        else
                echo "Ref $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
        fi
done

# git --git-dir=/home/ali/repo.git --work-tree=/home/ali/repo checkout master -f
```
{: file="repo/hooks/post-receive"}

set to executable
```bash
chmod +x post-receive
```

create empty folder in another location
```bash
mkdir deploy-dir
```

## setup local
add remote to local repo
```bash
git remote add remote_name ssh://user@domain.com/home/repo.git
```

## deploy
```bash
git push remote_name master
```


## ref
- [How To Set Up Automatic Deployment with Git with a VPS](https://www.digitalocean.com/community/tutorials/how-to-set-up-automatic-deployment-with-git-with-a-vps)
- https://gist.github.com/nonbeing/f3441c96d8577a734fa240039b7113db#file-post-receive
- https://gist.github.com/lemiorhan/8912188