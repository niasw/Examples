#!/bin/bash
#
#  description: a script to run mpb calculation
#  Usage:
#    dompb	[-{d|e|m|l|c}] -i INPUT [-o OUTPUT]
#  Options:
#  	-d	output data only (default) 	INPUT:ctl 	OUTPUT:te.txt,tm.txt
#  	-e	output TE data only 		INPUT:ctl 	OUTPUT:te.txt
#  	-m	output TM data only 		INPUT:ctl 	OUTPUT:tm.txt
#  	-l	output the origin log file 	INPUT:ctl 	OUTPUT:log
#  	-c	convert the mpb log file 	INPUT:log 	OUTPUT:te.txt,tm.txt
#  	-h	help, print this message then exit
#  Copyright (C) 2013 niasw (Sun Sibai) <niasw@pku.edu.cn>
#
#  dependency:  mpb program from MIT <http://ab-initio.mit.edu/wiki/index.php/MIT_Photonic_Bands>
#
#      dompb   is free software: you can redistribute it and/or
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
    echo -e "Usage:\n\tdompb\t[-{d|e|m|l|c}] -i INPUT [-o OUTPUT]";
    echo -e "Options:";
    echo -e "\t -d\toutput data only (default) \tINPUT:ctl \tOUTPUT:te.txt,tm.txt";
    echo -e "\t -e\toutput TE data only \t\tINPUT:ctl \tOUTPUT:te.txt";
    echo -e "\t -m\toutput TM data only \t\tINPUT:ctl \tOUTPUT:tm.txt";
    echo -e "\t -l\toutput the origin log file \tINPUT:ctl \tOUTPUT:log";
    echo -e "\t -c\tconvert the mpb log file \tINPUT:log \tOUTPUT:te.txt,tm.txt";
    echo -e "\t -h\thelp, print this message then exit";
}

ifile='';
ofile='';
modes='d';
tewav='e';
tmwav='m';
tempf='';

while getopts "i:o:demlc" option
do
    case $option in
        i   )   ifile=$OPTARG;;
        o   )   ofile=$OPTARG;;
        d   )   ;;
        e   )   tmwav='';;
        m   )   tewav='';;
        l   )   modes='l';;
        c   )   modes='c';;
        *   )   usage
                exit 1;;
    esac
done

if [[ $modes != 'c' ]]; then
    ifile=`echo $ifile|sed 's/\.ctl$//g'`;
    ifile=`echo "$ifile.ctl"`;
else
    ifile=`echo $ifile|sed 's/\.log$//g'`;
    ifile=`echo "$ifile.log"`;
fi

tempf=`echo $ifile|sed 's/\.\([^\ \.]\+\)$//g'`;
if [[ -z $ofile ]]; then
    ofile=$tempf;
fi

if [[ -n $ifile && -n $ofile ]]; then
    if [[ $modes == 'c' ]]; then
        ofile=`echo $ofile|sed 's/\.t[em]\.txt$\|\.txt$//g'`;
        cat "$ifile" | sed -n '/tefreqs/p' | sed 's/tefreqs:,\ //g' > "$ofile.te.txt";
        cat "$ifile" | sed -n '/tmfreqs/p' | sed 's/tmfreqs:,\ //g' > "$ofile.tm.txt";
    elif [[ $modes == 'l' ]]; then
        ofile=`echo $ofile|sed 's/\.log$//g'`;
        mpb "$ifile" > "$ofile.log";
    elif [[ $modes == 'd' ]]; then
        ofile=`echo $ofile|sed 's/\.t[em]\.txt$\|\.txt$//g'`;
        mpb "$ifile" > "$tempf.log";
        if [[ -n $tewav ]]; then
            cat "$tempf.log" | sed -n '/tefreqs/p' | sed 's/tefreqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g' > "$ofile.te.txt";
        fi
        if [[ -n $tmwav ]]; then
            cat "$tempf.log" | sed -n '/tmfreqs/p' | sed 's/tmfreqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g' > "$ofile.tm.txt";
        fi
        rm "$tempf.log";
    else
        echo "Sorry, the options seems to be invalid.";
        usage;
    fi
else
    echo "Sorry, there seems to be no input filename.";
    usage;
fi
