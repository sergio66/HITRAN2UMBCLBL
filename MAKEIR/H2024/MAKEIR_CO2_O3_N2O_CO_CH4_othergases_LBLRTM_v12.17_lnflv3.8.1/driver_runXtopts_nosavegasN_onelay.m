function [w,wglab,drun8,dglab,dlblrtm] = driver_runXtopts_nosavegasN_onelay(Sgid,Schunk,Stoffset,layN);

%% this is a straight modificaion of clust_runXtopts_savegasN_file.m
%% also see /umbc/rs/pi_sergio/WorkDirDec2025/HITRAN2UMBCLBL/LBLRTM/driver_run8_glab_lblrtm_forn_ONELAY.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat has 385 ppmv for CO2  %%%
%% so you either increase CO2 here using a mutiplier eg                     %%%
%%   385*1.038961                                                           %%%
%%                                                                          %%%
%% or eg                                                                    %%%
%% /asl/data/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/ %%%
% /home/sergio/HITRAN2UMBCLBL/FORTRAN/mat2for/kcomp_co2_385_to_400.m        %%%
%% has a code to change the abs coeff "kcomp_co2_385_to_400.m"              %%%
%% which we have copied here to this dir                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w       = [];
drun8   = [];
dglab   = [];
dlblrtm = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% when the cluster does not work, can do
%%  <<<< for JOBB = 1 : 22; clust_runXtopts_savegasN_file; end >>>>
%% and you will make CO2/CH4, 11 Toffset, from 605-2830 cm-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this simply does all wavenumbers for gN

if nargin == 0
  Sgid = input('Enter gas ID : [default 2]');
  if length(Sgid) == 0
    Sgid = 2;
  end
  
  Schunk = input('Enter gas ID : [default 605]');
  if length(Schunk) == 0
    Schunk = 605;
  end
  Schunk0 = Schunk;
  
  Stoffset = input('Enter gas ID : [default 6 (1--11 are allowed offsets)]');
  if length(Stoffset) == 0
    Stoffset = 6;
  end

  layN = inpout('Enter layer (1:100) default 1 ')
  if length(layN) == 0
    layN = 1;
  end
  
elseif nargin == 1
  Schunk = input('Enter gas ID : [default 605]');
  if length(Schunk) == 0
    Schunk = 605;
  end
  Schunk0 = Schunk;
  
  Stoffset = input('Enter gas ID : [default 6 (1--11 are allowed offsets)]');
  if length(Stoffset) == 0
    Stoffset = 6;
  end

  layN = inpout('Enter layer (1:100) default 1 ')
  if length(layN) == 0
    layN = 1;
  end
  
elseif nargin == 2
  Stoffset = input('Enter gas ID : [default 6 (1--11 are allowed offsets)]');
  if length(Stoffset) == 0
    Stoffset = 6;
  end

  layN = inpout('Enter layer (1:100) default 1 ')
  if length(layN) == 0
    layN = 1;
  end

elseif nargin == 3
  layN = inpout('Enter layer (1:100) default 1 ')
  if length(layN) == 0
    layN = 1;
  end

else
  Schunk0 = Schunk;
end
Stt = Stoffset - 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'gid = %2i chunk = %5i Stoffset = %2i \n',Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

load_refprof

adderpath
addpather = ['addpath ' outputdirToffALL '/Toff_' num2str(Stoffset,'%02d')]; eval(addpather);

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;

set_the_freq_boundaries  %%% make sure you do this!!!!!

cd /home/sergio/SPECTRA

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = Schunk;
%% fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

% wn2 = Schunk + 25; %%  <<<<<<<<<< %%% this is new!!! so that we can only do 25 cm-1 at a time

iUseOldWay = +1;  %% this uses old way, which calls driver_glab_lblrtm_forn_MANYLAY (gasN + N2/O2 od)
                  %%                    then calls  driver_glab_lblrtm_forn_MANYLAY_N2O2_fake (N2/O2 od)
                  %% finally gasN is the difference between the two
