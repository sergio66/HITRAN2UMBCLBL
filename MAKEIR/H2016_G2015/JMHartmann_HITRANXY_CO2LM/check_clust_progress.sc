# /bin/rm slurm*

echo "total running processes"
squeue -u sergio -t R | wc -l

echo "total delayed processes"
squeue -u sergio -t PD | wc -l

echo "total files done, all dirs"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/*/*.mat | wc -l
echo " "
echo "total files done, dir 1"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/1/*.mat | wc -l
echo "total files done, dir 2"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/2/*.mat | wc -l
echo "total files done, dir 3"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/3/*.mat | wc -l
echo "total files done, dir 4"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/4/*.mat | wc -l
echo "total files done, dir 5"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/5/*.mat | wc -l
echo "total files done, dir 6"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/6/*.mat | wc -l
echo "total files done, dir 7"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/7/*.mat | wc -l
echo "total files done, dir 8"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/8/*.mat | wc -l
echo "total files done, dir 9"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/9/*.mat | wc -l
echo "total files done, dir 10"
ls /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/10/*.mat | wc -l
