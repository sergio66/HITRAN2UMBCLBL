dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results
wn2 = 2855-dv;   %% when checking against Howards results

%%% testing the JClim 2021 paper
%wn1 = 405;
%wn2 = 630;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
