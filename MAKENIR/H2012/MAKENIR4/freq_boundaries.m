addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC

dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR8250_12250/g' num2str(gid) '.dat/'];

topts = runXtopts_params_smart(8000); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 8250;
wn2 = 12500-250;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
