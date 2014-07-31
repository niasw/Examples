#!/bin/bash
#
#  description: a script to rsync with my htc phone
rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av niasw@192.168.32.32:/data/data/com.spartacusrex.spartacuside/files/syncfolder ~/
rsync -e 'ssh -p 8090' --rsync-path=/data/data/com.spartacusrex.spartacuside/files/system/bin/rsync -av ~/syncfolder niasw@192.168.32.32:/data/data/com.spartacusrex.spartacuside/files/
