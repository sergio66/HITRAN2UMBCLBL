output_dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LMBirn';     %% Birn chi and line mix
output_dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM';         %% no Birn, 0.0025 cm-1 res

output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_noWVbroad';   %% no Birn, no WV broad, 0.0005 cm-1 res boxcar integrate to 0.0025, this is GARBAGE
output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox';             %% no Birn, 0.0005 cm-1 res boxcar integrate to 0.0025

%% voigt done by run8, various incarnations of /asl/data/hitran/h16.by.gas/g2.dat ---> /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_MarXY_HH.MMam
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8';
%% voigt done by run8, /asl/data/hitran/h16.by.gas/g2.dat ---> g2_origH16.dat
output_dirRUN8 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params/';