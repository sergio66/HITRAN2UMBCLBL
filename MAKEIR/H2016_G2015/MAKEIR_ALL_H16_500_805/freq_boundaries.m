dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g' num2str(gid) '.dat'];

topts = runXtopts_params_smart(2000); 
topts.ffin = 0.0001;   
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 605;
wn1 = 500;
wn2 = 815-dv;   %% when checking against Howards results
wn2 = 880-dv;   %% when checking against Howards results; Howard suggested a large overlap for SRF conv

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
