#!/bin/bash

# when making the spectra for pp,Toffset 
# run this with sbatch --array=1-143%128 --output='testslurm' sergio_matlab_makegas1_103_110.sbatch
# run this with sbatch --array=1-143%256 --output='/dev/null' sergio_matlab_makegas1_103_110.sbatch
# run this with sbatch --array=1-143%128 sergio_matlab_makegas1_103_110.sbatch 1   for gid 1
# run this with sbatch --array=1-143%128 sergio_matlab_makegas1_103_110.sbatch 2   for gid 103
# run this with sbatch --array=1-143%128 sergio_matlab_makegas1_103_110.sbatch 3   for gid 110
#
# when putting pp,Toffset together
# run this with sbatch --array=1-61  sergio_matlab_makegas1_103_110.sbatch 4  for gid 1
# run this with sbatch --array=1-61  sergio_matlab_makegas1_103_110.sbatch 5  for gid 103
# run this with sbatch --array=1-61  sergio_matlab_makegas1_103_110.sbatch 6  for gid 110

#  Name of the job:
#SBATCH --job-name=RUN8_gas1_103_110

#  N specifies that 1 job step is to be allocated per instance of #matlab
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
#SBATCH --qos=medium+
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_savegas103_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### fast g103, or putting together the 5 pressures/11 Toffsets
##SBATCH --qos=short+
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
  matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savegas103_file; exit"
elif [[ "$1" -eq "3" ]]; then
  matlab -nodisplay -r "clust_runXtopts_savegas110_file; exit"
elif [[ "$1" -eq "4" ]]; then
  matlab -nodisplay -r "clust_runXtopts_mkg1vfiles; exit"
elif [[ "$1" -eq "5" ]]; then
  matlab -nodisplay -r "clust_runXtopts_mkg103vfiles; exit"
elif [[ "$1" -eq "6" ]]; then
  matlab -nodisplay -r "clust_runXtopts_mkg110vfiles; exit"
fi

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
## matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
## matlab -nodisplay -r "clust_runXtopts_savegas103_file; exit"
## matlab -nodisplay -r "clust_runXtopts_savegas110_file; exit"

## matlab -nodisplay -r clust_runXtopts_mkg1vfiles; exit
## matlab -nodisplay -r clust_runXtopts_mkg103vfiles; exit
#matlab -nodisplay -r clust_runXtopts_mkg110vfiles; exit
