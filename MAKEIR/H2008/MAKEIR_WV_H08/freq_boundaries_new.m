iNumBands = 2;   %% number of HDO bands

%%%%%%%%%%%%%%%%
%% all bands
wn1 = 605;
wn2 = 2855-25;   %% when checking against Howards results

wn1all(1) = wn1;
wn2all(1) = wn2;
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
wn1 = 1105;  wn2 = 1430-25;  %% so that we can use bands that TES uses
wn1 = 1105;  wn2 = 1730-25;  %% so that we can use bands that TES uses

wn1all(2) = wn1;
wn2all(2) = wn2;
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
wn1 = 2405;
%wn2 = 3030-25;  %% first cut
%wn2 = 3355-25;   %% eventually did everything till here
wn2 = 2855-25;   %% when checking against Howards results

wn1all(1) = wn1;
wn2all(1) = wn2;
%%%%%%%%%%%%%%%%

addpath /home/sergio/SPECTRA

dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';
dirout = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/';

topts = runXtopts_params_smart(2000); 
dv = topts.ffin*nbox*pointsPerChunk;

%% these will be overwritten by code calling this subroutine
fmin = wn1; 
fmax = wn2;

disp('WOOF : look at kcarta1.16.param ... be very careful about kWaterIsotopePath')
disp('       which has only gases 1,103 in the ISO bands')
disp(' VS kWaterPath which has ALL isotopes in 605-2830 cm-1')
error('woof woof woof')