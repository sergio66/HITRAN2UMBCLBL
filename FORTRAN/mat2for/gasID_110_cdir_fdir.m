%% cdir = where to read kcompressed mat files for WV w/o HDO
%% fdir = where to save kcompressed f77 files for WV w/o HDO

cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/kcomp.h2o/';          
fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/fbin/h2o.ieee-le/';   
fdir = '/asl/rta/kcarta/H2012.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le
cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';          
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

cdir = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';
fdir = '/asl/rta/kcarta/H2020.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

cdir = '/umbc/rs/pi_sergio/WorkDirDec2025/H2024_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';
fdir = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g110.dat/kcomp.h2o/';
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized

fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize all
%}
