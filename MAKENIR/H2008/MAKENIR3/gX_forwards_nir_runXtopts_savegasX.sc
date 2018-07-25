## call with gX_forwards_nir_runXtopts_savegasX.sc gid startchunk
/bin/rm gidfname
gid=$1
chunk=$2
echo "doing gid chunk " $gid $chunk
echo $gid $chunk > gidfname
/usr/local/bin/matlabR2006b -nojvm -nodisplay -nodesktop < /home/sergio/abscmp/MAKENIR3/gX_forwards_nir_runXtopts_savegasX.m > /airs/s1/sergio/logfile 2>&1  &
