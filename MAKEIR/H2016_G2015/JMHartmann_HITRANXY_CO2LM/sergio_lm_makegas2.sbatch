#!/bin/bash

# see run_lm.sc
# see run_lm.sc
# see run_lm.sc

# run this with sbatch --array=1-48%128 --output='testslurm' sergio_lm_makegas2.sbatch INTEGER ARGUMENT 1-10 for LAYER BLOCK
# run this with sbatch --array=1-990%512 sergio_lm_makegas2.sbatch INTEGER ARGUMENT 1-10 for LAYER BLOCK
# run this with sbatch --array=1-990%256 --output='/dev/null' sergio_lm_makegas2.sbatch INTEGER ARGUMENT 1-10 for LAYER BLOCK

#  Name of the job:
#SBATCH --job-name=LM_gas2

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
###SBATCH --partition=batch
#SBATCH --partition=high_mem

#### clust_runXtopts_mkgNvfiles : puts together the Toffset files so you can start compressing, pretty fast
##SBATCH --qos=short
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000
##matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  

#########################

#### clust_runXtopts_savegasN_file : 15 um can be quite slow, lots of bands,slow and tedious
#SBATCH --qos=medium_prod
#SBATCH --time=15:59:00 
#SBATCH --mem-per-cpu=12000
##matlab -nodisplay -r "laychunk=01; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=02; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=03; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=04; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=05; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=06; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=07; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=08; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=09; cluster_run_lm_5ptboxcar_laychunk; exit"
##matlab -nodisplay -r "laychunk=10; cluster_run_lm_5ptboxcar_laychunk; exit"
matlab -nodisplay -r "laychunk=$1; cluster_run_lm_5ptboxcar_laychunk; exit"

#### clust_runXtopts_savegasN_file : 15 um can be quite slow, lots of bands,slow and tedious
##SBATCH --qos=long_contrib
##SBATCH --time=4-23:59:00 
##SBATCH --mem-per-cpu=12000
##matlab -nodisplay -r "cluster_run_lm_5ptboxcar; exit"

