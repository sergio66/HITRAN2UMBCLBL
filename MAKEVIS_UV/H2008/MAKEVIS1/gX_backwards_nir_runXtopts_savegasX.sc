/bin/rm gidfname
gid=$1
echo "doing gid" $gid
echo $gid > gidfname
/usr/local/bin/matlabR2006b -nojvm -nodisplay -nodesktop < /home/sergio/abscmp/MAKEVIS1/gX_backwards_nir_runXtopts_savegasX.m > /airs/s1/sergio/logfile 2>&1  &
