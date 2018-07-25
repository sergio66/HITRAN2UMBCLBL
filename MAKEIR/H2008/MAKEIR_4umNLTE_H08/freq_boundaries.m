addpath /home/sergio/SPECTRA

wn1 = 2205;
wn2 = 2430-25;

dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/';

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;