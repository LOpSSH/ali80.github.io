#!/bin/bash
set -x
./deploy.sh
rsync -zavP _site/ friends:/home/ali/pouyaio/www/_site
