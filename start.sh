#!/bin/bash -ex
hugo -D server -w -b http://localhost/
find public/ -iname ".*" -exec rm {} \;
