%% quick test to check compression
cd /carrot/s1/sergio/RUN8_VISDATABASE/VIS4000_4500/kcomp

load cg5v4250.mat     %% this is for CO
toinky = squeeze(kcomp(:,:,6)); %%pulls out stuff for toffset = 0 ==> US Std
toinky = B * toinky; toinky = toinky.^(4);
toinky(1:10,1)                                                            
