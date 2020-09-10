#!/bin/bash -ex
cd `dirname $0`
./hugo.sh -D server -w -b http://localhost/
