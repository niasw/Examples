#!/bin/bash
# make soft links to all executable files in directory 19.1.0

_verDir="19.1.0"; # version named directory
_f="";
for _file in $_verDir/*; do
  if ! [ -d "$_file" ] && [ -x "$_file" ]; then
    echo "$_file";
    _f=`echo "$_file" | sed -e "s/$_verDir\///;"`;
    ln -s $_file $_f;
  fi
done
