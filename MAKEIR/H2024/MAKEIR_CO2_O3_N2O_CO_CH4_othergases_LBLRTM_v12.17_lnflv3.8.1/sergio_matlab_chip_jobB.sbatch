#!/bin/bash

# run this with /bin/rm slurm*.out; sbatch --array=1-11    sergio_matlab_chip_jobB.sbatch
# run this with /bin/rm slurm*.out; sbatch --array=1-814   sergio_matlab_chip_jobB.sbatch  for ALL gases
# run this with /bin/rm slurm*.out; sbatch --array=1-473   sergio_matlab_chip_jobB.sbatch  for ALL MOLGAS
# run this with /bin/rm slurm*.out; sbatch --array=474-814 sergio_matlab_chip_jobB.sbatch  for ALL XSCGAS

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

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_file"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file_2"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_2; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file_3"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_3; exit"
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file_4"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_4; exit"
elif [[ "$1" -eq "5" ]]; then
  echo "cmd line arg = 1, clust_runXtopts_savegasN_file_5"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -nosplash -r "clust_runXtopts_savegasN_file_5; exit"
fi
