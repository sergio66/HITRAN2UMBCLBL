dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm2/'];
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtmMlawer/'];   %% few runs for Eli, testing CO and O3
dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm0.0005/'];   %% high res for kcarta
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm/'];

topts = runXtopts_params_smart(2000);

topts.ffin = 1.000e-4;   %%% !!!!!!!!! high res !!!!!!!

dv = topts.ffin * nbox * pointsPerChunk;

wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results
wn2 = 2855-dv;   %% when checking against Howards results
wn2 = 0855-dv;   %% just do 15 um to check heating rates

%%% this is for O3
wn1 = 855;
wn2 = 1205-dv;   %% also do window and O3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

topts.ffin = 5.000e-4;   %%% !!!!!!!!! usual res !!!!!!!
dv = topts.ffin * nbox * pointsPerChunk;

%% this is for CO2 and CH4
wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
