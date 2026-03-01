iNumBands = 2;   %% number of HDO bands

%%%%%%%%%%%%%%%%
%% all bands
wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results

addpath /home/sergio/SPECTRA

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/';
dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/';
dirout = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/';
dirout = '/umbc/rs/pi_sergio/WorkDirDec2025/H2024_RUN8_NIRDATABASE/IR_605_2830/';

%% see /home/sergio/HITRAN2UMBCLBL/MAKE_CKD/freq_boundaries_continuum.m
bandID = 'IR';       %% this is the IR band
chunkprefix = 'r';   %% all kCompressed files will be eg r1005_g101_ckd_1.dat


topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these will be overwritten by code calling this subroutine
fmin = wn1; 
fmax = wn2;

CKD = 1;
CKD = 25;
CKD = 32;
CKD = 43;

%%% note the order here
diroutABC = dirout;
diroutCompressed = [diroutABC '/kcomp.CKD' num2str(CKD) '/'];
dirout           = [diroutABC '/CKD'       num2str(CKD) '/'];
