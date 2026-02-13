#!/bin/bash

# when making the spectra for pp,Toffset 
# run this with sbatch --array=1-990%256 --output='testslurm' sergio_matlab_makegas1_103_110.sbatch 1,2 or 3
# run this with sbatch --array=1-990%256                      sergio_matlab_makegas1_103_110.sbatch 1,2 or 3
#
# when putting pp,Toffset together
# run this with sbatch --array=1-90 --output='/dev/null' sergio_matlab_makegas1_103_110.sbatch 4,5 or 6
# run this with sbatch --array=1-90                      sergio_matlab_makegas1_103_110.sbatch 4,5 or 6

#  Name of the job:
#SBATCH --job-name=RUN8_gas1_103

#  N specifies that 1 job step is to be allocated per instance of #matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#### clust_runXtopts_savegas1_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### slow and tedious, g1 or g110
#SBATCH --qos=medium_prod
#SBATCH --time=11:59:00 
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_savegas103_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### fast g103, or putting together the 5 pressures/11 Toffsets
##SBATCH --qos=short
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"  
if [[ "$1" -eq "" ]]; then
  # this is default, make the spectral individually into gX.dat
  echo "no cmd line args, doing individual chunks for g1"
  matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is default, make the spectral individually into gX.dat
  echo "cmd line arg = 1  doing individual chunks for g1"
  matlab -nodisplay -r "clust_runXtopts_savegas1_file; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 2  doing individual chunks for g103"
  matlab -nodisplay -r "clust_runXtopts_savegas103_file; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 3  doing individual chunks for g110"
  matlab -nodisplay -r "clust_runXtopts_savegas110_file; exit"
elif [[ "$1" -eq "4" ]]; then
   echo "cmd line arg = 4  putting together Toffsets for g1"
  matlab -nodisplay -r clust_runXtopts_mkg1vfiles; exit
elif [[ "$1" -eq "5" ]]; then
   echo "cmd line arg = 4  putting together Toffsets for g103"
  matlab -nodisplay -r clust_runXtopts_mkg103vfiles; exit
elif [[ "$1" -eq "6" ]]; then
   echo "cmd line arg = 4  putting together Toffsets for g110"
  matlab -nodisplay -r clust_runXtopts_mkg110vfiles; exit
fi
