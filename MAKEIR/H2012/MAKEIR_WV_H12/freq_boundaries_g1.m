wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_WV/g1.dat/';
dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/';
topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
