## this is getting prepared for next round of uncertainty runs!!!!
/bin/rm -R /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g*.dat/
/bin/rm  /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/kcomp/*
/bin/rm  /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/abs.dat/*

### now remake the dirs
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g1.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g1.dat/abs.dat
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g1.dat/kcomp.h2o

mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g103.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g103.dat/abs.dat
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g103.dat/kcomp.h2o

mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g3.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g4.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g5.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g6.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g9.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g12.dat/
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/kcomp
mkdir -p /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/abs.dat

ls -ltR /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/ | more
