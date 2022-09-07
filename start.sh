#!/bin/bash -ex
hugo --disableFastRender -D server -w -b http://localhost/
find public/ -iname ".*" -exec rm {} \;
