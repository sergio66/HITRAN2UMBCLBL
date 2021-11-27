#!/bin/bash

# run this with      kleenslurm; sbatch --array=3-81 sergio_matlab_cmprun.sbatch 1    for umbc
#   separately in interactive Matlab session do cmprunIR_WV_H20([1 103],605:25:2805)
#   separately also make sure you do CO2
#
# run this with      kleenslurm; sbatch --array=2-63 sergio_matlab_cmprun.sbatch 2    for lblrtm 

#  Name of the job:
#SBATCH --job-name=RUN_CMPRUN

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch
##SBATCH --partition=strow

#  Specify the qos and run time (format:  dd-hh:mm:ss)
#SBATCH --qos=short

#SBATCH --time=0:59:00

#  This is in MB, less aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000
##  This is in MB, very aggressive but I have been running outta memory
###SBATCH --mem-per-cpu=24000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

#  Specify the job array (format:  start-stop:step)
if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, generic run"
  srun matlab -nodisplay -r "clust_cmprunIR_UMBC_all; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, generic run"
  srun matlab -nodisplay -r "clust_cmprunIR_UMBC_all; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 2, lblrtm run"
  srun matlab -nodisplay -r "clust_cmprunIR_LBLRTM_all; exit"
fi
