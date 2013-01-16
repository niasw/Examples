#!/bin/bash
#
#  description: a script to run mpb calculation
#  Usage:
#      dompb	-i INPUT [-o OUTPUT] [-{d|l|c}] [-p PARITY]
#  Options:
#	-i INPUT	specify INPUT  file
#	-o OUTPUT	specify OUTPUT file
#  	-d		output data (default) 	INPUT:ctl 	OUTPUT:txt
#  	-l		log the mpb output	INPUT:ctl 	OUTPUT:log
#  	-c		convert mpb output	INPUT:log 	OUTPUT:txt
#  	-p PARITY	specified PARITY	  OUTPUT:txt->PARITY.txt
#	   (only output modes with this specified PARITY.
#	   (eg. PARITY=""
#	   (	  then output all modes
#	   (	PARITY="te"
#	   (	  then output all TE modes
#	   (	  (i.e. "zeven" in xy-2D system)
#	   (	PARITY="tm"
#	   (	  then output all TM modes;
#	   (	  (i.e. "zodd"  in xy-2D system)
#	   (	PARITY="zeven"
#	   (	  then output all modes in even parity of z-axis
#	   (	PARITY="yeven"
#	   (	  then output all modes in even parity of y-axis
#	   (	PARITY="te-yeven"
#	   (	  then output TE modes
#	   (	  in even parity of y-axis (xy-2D sys)
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
    echo "  description: a script to run mpb calculation";
    echo "  Usage:";
    echo "  \tdompb\t-i INPUT [-o OUTPUT] [-{d|l|c}] [-p PARITY]";
    echo "  Options:";
    echo "\t-i INPUT\tspecify INPUT  file";
    echo "\t-o OUTPUT\tspecify OUTPUT file";
    echo "  \t-d\t\toutput data (default) \tINPUT:ctl \tOUTPUT:txt";
    echo "  \t-l\t\tlog the mpb output\tINPUT:ctl \tOUTPUT:log";
    echo "  \t-c\t\tconvert mpb output\tINPUT:log \tOUTPUT:txt";
    echo "  \t-p PARITY\tspecified PARITY\t  OUTPUT:txt->PARITY.txt";
    echo "\t   (only output modes with this specified PARITY.";
    echo "\t   (eg. PARITY=""";
    echo "\t   (\t  then output all modes";
    echo "\t   (\tPARITY="te"";
    echo "\t   (\t  then output all TE modes";
    echo "\t   (\t  (i.e. "zeven" in xy-2D system)";
    echo "\t   (\tPARITY="tm"";
    echo "\t   (\t  then output all TM modes;";
    echo "\t   (\t  (i.e. "zodd"  in xy-2D system)";
    echo "\t   (\tPARITY="zeven"";
    echo "\t   (\t  then output all modes in even parity of z-axis";
    echo "\t   (\tPARITY="yeven"";
    echo "\t   (\t  then output all modes in even parity of y-axis";
    echo "\t   (\tPARITY="teyeven"";
    echo "\t   (\t  then output TE modes";
    echo "\t   (\t  in even parity of y-axis (xy-2D sys)";
}

ifile='';
ofile='';
modes='d';
parit='';
tempf='';

while getopts "i:o:dlcp:" option
do
    case $option in
        i   )   ifile=$OPTARG;;
        o   )   ofile=$OPTARG;;
        d   )   ;;
        l   )   modes='l';;
        c   )   modes='c';;
        p   )   parit=$OPTARG;;
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
        if [[ -n $parit ]]; then
            cat "$ifile" | sed -n '/freqs/p' | sed -n "/$parit/p" | sed "s/^.*freqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g" > "$ofile.$parit.txt";
        else
            cat "$ifile" | sed -n '/freqs/p' | sed 's/freqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g' > "$ofile.txt";
        fi
    elif [[ $modes == 'l' ]]; then
        ofile=`echo $ofile|sed 's/\.log$//g'`;
        mpb "$ifile" > "$ofile.log";
    elif [[ $modes == 'd' ]]; then
        ofile=`echo $ofile|sed 's/\.t[em]\.txt$\|\.txt$//g'`;
        mpb "$ifile" > "$tempf.log";
        if [[ -n $parit ]]; then
            cat "$tempf.log" | sed -n '/freqs/p' | sed -n "/$parit/p" | sed "s/^.*freqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g" > "$ofile.$parit.txt";
        else
            cat "$tempf.log" | sed -n '/freqs/p' | sed 's/freqs:,\ //g;s/\/2pi/_bar/g;s/,\ /\t/g;s/\ /_/g' > "$ofile.txt";
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
