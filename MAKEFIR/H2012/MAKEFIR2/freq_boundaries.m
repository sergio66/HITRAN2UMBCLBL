addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC

dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/g' num2str(gid) '.dat/'];

topts = runXtopts_params_smart(400); 
dv = topts.ffin*nbox*pointsPerChunk;

wn1 = 300;
wn2 = 520-10;

%% these may be overwritten by the code that actually calls this
%% subroutine
fmin = wn1; 
fmax = wn2;
