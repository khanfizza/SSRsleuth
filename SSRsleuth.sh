#!/bin/bash

set -e 
set -o pipefail

#Location of scripts
perlScript=./bin

Red=`tput setaf 1`
Green=`tput setaf 2`
Reset=`tput sgr0`

# location to getopts.sh file
source ./bin/uniq.py
source ./bin/flags.sh

#USAGE="-r READS -t THREAD -o OUTDIR [-a START_DATE_TIME]"
#parse_options "${USAGE}" ${@}

#echo "${Green}--:LOCATIONS and FLAGS:--${Reset}"
#echo "${Green}THREAD used:${Reset} ${THREAD}"
#echo "${Green}OUTDIR used:${Reset} ${OUTDIR}"
#echo "${Green}READS location :${Reset} ${READS}"

#Parameters accepted -- write absolute path of the BAM file
#core=${THREAD}
#reads=${READS}
#out=${OUTDIR}

(
#Set time
start_time="$(date +%s)"

  IFS=, VER=(${reads##,-})
  fasta=${VER[0]}
  echo $fasta #FASTA file will be the input

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Running SSRMMD on $fasta"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 SSRMMD.pl -p 0 -f1 $fasta -o $out/ -e 0 -mo 1=10,2=5,3=4,4=3,5=2,6=2 \
 -n 10 -x 1000 -l 100 -ss 1 -me LD -ms 0 -d 0.05 -a 1


echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Running IMEX"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 imex_batch $fasta 1 1 1 2 2 3 10 10 10 10 10 10 10 5 4 3 2 2 10 1 1 0 10 3 0
 rsync -av --delete IMEx_OUTPUT $out/

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Running PERF"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 PERF -i $fasta -o $out/perf_out -m 2 -M 12 -u ./data/params.tsv -a -t $core

#echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
#echo "running GMATA"
#echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
#cd GMATA/
#gmat.pl -i $fasta -r 10 -m 1 -x 1 -s 1 | gmat.pl -i $fasta -r 5 -m 2 -x 2 -s 1 \
#| gmat.pl -i $fasta -r 4 -m 3 -x 5 -s 1 | gmat.pl -i $fasta -r 3 -m 4 -x  -s 1 | gmat.pl -i $fasta -r 2 -m 5 -x 6 -s 1 

) 2>&1 | tee -a $out/logfile.txt

stop_time="$(expr "$(date +%s)" - $start_time)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Pipeline completed successfully!"
printf "Total runtime: %.0f hours " "$(printf "$(expr $stop_time / 3600)")"
printf "%.0f minutes " "$(printf "$(expr $stop_time / 60 % 60)")"
printf "%.0f seconds\n" "$(printf "$(expr $stop_time % 60)")"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


