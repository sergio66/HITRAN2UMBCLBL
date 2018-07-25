addpath /home/sergio/SPECTRA

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/CKD/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% all bands
CKD = 1; CKD = 6; CKD = 25;
wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results
topts = runXtopts_params_smart(2000); 
bandID = 'IR';       %% this is the IR band
chunkprefix = 'r';   %% all kCompressed files will be eg r1005_g101_ckd_1.dat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dv = topts.ffin*nbox*pointsPerChunk;
%% these will be overwritten by code calling this subroutine
fmin = wn1; 
fmax = wn2;

