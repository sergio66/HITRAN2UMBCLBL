#!/bin/bash

# run this with /bin/rm slurm*.out; sbatch --array=1-11    sergio_matlab_chip_jobB.sbatch
# run this with /bin/rm slurm*.out; sbatch --array=1-814   sergio_matlab_chip_jobB.sbatch  for ALL gases
# run this with /bin/rm slurm*.out; sbatch --array=1-473   sergio_matlab_chip_jobB.sbatch  for ALL MOLGAS
# run this with /bin/rm slurm*.out; sbatch --array=474-814 sergio_matlab_chip_jobB.sbatch  for ALL XSCGAS

# run this with /bin/rm slurm*.out; sbatch --array=1-11    sergio_matlab_chip_jobB.sbatch 1-5   for CO2/CH4  : see run_2_6.sc
# run this with /bin/rm slurm*.out; sbatch --array=1-11    sergio_matlab_chip_jobB.sbatch 6-10  for WV
# run this with /bin/rm slurm*.out; sbatch --array=1-11    sergio_matlab_chip_jobB.sbatch 11-12 for N2/O2    : see run_7_22.sc

# The Golden Rule is
# ************************************************************************
# *        Since LBLRTM only runs using TAPE5,TAPE6,TAPE11,TAPE12        *
# *  you CANNOT CANNOT have more than one job running on same processor  *
# *  at the same time, else they will start overwriting each other.      *
# ************************************************************************

########################################################################

#SBATCH --job-name=RUN_LBLRTM             # Name of the job:
#SBATCH --requeue                         # requeue; if held type scontrol release JOBID
#SBATCH -N1                               # N specifies that 1 job step is to be allocated per instance of #matlab
#SBATCH --cpus-per-task 1                 # specifies number of cores per matlab session available for parallel jobs
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

#### use SBATCH --mem instead of SBATCH --mem-per-cpu
#### use SBATCH --mem instead of SBATCH --mem-per-cpu
#### use SBATCH --mem instead of SBATCH --mem-per-cpu

##SBATCH --time=11:59:00
##SBATCH --time=14:59:00 
#### clust_runXtopts_savegasN_file,clust_runXtopts_savegasN_file_11T :
#### SLOW : does the whole /home/sergio/SPECTRA/run8 shebang,
#### slow and tedious, g1 or g110
#SBATCH --time=7:59:00
#SBATCH --mem-per-cpu=12000

#### clust_runXtopts_mkgNvfiles : FAST : puts the 11 T poffsets together into /abs.dat
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

## dont use /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab, use matlab

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_file"
  matlab -nodisplay -nosplash -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 2, clust_runXtopts_savegasN_file_2"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_2; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 3, clust_runXtopts_savegasN_file_3"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_3; exit"
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = 4, clust_runXtopts_savegasN_file_4"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_4; exit"
elif [[ "$1" -eq "5" ]]; then
  echo "cmd line arg = 5, clust_runXtopts_savegasN_file_5"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_5; exit"
#  
elif [[ "$1" -eq "6" ]]; then
  echo "cmd line arg = 6, clust_runXtopts_savegasWV_file"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file; exit"
elif [[ "$1" -eq "7" ]]; then
  echo "cmd line arg = 7, clust_runXtopts_savegasWV_file_2"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_2; exit"
elif [[ "$1" -eq "8" ]]; then
  echo "cmd line arg = 8, clust_runXtopts_savegasWV_file_3"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_3; exit"
elif [[ "$1" -eq "9" ]]; then
  echo "cmd line arg = 9, clust_runXtopts_savegasWV_file_4"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_4; exit"
elif [[ "$1" -eq "10" ]]; then
  echo "cmd line arg = 10, clust_runXtopts_savegasWV_file_5"
  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasWV_file_5; exit"
#  
#elif [[ "$1" -eq "11" ]]; then
#  echo "cmd line arg = 11, clust_runXtopts_savegasN_file_N2O2"
#  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_N2O2only; exit"
#elif [[ "$1" -eq "12" ]]; then
#  echo "cmd line arg = 12, clust_runXtopts_savegasN_file_N2O2_2"
#  matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_N2O2only_2; exit"
elif [[ "$1" -eq "11" ]]; then
  echo "cmd line arg = 11, new_clust_runXtopts_savegasN_file_N2only"
  matlab  -nodisplay -nosplash -r "new_clust_runXtopts_savegasN_file_N2only; exit"
elif [[ "$1" -eq "12" ]]; then
  echo "cmd line arg = 12, clust_runXtopts_savegasN_file_O2only"
  matlab  -nodisplay -nosplash -r "new_clust_runXtopts_savegasN_file_O2only; exit"
fi
