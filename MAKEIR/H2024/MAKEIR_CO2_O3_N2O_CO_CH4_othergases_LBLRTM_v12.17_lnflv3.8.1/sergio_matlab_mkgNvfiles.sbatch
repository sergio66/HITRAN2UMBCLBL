#!/bin/bash

# run this with
#  /bin/rm slurm*.out; sbatch --array=1-63 sergio_matlab_mkgNvfiles.sbatch
#  /bin/rm slurm*.out; sbatch --array=1-81 sergio_matlab_mkgNvfiles.sbatch

#  Name of the job:
#SBATCH --job-name=RUN_GATHER_LBLRTM

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
#SBATCH --qos=short

#SBATCH --time=0:59:00

#  This is in MB, less aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000
##  This is in MB, very aggressive but I have been running outta memory
###SBATCH --mem-per-cpu=24000

#  Specify the job array (format:  start-stop:step)
srun matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"
