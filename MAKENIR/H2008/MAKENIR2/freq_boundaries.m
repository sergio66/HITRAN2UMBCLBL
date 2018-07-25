wn1 = 3550;
wn2 = 5750-100;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR3550_5550/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR3550_5550/';
topts = runXtopts_params_smart(4000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;