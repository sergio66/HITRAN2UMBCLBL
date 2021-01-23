#!/bin/bash

# this asks for MEDIUM queue, so ideal for making ODs
# when making the ODs
# run this with sbatch --array=1-12000%128 --output='testslurm' sergio_matlab_makegas3_42.sbatch
# run this with sbatch --array=1-12000%128 sergio_matlab_makegas3_42.sbatch 
# run this with sbatch --array=1-12000%256 --output='/dev/null' sergio_matlab_makegas3_42.sbatch
#
# when putting them together
# run this with sbatch --array=3-42 sergio_matlab_makegas3_42.sbatch 2 

#  Name of the job:
#SBATCH --job-name=RUN8_gas3_42

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#### clust_runXtopts_savegasN_file : actually does the whole /home/sergio/SPECTRA/run8 shebang, slow and tedious
#SBATCH --qos=medium+
#SBATCH --time=11:59:00 
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
##SBATCH --qos=short
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##  Specify the job array (format:  start-stop:step)
## DO NOT USE srun matlab -nodisplay -r "clust_do_kcarta_driver; exit"   but instead matlab -nodisplay -r "clust_do_kcarta_driver; exit"

if [[ "$1" -eq "" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"
fi

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
#matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
#matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  
