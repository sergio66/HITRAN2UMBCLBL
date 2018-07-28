#!/bin/bash

# when making the spectra for pp,Toffset 
# run this with sbatch --array=1-990%128 --output='testslurm' sergio_matlab_makegas1_103.sbatch
# run this with sbatch --array=1-990%128 sergio_matlab_makegas1_103.sbatch 
# run this with sbatch --array=1-990%256 --output='/dev/null' sergio_matlab_makegas1_103.sbatch
#
# when putting pp,Toffset together
# run this with sbatch --array=1-90 --output='/dev/null' sergio_matlab_makegas1_103.sbatch

#  Name of the job:
#SBATCH --job-name=RUN8_gas1_103

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#### clust_runXtopts_savegas1_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### slow and tedious, g1 or g110
##SBATCH --qos=medium_prod
##SBATCH --time=11:59:00 
##SBATCH --mem-per-cpu=12000

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
##matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
##matlab -nodisplay -r "clust_runXtopts_savegas103_file; exit"
##matlab -nodisplay -r "clust_runXtopts_savegas110_file; exit"

#### clust_runXtopts_savegas103_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### fast g103, or putting together the 5 pressures/11 Toffsets
#SBATCH --qos=short
#SBATCH --time=0:59:00 
#SBATCH --mem-per-cpu=12000

#matlab -nodisplay -r clust_runXtopts_mkg1vfiles; exit
matlab -nodisplay -r clust_runXtopts_mkg103vfiles; exit
## matlab -nodisplay -r clust_runXtopts_mkg110vfiles; exit
