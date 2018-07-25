addpath /home/sergio/SPECTRA

dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR15_30/';

topts = runXtopts_params_smart(25); 
dv = topts.ffin*nbox*pointsPerChunk;
wn1 = 15;
wn2 = 30-dv;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;