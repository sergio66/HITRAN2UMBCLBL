addpath /home/sergio/SPECTRA

dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/';

topts = runXtopts_params_smart(60); 
dv = topts.ffin*nbox*pointsPerChunk;
wn1 = 50;
wn2 = 80-dv;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;