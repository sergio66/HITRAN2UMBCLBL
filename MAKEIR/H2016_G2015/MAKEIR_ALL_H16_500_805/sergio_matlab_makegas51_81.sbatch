#!/bin/bash

# when making the ODs
# run this with sbatch --array=1-10824%128 --output='testslurm' sergio_matlab_makegas51_81.sbatch 1
# run this with sbatch --array=1-10824%128 sergio_matlab_makegas51_81.sbatch 1
# run this with sbatch --array=1-10824%256 --output='/dev/null' sergio_matlab_makegas51_81.sbatch 1
#
# run this with sbatch --array=51-81 sergio_matlab_makegas51_81.sbatch 2 

#  Name of the job:
#SBATCH --job-name=RUN8_gas51_81

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#### clust_runXtopts_savegasN_file : actually does the whole /home/sergio/SPECTRA/run8 shebang, slow and tedious
##SBATCH --qos=medium+
##SBATCH --time=11:59:00 
##SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
#SBATCH --qos=short+
#SBATCH --time=0:59:00 
#SBATCH --mem-per-cpu=12000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

if [[ "$1" -eq "" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savexsecN_file; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savexsecN_file; exit"
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "clust_runXtopts_mkxsecNvfiles; exit"
fi

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
#matlab -nodisplay -r "clust_runXtopts_savexsecN_file; exit"
#matlab -nodisplay -r "clust_runXtopts_mkxsecNvfiles; exit"  
