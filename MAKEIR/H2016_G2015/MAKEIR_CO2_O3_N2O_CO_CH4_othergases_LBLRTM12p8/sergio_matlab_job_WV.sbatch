#!/bin/bash

# run this with /bin/rm slurm*.out; sbatch --array=1-11 sergio_matlab_jobB_WV.sbatch 

#  Name of the job:
#SBATCH --job-name=RUN_WV_LBLRTM

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
#SBATCH --qos=medium

#SBATCH --time=7:59:00
##SBATCH --time=11:59:00
##SBATCH --time=14:59:00 

#  This is in MB, less aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000
##  This is in MB, very aggressive but I have been running outta memory
###SBATCH --mem-per-cpu=24000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##### ORIG Specify the job array (format:  start-stop:step)
##### ORIG srun matlab -nodisplay -r "clust_runXtopts_savegasWV_file; exit"

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasWV_file"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_2"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_2; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_3"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_3; exit"
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_4"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_4; exit"
elif [[ "$1" -eq "5" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_5"
  srun matlab -nojvm -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_5; exit"
fi
