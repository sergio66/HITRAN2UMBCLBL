wn1 = 500;
wn2 = 605-15;
wn1 = 605;
wn2 = 630-15;

wn1 = 500;
wn2 = 630-15;

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR500_605/';
dirout = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR500_605/';

topts = runXtopts_params_smart(500); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;