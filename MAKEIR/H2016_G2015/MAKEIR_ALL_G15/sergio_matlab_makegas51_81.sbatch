#!/bin/bash

# run this with sbatch --array=1-48%128 --output='testslurm' sergio_matlab_makegas51_81.sbatch
# run this with sbatch --array=1-48%128 sergio_matlab_makegas51_81.sbatch 
# run this with sbatch --array=1-8074%256 --output='/dev/null' sergio_matlab_makegas51_81.sbatch   << make sure /dev/null for over 3000 jobs

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
##SBATCH --qos=medium_prod
##SBATCH --time=11:59:00 
##SBATCH --mem-per-cpu=12000
#matlab -nodisplay -r "clust_runXtopts_savexsecN_file; exit"

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
#SBATCH --qos=short
#SBATCH --time=0:59:00 
#SBATCH --mem-per-cpu=12000
matlab -nodisplay -r "clust_runXtopts_mkxsecNvfiles; exit"



