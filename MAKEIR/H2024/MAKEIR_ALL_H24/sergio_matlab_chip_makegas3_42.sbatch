#!/bin/bash

# to make the individual chunks/gases into eg /asl/s1/sergio/H2022_RUN8_NIRDATABASE/IR_605_2830/gX.dat, run this with
# (remember can only do 20000 so then have to do 5000 more by eventually running loop_filelist_gN_missing.m)
#   run this with   sbatch --array=1-20000%512 --output='/dev/null' sergio_matlab_chip_makegas3_42.sbatch    BEST since making slurm files kills disks, ls
#   run this with   sbatch --array=1-20000%512 --output='testslurm' sergio_matlab_chip_makegas3_42.sbatch    might be ok but ignore this option
#   run this with   sbatch --array=1-20000%512                      sergio_matlab_chip_makegas3_42.sbatch    KILLS the cluster writing slurm_JOBIS_pid.out
#
#   run this with   sbatch --array=1-N --exclude c24-13  sergio_matlab_chip_makegas3_42.sbatch 2   to run an individual gas, individual chunk, loop over 11 T
#   
# to put the Toffset chunks together before compression into /asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/abs.dat, run this with
#   sbatch --array=1-42 sergio_matlab_chip_makegas3_42.sbatch 3

########################################################################

#  Name of the job:
#SBATCH --job-name=RUN8_gas3_42

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of #matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#SBATCH --account=pi_strow

#SBATCH --cluster=chip-cpu

########################################################################

#### we run on 2024 but run risk of someone pre-empting
#SBATCH --qos=shared
#SBATCH --partition=2024

#### to make sure we have exclusive privilege
##SBATCH --qos=pi_strow
##SBATCH --partition=pi_strow

########################################################################

#### clust_runXtopts_savegas1_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### slow and tedious, g1 or g110
#SBATCH --time=11:59:00 
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_savegas103_file : actually does the whole /home/sergio/SPECTRA/run8 shebang,
#### fast g103, or putting together the 5 pressures/11 Toffsets
##SBATCH --time=0:59:00 
##SBATCH --mem-per-cpu=12000


########################################################################

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

####### calling srun twice for these paralel jobs might be asking for too much overhead
####### srun matlab -nodisplay -r "clustbatch_random_allfovV1; exit"
if [[ "$1" -eq "" ]]; then
  # this is default, make the spectral individually into gX.dat
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_file"
  matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is default, make the spectral individually into gX.dat
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file"
  matlab -nodisplay -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "2" ]]; then
  # this is default, make the spectral individually into gX.dat looping over 11 T
  echo "cmd line arg = 2, clust_runXtopts_savegasN_file_11T"
  matlab -nodisplay -r "clust_runXtopts_savegasN_file_11T; exit"  
elif [[ "$1" -eq "3" ]]; then
  # this is default, put together the spectra into abs.dat
  echo "cmd line arg = 3, clust_runXtopts_mkgNvfiles"
  matlab -nodisplay -r "clust_runXtopts_mkgNvfiles; exit"  
fi
