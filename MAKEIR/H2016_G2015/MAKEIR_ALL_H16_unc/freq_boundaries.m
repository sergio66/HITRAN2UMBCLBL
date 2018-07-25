%dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
%dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g' num2str(gid) '.dat'];

topts = runXtopts_params_smart(2000);
%topts.str_unc = '+';
set_str_unc

dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results
wn2 = 2855-dv;   %% when checking against Howards results

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
