#!/usr/bin/env bash

#node /usr/local/bin/gitdown ./.README/README.md --output-file ./README.md

## Build the documentation
mkdocs build

## Publish the files to docs.daplab.ch
rsync --omit-dir-times --chmod=Dg+X,ugo+w,ugo+r -av site/ daplab-wn-12.fri.lan:/var/www/docs.daplab.ch
