dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/g103.dat/'];

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 2830;
wn2 = 3580-dv;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
