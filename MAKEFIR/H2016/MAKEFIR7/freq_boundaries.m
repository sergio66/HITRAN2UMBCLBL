addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC

dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR15_30/g' num2str(gid) '.dat/'];

topts = runXtopts_params_smart(25); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 15;
wn2 = 30-dv;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
