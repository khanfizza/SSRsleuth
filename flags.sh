#!/bin/bash

#Usage
usage(){
    echo "Pipeline to detect presence of microsatellites in organisms"
    echo "Usage: ./main.sh [-r READS] [-t THREADS] [-o OUTDIR]"
    echo ""
    echo "Options:"
    echo "  -r | --reads FILENAME 	Input FASTA file, can be either genome or gene file"
    echo "  -t | --threads NUM 		Number of threads (default: 1)"
    echo "  -o | --output FILENAME 	Location of output directory"
    echo "  -h | --help 			Display this help message"
    echo "" 
}

#Default values
#arg_r = ""
#arg_t = ""
#arg_o = ""

#Parse options
while getopts "r:t:o:h" opt; do
  case ${opt} in
    r | --reads) 
      arg_r=${OPTARG}
      echo "Reads are $arg_r"
      ;;
    t | --threads)
      arg_t=${OPTARG}
      echo "Threads are $arg_t"
      ;;
    o | --output)
     arg_o=${OPTARG}
     echo "Output will be written to $arg_o"
     ;;
    \?)
     echo "Invalid option: -$OPTARG"
     usage
     exit 1
     ;;
  esac
done

#Check for mandatory flags
if [[ -z $arg_r ]]; then
 echo "An input FASTA file is required."
 usage
 exit 1
fi

if [[ -z $arg_o ]]; then
 echo "An output directory needs to be specified."
 usage
 exit 1
fi

#Params
reads=${arg_r}
out=${arg_o}
core=${arg_t}

if [[ -z $core ]] 
then
 core=1
fi

#Message if no arguments provided
if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi


