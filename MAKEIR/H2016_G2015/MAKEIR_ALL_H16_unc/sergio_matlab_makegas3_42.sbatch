#!/bin/bash

# run this with sbatch --array=1-4004%128 --output='testslurm' sergio_matlab_makegas3_42.sbatch
# run this with sbatch --array=1-4004%128 sergio_matlab_makegas3_42.sbatch 
# run this with sbatch --array=1-4004%256 --output='/dev/null' sergio_matlab_makegas3_42.sbatch
#
# or when putting together the T offsets
# run this with sbatch --array=1-12 --output='/dev/null' sergio_matlab_makegas3_42.sbatch

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
##SBATCH --time=11:59:00
##SBATCH --time=15:59:00
#SBATCH --time=1:59:00 
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
##SBATCH --qos=short+
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000

####### calling srun twice for these paralel jobs might be asking for too much overhead
matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"

####### this one you just need JOBS 3,4,5,6,9 (probably not 12)
####### so do eg sbatch --array=3-9 sergio_matlab_makegas3_42.sbatch
#matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  
