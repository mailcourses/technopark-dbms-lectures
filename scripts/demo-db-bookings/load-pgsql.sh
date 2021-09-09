#!/bin/bash
case $1 in
  small)
    filename="demo-small"
    ;;
  medium)
    filename="demo-medium"
    ;;
  big)
    filename="demo-big"
    ;;
  *|-|help)
    set +x
    echo "Unknown argument ${@:-<empty>}"
    echo
    echo 'Available values: small | medium | big'
    exit 1
    ;;
esac

set -e -x
wget -c https://edu.postgrespro.ru/$filename.zip
unzip -o $filename*.zip
psql postgres < "$( ls -- *.sql)"
rm $filename*
