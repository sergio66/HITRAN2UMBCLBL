%% MID IR
wn1 = 1105;  wn2 = 1430-25;  %% so that we can use bands that TES uses
wn1 = 1105;  wn2 = 1730-25;  %% so that we can use bands that TES uses
wn1 = 0880;  wn2 = 1955-25;  %% so that we can use bands that TES uses ... from waterlines_plot.m

%% 15 um
wn1 = 0605;  wn2 = 0880-25;  %% so that we can use 15 um band as well

%% SWIR
wn1 = 2355;  wn2 = 2855-25;  %% so that we can use bands that TES uses
wn1 = 2405;  wn2 = 2855-25;  %% so that we can use bands that TES uses

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/';
dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g103.dat';
dirout = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g103.dat';

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this subroutine
wn1 = 605;
wn2 = 2855 - 25;
fmin = wn1; 
fmax = wn2;
