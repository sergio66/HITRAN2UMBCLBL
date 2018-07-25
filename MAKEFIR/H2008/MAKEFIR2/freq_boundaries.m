wn1 = 300;
wn2 = 520-10;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR300_510/';

topts = runXtopts_params_smart(400); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;