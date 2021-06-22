#!/bin/bash

# for clust_runXtopts_savegasN_fileHIGHRES.m
# for CO2 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=01-11 sergio_matlab_jobLowRes.sbatch 1
# for  O3 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=12-22 sergio_matlab_jobLowRes.sbatch 1
# for CH4 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=23-33 sergio_matlab_jobLowRes.sbatch 1
#
# for clust_runXtopts_savegasN_fileHIGHRES_backwards.m with no options (so Toff_run_offset = 4, wnoffset = 0)
# for CO2 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=01-11 sergio_matlab_jobLowRes.sbatch 2
# for  O3 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=12-22 sergio_matlab_jobLowRes.sbatch 2
# for CH4 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=23-33 sergio_matlab_jobLowRes.sbatch 2
#
# for clust_runXtopts_savegasN_fileHIGHRES_backwards.m with options (Toff_run_offset = 1, wnoffset = 200)
# for CO2 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=01-11 sergio_matlab_jobLowRes.sbatch 3
# for  O3 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=12-22 sergio_matlab_jobLowRes.sbatch 3
# for CH4 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=23-33 sergio_matlab_jobLowRes.sbatch 3
#
# for clust_runXtopts_savegasN_fileHIGHRES_backwards.m with options (Toff_run_offset = 2, wnoffset = 400)
# for CO2 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=01-11 sergio_matlab_jobLowRes.sbatch 4
# for  O3 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=12-22 sergio_matlab_jobLowRes.sbatch 4
# for CH4 run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,225,260,267] --array=23-33 sergio_matlab_jobLowRes.sbatch 4

#  Name of the job:
#SBATCH --job-name=RUN_LBLRTM

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch

#  Specify the qos and run time (format:  dd-hh:mm:ss)
#SBATCH --qos=medium+

#### this is for 0.0025 cm-1 and for 0.0005 cm-1
#### SBATCH --time=1:59:00
#### this is for 0.0001 cm-1
#SBATCH --time=15:59:00

#  This is in MB, less aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000

#  Specify the job array (format:  start-stop:step)
if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_fileLOWRES"
  srun matlab -nodisplay -r "clust_runXtopts_savegasN_fileLOWRES; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_fileLOWRES"
  srun matlab -nodisplay -r "clust_runXtopts_savegasN_fileLOWRES; exit"
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_fileLOWRES"
  srun matlab -nodisplay -r "clust_runXtopts_savegasN_fileLOWRES_backwards; exit"
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_fileLOWRES"
  srun matlab -nodisplay -r "Toff_run_offset = 1; wnoffset = 200; clust_runXtopts_savegasN_fileLOWRES_backwards; exit"
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = DNE, clust_runXtopts_savegasN_fileLOWRES"
  srun matlab -nodisplay -r "Toff_run_offset = 2; wnoffset = 400; clust_runXtopts_savegasN_fileLOWRES_backwards; exit"
fi

