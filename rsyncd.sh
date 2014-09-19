#!/bin/bash
#
#  description: a script to rsync with my htc phone
#  developer: sun.niasw@gmail.com

function usage
{
    echo -e "Usage:\n\t$0\t[-4 ???.???.???.???] [-s] [-r] [-h]"
    echo -e "\t -s\tsend to  external device"
    echo -e "\t -r\tget from external device"
    echo -e "\t -4 ???.???.???.???\t ip of external device"
    echo -e "\t -h\thelp, print this message then exit"
}

ipadd=192.168.32.32

function sendfiles
{
  rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av ~/syncfolder niasw@$1:/data/data/com.spartacusrex.spartacuside/files/
}

function getfiles
{
  rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av niasw@$1:/data/data/com.spartacusrex.spartacuside/files/syncfolder ~/
}

op=''

while getopts "4:srh" option
do
    case $option in
        4   )   ipadd=$OPTARG;;
        s   )   op='s';;
        r   )   op='r';;
        *   )   usage
                exit 1;;
    esac
done

if ! [[ -n $op ]]; then
  echo "Sorry, I didn't get enough information."
  usage
elif [[ $op == 's' ]]; then
  sendfiles $ipadd
elif [[ $op == 'r' ]]; then
  getfiles $ipadd
fi
