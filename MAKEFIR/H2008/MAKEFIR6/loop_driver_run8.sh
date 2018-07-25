#!/bin/bash
#
# This script runs the matlab ecmwf processing. the UMBC hpc cluster.  
#   Paul Schou, 24-Oct-2008
#
#  clustcmd      loop_driver.sh filelist_2010.txt ## default, dies after 16 hrs
#                                                 ## spawns 16 processes
#  clustcmd -n 8 loop_driver.sh filelist_2010.txt ## spawns 8 processes, 
#                                                 ## dies after 16 hours
####  clustcmd -l log -n 8 loop_driver.sh filelist_2010.txt  
####  clustcmd -n 20 -w 96:00:00 loop_driver_rates.sh filelist_hpc
#  spawns 8 processes, 
#  clustcmd -q high_priority -n 8 -w 96:00:00 loop_driver.sh filelist_2010.txt
#    q - which que to use, high_priority is restricted to research groups only
#    n - number of nodes to use
#    w - wall time to allocated, hh:mm:ss, in this case it is 96 hours
#
# after starting a job, do the following to see the progress
#   qstat -a    or qstat -n
# 
# can also individually hope onto eg ssh node033 and do "top" to see how things
# are progressing
#
# to kill everything that is running, use killallnodes 
#   on /strowdata1/shared/sergio/MATLABCODE/CRODGERS/DustTzQzCz_ECMWF/';
#
# if something is still not started in the queue, log onto hpc and then do eg qdel 24551
#
# filelist = 1 .. 12

workfile=$1;
workdir='/home/sergio/HITRAN2UMBCLBL/MAKEFIR6/';

cd $workdir

###del mkdir logs 2> /dev/null
###del logfile=logs/$bn.log
###del logger=">> $logfile";
###del echo "Cluster job started at `date` on `hostname`" > $logfile

default="hpcfname='$workfile';cd('$workdir');"
echo $default

echo "Running Matlab `which matlab`"

## this puts out a huge log file
/asl/opt/bin/matlab -nodisplay -nodesktop -nosplash -r "$default; gX_forwards_nir_runXtopts_savegasX; exit;" $logger

## this is much quieter
#/asl/opt/bin/matlab -nodisplay -nodesktop -nosplash -r "$default; driver_co2_hpc; exit;" > /dev/null

