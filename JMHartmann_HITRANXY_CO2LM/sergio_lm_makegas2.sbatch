#!/bin/bash

# run this with sbatch --array=1-48%128 --output='testslurm' sergio_lm_makegas2.sbatch
# run this with sbatch --array=1-990%256 sergio_lm_makegas2.sbatch 
# run this with sbatch --array=1-990%256 --output='/dev/null' sergio_lm_makegas2.sbatch

#  Name of the job:
#SBATCH --job-name=LM_gas2

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#### clust_runXtopts_savegasN_file : 15 um can be quite slow, lots of bands,slow and tedious
#SBATCH --qos=medium_prod
#SBATCH --time=11:59:00 
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
##SBATCH --qos=short
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000

####### calling srun twice for these paralel jobs might be asking for too much overhead
#matlab -nodisplay -r "cluster_run_lm; exit"
matlab -nodisplay -r "cluster_run_lm_5ptboxcar; exit"
#matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  
