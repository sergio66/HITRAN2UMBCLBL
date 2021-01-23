% dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830/';
% dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm2/'];
% dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtmMlawer/'];   %% few runs for Eli, testing CO and O3
% dirout = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm0.0005/'];   %% high res for kcarta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iUsualORHigh > 0
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm/'];   %% usual
elseif iUsualORHigh == -1
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm0.0005/'];   %% high res for kcarta
elseif iUsualORHigh == -2
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm0.0001/'];   %% very high res for kcarta, I went for this
elseif iUsualORHigh == -3
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm0.0002/'];   %% very high res for kcarta, Guido pointed out dv=1.9945e-04 cm-1 is the limiting res for 580-1205 cm-1
end

if iUsualORHigh == -1
  %% high res and very high res
  topts = runXtopts_params_smart(2000);
  topts.ffin = 1.000e-4;   %%% !!!!!!!!! high res !!!!!!!

  dv = topts.ffin * nbox * pointsPerChunk;

  wn1 = 605;
  wn2 = 2855-25;   %% when checking against Howards results
  wn2 = 2855-dv;   %% when checking against Howards results
  wn2 = 0855-dv;   %% just do 15 um to check heating rates
  wn2 = 1205-dv;   %% also do window and O3

  wn1 = 500;
  wn2 = 1205-dv;   %% also do window and O3

  %%% this is for O3
  fmin = wn1; 
  fmax = wn2;

elseif iUsualORHigh == -2
  %% very high res
  topts = runXtopts_params_smart(2000);
  topts.ffin = 1.000e-4/5;   %%% !!!!!!!!! very high res !!!!!!!

  dv = topts.ffin * nbox * pointsPerChunk;

  wn1 = 605;
  wn2 = 2855-25;   %% when checking against Howards results
  wn2 = 2855-dv;   %% when checking against Howards results
  wn2 = 0855-dv;   %% just do 15 um to check heating rates
  wn2 = 1205-dv;   %% also do window and O3

  wn1 = 500;
  wn2 = 1205-dv;   %% also do window and O3

  fmin = wn1; 
  fmax = wn2;

elseif iUsualORHigh == -3
  %% very high res
  topts = runXtopts_params_smart(2000);
  topts.ffin = 2.000e-4/5;   %%% !!!!!!!!! very high res !!!!!!!

  dv = topts.ffin * nbox * pointsPerChunk;

  wn1 = 605;
  wn2 = 2855-25;   %% when checking against Howards results
  wn2 = 2855-dv;   %% when checking against Howards results
  wn2 = 0855-dv;   %% just do 15 um to check heating rates
  wn2 = 1205-dv;   %% also do window and O3

  wn1 = 500;
  wn2 = 1205-dv;   %% also do window and O3

  fmin = wn1; 
  fmax = wn2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif iUsualORHigh > 0
  topts.ffin = 5.000e-4;   %%% !!!!!!!!! usual res !!!!!!!
  dv = topts.ffin * nbox * pointsPerChunk;

  %% this is for CO2 and CH4
  wn1 = 605;
  wn2 = 2855-25;   %% when checking against Howards results

  %% these may be overwritten by the code that actually calls this
  %% subroutine
  fmin = wn1; 
  fmax = wn2;
end
