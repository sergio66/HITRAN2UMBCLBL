dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
dirout = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g' num2str(gid) '.dat/WOBASEMENT/'];

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;
topts.HITRAN = '/asl/data/hitran/h08.by.gas/';

wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results
wn2 = 2855-dv;   %% when checking against Howards results

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
