addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC

dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR5550_8200/g' num2str(gid) '.dat/'];

topts = runXtopts_params_smart(6000); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 5550;
wn2 = 8400-150;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
