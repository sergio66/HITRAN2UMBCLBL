dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
dirout = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_WV/g103.dat/';
dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/';
dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/lblrtm0.0005/';   %% high res for kcarta

topts = runXtopts_params_smart(2000); 

topts.ffin = 1.000e-4;   %%% !!!!!!!!! high res !!!!!!!
dv = topts.ffin*nbox*pointsPerChunk;

%% these may be overwritten by the code that actually calls this subroutine

wn1 = 605;
wn2 = 1855-dv;   %% when checking against Howards results
wn2 = 0855-dv;   %% just do 15 um to check heating rates

wn1 = 855;
wn2 = 1205-dv;   %% also do window and O3

fmin = wn1; 
fmax = wn2;