iUseOldWay = +2;  %% this uses new way, which calls driver_glab_lblrtm_forn_MANYLAY_noN2con (gasN)

if gasid == 1
  error('cannot use this for WV')  
end
if ((gasid < 2 & gasid > 47) & (gasid < 51 & gasid > 81))
  error('need  2 <= gid <= 47 OR 51 <= gid <= 81')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fmax = wn2;
%%fmax = 1705;
%
%while fmax >= wn1 + dv
%  fmin = fmax - dv;

fmin = Schunk0;
fmax = Schunk0 + 25;

wn1 = Schunk0;
wn2 = Schunk0 + 25;

while fmin <= wn2-(25-1)
  fmax = fmin + dv;

  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  for tt = Stt
    tprof = refpro.mtemp + tt*10;

    iYes = 0;
    if gid <= 47 & gid ~= 22
      iYes = findlines_plot(fmin-dv,fmax+dv,gg); 
    elseif gid == 22 & fmin >= 1930 & fmin <= 2680
      iYes = 1;
    elseif gid >= 51
      iYes = 1;
      iYes = read_LBRTM_FSCDXS(fmin-dv,fmax+dv,gg);       
    end

    iYes = 1;
    if iYes > 0

      cd /home/sergio/SPECTRA
      gpro = find(gg == refpro.glist);
      fprintf(1,'    gasID %2i corresponds to refpro gas %2i \n',gg,gpro);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gpro) tprof refpro.gamnt(:,gpro)]';

      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
      fclose(fid);

      whos profile
      profile = profile';
      profileN = profile(layN,:);
      fprintf(1,'moo at driver_runXtopts_nosavegasN_onelay.m = %3i %8.4e %8.4e %8.5f %8.4e \n',profileN);
      
      %% [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      cder = ['cd ' outputdirToffALL '/Toff_' num2str(Stoffset,'%02d')]; eval(cder);
      rmerTAPEX = ['!/bin/rm TAPE5 TAPE6 TAPE9 TAPE10 TAPE11 TAPE12']; eval(rmerTAPEX);      

      %% driver_glab_lblrtm_forn_ONELAY --> driver_glab_lblrtm_forn_ONELAY_noN2con
      %% driver_glab_lblrtm_forn_ONELAY --> driver_glab_lblrtm_forn_ONELAY_noN2con      
      if iUseOldWay == +1
        %% v1 OLD
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_ONELAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas contribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_ONELAY_noN2con_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
	cder_here
		
      elseif iUseOldWay == +2
        %% v2 NEW
        %% driver_glab_lblrtm_forn_ONELAY --> driver_glab_lblrtm_forn_ONELAY_noN2con
        %% driver_glab_lblrtm_forn_ONELAY --> driver_glab_lblrtm_forn_ONELAY_noN2con		
	if gasid ~= 7 & gasid ~= 22 & gasid <= 47
          [w,wglab,drun8,dglab,dlblrtm] = driver_glab_lblrtm_forn_ONELAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);   %,-1,-1,layN);
	elseif gasid == 7 | gasid == 22
          %[w,wglab,drun8,dglab,,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2true(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);   %,-1,-1,layN); %% OLD
          [w,wglab,drun8,dglab,dlblrtm] = driver_glab_lblrtm_forn_ONELAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);   %,-1,-1,layN); %% NEW
	elseif gasid >= 51 & gasid <= 81
          [w,wglab,drun8,dglab,dlblrtm] = driver_glab_lblrtm_forn_ONELAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],layN);   %,-1,-1,layN);
	else
	  error('need 1 <= gid <= 47   and 51 <= gid <= 81')
	end
        d = dlblrtm;
        cder_here
      end
    end             %% iYes > 0
  end               %% loop over temperature (1..11), there is really only one
  fmin = fmin + dv;
  cder_here
end                 %% loop over freq

cder_here
