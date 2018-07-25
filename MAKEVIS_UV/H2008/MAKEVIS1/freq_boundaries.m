wn1 = 12000;
wn2 = 25500-500;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/VIS12000_25000/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/VIS12000_25000/';

topts = runXtopts_params_smart(14000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;