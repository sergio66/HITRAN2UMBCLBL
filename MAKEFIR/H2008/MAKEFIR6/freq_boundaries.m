addpath /home/sergio/SPECTRA

dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR30_50/';

topts = runXtopts_params_smart(40); 
dv = topts.ffin*nbox*pointsPerChunk;
wn1 = 30;
wn2 = 50-dv;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;