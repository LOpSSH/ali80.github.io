#!/bin/bash
set -x
./deploy.sh
rsync -avP _site/ friends:/home/ali/pouyaio/www/_site
