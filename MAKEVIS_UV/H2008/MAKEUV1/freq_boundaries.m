wn1 = 25000;
wn2 = 45000-1000;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/UV25000_45000/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/UV25000_45000/';

topts = runXtopts_params_smart(40000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;