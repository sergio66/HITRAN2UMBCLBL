wn1 = 8250;
wn2 = 12500-250;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR8250_12250/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR8250_12250/';

topts = runXtopts_params_smart(8000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;