dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR500_605/g' num2str(gid) '.dat/lblrtm2/'];

topts = runXtopts_params_smart(500); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 500;
wn2 = 630-dv;   %% when checking against Howards results
wn2 = 630-15;   %% when checking against Howards results

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
