#!/bin/bash

## see /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12/run_big_script.sc

/bin/rm slurm*.out

dovers=1
dovers=2

if [ $dovers -eq 1 ]
then
  echo 'version 1 : politely waiting using singleton'
  sbatch --array=1-990%512              sergio_lm_makegas2.sbatch 1
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 2
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 3
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 4
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 5
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 6
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 7
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 8
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 9
  sbatch --array=1-990%512 -d singleton sergio_lm_makegas2.sbatch 10
elif [ $dovers -eq 2 ]
then
  llmin=1
  llmax=10

  llmin=9
  llmax=9
  
  ll=$(expr $llmin)
  
  echo 'version 2 : why worry be happy? just dump them all and go relax'
  while test $ll -le $llmax
  do
    echo $ll
###### need to edit this correctly to select him many you are running      
#    sbatch --array=1-990%512 sergio_lm_makegas2.sbatch $ll
#    sbatch --array=1-64 sergio_lm_makegas2.sbatch $ll
    sbatch --array=1 sergio_lm_makegas2.sbatch $ll
###### need to edit this correctly to select him many you are running          
    #ll=`expr $ll + 1`
    ll=$(expr $ll + 1)
  done
else
  echo 'run_lm.sc  ...incorrect version'
fi