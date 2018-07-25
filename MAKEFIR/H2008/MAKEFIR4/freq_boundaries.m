wn1 = 80;
wn2 = 160-5;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR80_150/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR80_150/';

topts = runXtopts_params_smart(100); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;