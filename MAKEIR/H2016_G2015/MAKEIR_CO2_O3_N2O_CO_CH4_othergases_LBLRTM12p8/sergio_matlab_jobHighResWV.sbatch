#!/bin/bash

# better to run all 5 pressure offsets using eg run_wv_all_scriptHIGHRES.sc
# run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=1-11 sergio_matlab_jobHighResWV.sbatch

#  Name of the job:
#SBATCH --job-name=RUN_WVHI_LBLRTM

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#  Specify the qos and run time (format:  dd-hh:mm:ss)
#SBATCH --qos=medium+

#### this is for 0.0025 cm-1 and for 0.0005 cm-1
#### SBATCH --time=1:59:00
#### this is for 0.0001 cm-1
#SBATCH --time=15:59:00

#  This is in MB, less aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasWV_fileHIGHRES"
  srun matlab -nodisplay -nosplash -r "clust_runXtopts_savegasWV_fileHIGHRES; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_fileHIGHRES"
  srun matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_fileHIGHRES; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_2HIGHRES"
  srun matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_2HIGHRES; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_3HIGHRES"
  srun matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_3HIGHRES; exit"
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_4HIGHRES"
  srun matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_4HIGHRES; exit"
elif [[ "$1" -eq "5" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasWV_file_5HIGHRES"
  srun matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_5HIGHRES; exit"
fi
