dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat'];

topts = runXtopts_params_smart(2000); 
topts.ffin = 0.0001;   
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 605;
wn1 = 500;
wn2 = 815-dv;   %% when checking against Howards results
wn2 = 895-dv;   %% when checking against Howards results

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
