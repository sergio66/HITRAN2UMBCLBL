#!/bin/bash

# run this with sbatch --array=1-48%128 --output='testslurm' sergio_run8_makegas2.sbatch
# run this with sbatch --array=1-990%256 sergio_run8_makegas2.sbatch
# run this with sbatch --array=1-220     sergio_run8_makegas2.sbatch for FIR
# run this with sbatch --array=1-990%256 --output='/dev/null' sergio_run8_makegas2.sbatch

#  Name of the job:
#SBATCH --job-name=RUN8_gas2

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
#matlab -nodisplay -r "cluster_run8_voigtco2; exit"
matlab -nodisplay -r "cluster_test_run8_LM_voigtco2; exit"

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
##SBATCH --qos=short
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000
##matlab -nodisplay -r "cluster_run8_voigtco2; exit"
#matlab -nodisplay -r "cluster_test_run8_LM_voigtco2; exit"

