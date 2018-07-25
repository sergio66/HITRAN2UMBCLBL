iNumBands = 2;   %% number of HDO bands

%%%%%%%%%%%%%%%%
%% all bands
wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results

addpath /home/sergio/SPECTRA

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these will be overwritten by code calling this subroutine
fmin = wn1; 
fmax = wn2;

CKD = 1;
