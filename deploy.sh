#!/bin/sh
set -x
JEKYLL_ENV=production bundle exec jekyll b
# docker run -it --rm \
#     --volume="$PWD:/srv/jekyll" \
#     -p 4000:4000 jekyll/jekyll \
#     jekyll bundle
