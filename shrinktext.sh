#!/bin/bash
#
#  description: a script to delete white space of a text file
#  Usage:
#    shrinktext -i INPUT [-o OUTPUT]
#  Options:
#  	-i	set INPUT filename
#  	-o	set OUTPUT filename, if empty then output to stdout
#  	-h	help, print this message then exit
#  Copyright (C) 2013 niasw (Sun Sibai) <niasw@pku.edu.cn>
#
#    shrinktext  is free software: you can redistribute it and/or
#  modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation, either version 3 of
#  the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.
#

function usage
{
    echo -e "Usage:\n\tshrinktext -i INPUT [-o OUTPUT]";
    echo -e "Options:";
    echo -e "\t -i\tset INPUT filename";
    echo -e "\t -o\tset OUTPUT filename, if empty then output to stdout";
    echo -e "\t -h\thelp, print this message then exit";
}

ifile='';
ofile='';

while getopts "i:o:h" option
do
    case $option in
        i   )   ifile=$OPTARG;;
        o   )   ofile=$OPTARG;;
        *   )   usage
                exit 1;;
    esac
done

if [[ -n $ifile ]]; then
    if [[ -n $ofile ]]; then
        cat "$ifile" | sed ':1;N;s/\s\+/ /g;t1' > "$ofile"; #:LABEL;...COMMANDS...;tLABEL to loop
    else
        cat "$ifile" | sed ':1;N;s/\s\+/ /g;t1';
    fi
else
    echo "Sorry, there seems to be no input filename.";
    usage;
fi
