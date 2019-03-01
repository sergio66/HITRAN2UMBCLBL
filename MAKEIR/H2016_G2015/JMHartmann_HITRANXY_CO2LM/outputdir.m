output_dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LMBirn/';     %% Birn chi and line mix
output_dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/';         %% no Birn, 0.0025 cm-1 res

output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_noWVbroad/';   %% no Birn, no WV broad, 0.0005 cm-1 res boxcar integrate to 0.0025, this is GARBAGE
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox/';             %% no Birn, 0.0005 cm-1 res boxcar integrate to 0.0025

%% 385 ppm
%% voigt done by run8, various incarnations of /asl/data/hitran/h16.by.gas/g2.dat ---> /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_MarXY_HH.MMam
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_385ppm/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_385ppm/';
%% 400 ppm
%% voigt done by run8, various incarnations of /asl/data/hitran/h16.by.gas/g2.dat ---> /asl/data/hitran/H2016/LineMix/new_lm_g3_0.dat_Oct06_08.20am
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_400ppm_Oct06_2018/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat, 400 ppm, no tsp
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat, 400 ppm, no tsp, and T dependence of self braod same as that of forn broad
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat, 400 ppm, no tsp, and T dependence of self braod same as that of forn broad, plus rdmult in lm_kcarta_5ptboxcar_new.x is now 3000.0 instead of 30.0
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix_rdmult/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat, 400 ppm, no tsp, and T dependence of self braod same as that of forn broad, plus rdmult in lm_kcarta_5ptboxcar_new.x is now 1000000.0 instead of 30.0; also new Qtips and mass isotopes according to H2016
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix_rdmult_newQtip/';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat, 400 ppm, no tsp, and T dependence of self braod same as that of forn broad, plus rdmult in lm_kcarta_5ptboxcar_new.x is now 1000000.0 instead of 30.0; also new Qtips and mass isotopes according to H2016 ... run8 has xfar = 1250 cm
%% have to make sure this is same as in the LMexec???
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix_rdmult_newQtip1250/';

%% >>>>>>>>>>  in cluster_run_lm_5ptboxcar_laychunk.m  MAKE SURE you correctly set fortran_exec <<<<<<<<<<<<<
%% >>>>>>>>>>  in cluster_run_lm_5ptboxcar_laychunk.m  MAKE SURE you correctly set fortran_exec <<<<<<<<<<<<<
%% voigt done by run8, latest exec from Iouli Gordon
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_385ppm/';         %% first cut, forgot to do the adjustment to 400 ppm
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/';         %% first cut,           do the adjustment to 400 ppm
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/';  %% first fix cut, redid Qtips, voigt/lorentz rdmult=1e6, xfar=500
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/';  %% second fix cut,redid Qtips, voigt/lorentz rdmult=1e3, xfar=500
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/';  %% third fix cut,redid Qtips, voigt/lorentz rdmult=1e3, xfar=500, revert to orig "fact"
%% >>>>>>>>>>  in cluster_run_lm_5ptboxcar_laychunk.m  MAKE SURE you correctly set fortran_exec <<<<<<<<<<<<<
%% >>>>>>>>>>  in cluster_run_lm_5ptboxcar_laychunk.m  MAKE SURE you correctly set fortran_exec <<<<<<<<<<<<<
