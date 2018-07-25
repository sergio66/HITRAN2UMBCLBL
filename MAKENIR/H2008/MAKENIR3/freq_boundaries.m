wn1 = 5550;
wn2 = 8400-150;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR5550_8200/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR5550_8200/';

topts = runXtopts_params_smart(6000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;