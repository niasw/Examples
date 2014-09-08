#!/bin/bash
#
#  description: a script to rsync with my htc phone
#  developer: sun.niasw@gmail.com

function usage
{
    echo -e "Usage:\n\t$0\t[-s] [-r] [-h]"
    echo -e "\t -s\tsend to  external device"
    echo -e "\t -r\tget from external device"
    echo -e "\t -h\thelp, print this message then exit"
}

function sendfiles
{
  rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av ~/syncfolder niasw@192.168.32.32:/data/data/com.spartacusrex.spartacuside/files/
}

function getfiles
{
  rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av niasw@192.168.32.32:/data/data/com.spartacusrex.spartacuside/files/syncfolder ~/
}

op=''

while getopts "srh" option
do
    case $option in
        s   )   op='s'
                sendfiles;;
        r   )   op='r'
                getfiles;;
        *   )   usage
                exit 1;;
    esac
done

if ! [[ -n $op ]]; then
  echo "Sorry, I didn't get enough information."
  usage
fi
