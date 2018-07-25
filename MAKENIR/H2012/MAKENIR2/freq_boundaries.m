addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC

dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR3550_5550/g' num2str(gid) '.dat/'];

topts = runXtopts_params_smart(4000); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 3550;
wn2 = 5750-100;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
