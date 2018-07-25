addpath /home/sergio/SPECTRA

wn1 = 605;
wn2 = 2830-25;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/';

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;