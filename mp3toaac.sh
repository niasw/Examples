#!/bin/bash
# this is a bash code to convert all mp3 files in the current directory into aac files.
# when you have installed programs 'lame' and 'faac', you can run this code to do conversion.
# if you want to add options, please look up in the manuals of lame and faac.
# this code is just for example, you can use or copy or edit it as you like.
# there are no warranty for this code.
# -- niasw

f=''

for f in *.mp3
do
  f=`echo $f |sed 's/\.mp3//'`
#  f=`echo $f |sed 's/[^A-Za-z0-9_+-]/\\\&/g'` #this one add '\' before special characters, but we don't use it here.
  echo "$f.mp3"
  lame --decode "$f.mp3"
  faac "$f.wav"
  rm "$f.wav"
done
