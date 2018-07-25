wn1 = 140;
wn2 = 315-5;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR140_310/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR140_310/';

topts = runXtopts_params_smart(200); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;