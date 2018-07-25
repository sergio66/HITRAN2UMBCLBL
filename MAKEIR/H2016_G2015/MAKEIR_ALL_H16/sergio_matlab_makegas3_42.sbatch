#!/bin/bash

# run this with sbatch --array=1-48%128 --output='testslurm' sergio_matlab_makegas3_42.sbatch
# run this with sbatch --array=1-48%128 sergio_matlab_makegas3_42.sbatch 
# run this with sbatch --array=1-3000%256 --output='/dev/null' sergio_matlab_makegas3_42.sbatch

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
##SBATCH --qos=medium_prod
##SBATCH --time=11:59:00 
##SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
#SBATCH --qos=short
#SBATCH --time=0:59:00 
#SBATCH --mem-per-cpu=12000

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
#matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  
