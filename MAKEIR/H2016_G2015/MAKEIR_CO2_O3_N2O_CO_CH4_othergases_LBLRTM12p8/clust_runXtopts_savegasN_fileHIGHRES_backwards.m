%% same as clust_runXtopts_savegasN_file_2.m except it goes to "Toff_" subdirs ....

%% this simply does all wavenumbers for gN

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% test eg JOB='020223005'; clust_runXtopts_savegasN_file

addpath /home/sergio/MATLABCODE
system_slurm_stats

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%% JOB = 1 .. 11 for CO2, 12 .. 22 for O3, 23 .. 33 for CH4
% JOB = getenv('SLURM_ARRAY_TASK_ID');
% JOB = '020060506';
% JOB = 5

%theJOB = load('file_parallelprocess_CO2.txt');
%theJOB = load('file_parallelprocess_O3.txt');
%theJOB = load('file_parallelprocess_gas_2_6.txt');      %% first 11 are CO2, next 11 are CH4

theJOB = load('file_parallelprocess_gas_2_3_6.txt');    %% first 11 are CO2, next 11 are O3, next 11 are CH4

JOB = theJOB(JOB);
JOB = ['0' num2str(JOB)];

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

if ~exist('Toff_run_offset')
  Toff_run_offset = 4; %% chances are I will only run this for gases 2,3,6 so this is a safe offset
end
if ~exist('wnoffset')
  wnoffset = 0;
end

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff' num2str(Sgid+Toff_run_offset) '_' num2str(Stoffset,'%02d')]; eval(addpather);
addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/XHUANG

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;

choose_usualORhighORveryhigh_freqres   %% iUsualORHigh = -1 or -2

%% set LBLRTM res before 5 point boxcar (so final res is x5 higher)
if iUsualORHigh >= 0
  dvLBLRTM = 0.0005;    %% 0.0005 x 5 pt boxcar = 0.0025
elseif iUsualORHigh == -1
  dvLBLRTM = 0.0001;    %% 0.0001 x 5 pt boxcar = 0.0005
elseif iUsualORHigh == -2
  dvLBLRTM = 0.0001/5;  %% 0.0001/5 x 5 pt boxcar = 0.0001 but this is too high for LBLRTM oops
elseif iUsualORHigh == -3
  dvLBLRTM = 0.0002/5;  %% 0.0002/5 x 5 pt boxcar = 0.0002 is limit of LBLRTM
end

if gid == 7 | gid == 22
  error('this is NOT for gid = 7,22')
end

ee = exist(dirout);
if ee == 0
  mker = ['!mkdir -p ' dirout];
  eval(mker);
  fprintf(1,'made dir = %s \n',dirout);
end

cd /home/sergio/SPECTRA

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = Schunk;
%% fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

% wn2 = Schunk + 25; %%  <<<<<<<<<< %%% this is new!!! so that we can only do 25 cm-1 at a time

iUseOldWay = +1;  %% this uses old way, which calls driver_glab_lblrtm_forn_MANYLAY (gasN + N2/O2 od)
                  %%                    then calls  driver_glab_lblrtm_forn_MANYLAY_N2O2_fake (N2/O2 od)
                  %% finally gasN is the difference between the two
iUseOldWay = +2;  %% this uses new way, which calls driver_glab_lblrtm_forn_MANYLAY_noN2con (gasN)
iUseOldWay = +3;  %% this uses new way, which calls driver_glab_lblrtm_forn_MANYLAY_WV_noN2con (gasN, includes effects of US Std WV)

fmin = wn2 - wnoffset;
while fmin >= wn1
  fmax = fmin + dv;

  fprintf(1,'gasID %3i : freq1, freq2, dv = %8.2f %8.2f %8.6f\n',gg,fmin,fmax,dv);

  for tt = Stt
    tprof = refpro.mtemp + tt*10;

    iYes = findlines_plot(fmin-dv,fmax+dv,1); 

    fout = [dirout '/std' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat']

    if exist(fout,'file') == 0 & iYes > 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);

      cd /home/sergio/SPECTRA
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
      fclose(fid);

      if gid == 2
        %% also need wv
        profile = [(1:100)' refpro.mpres refpro.gpart(:,1) tprof refpro.gamnt(:,1)]';
        fipw = ['IPFILES/std_gx' num2str(1) 'x_co2_wv_' num2str(tt+6)];
        fid = fopen(fipw,'w');
        fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
        fclose(fid);
      end

      %% [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff' num2str(Sgid+Toff_run_offset) '_' num2str(Stoffset,'%02d')]; eval(cder);
      pwd

      if iUseOldWay == +1
        
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,-1,dvLBLRTM);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas conribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,-1,dvLBLRTM);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
        % cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12/
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/
        saver = ['save ' fout ' w d dall dN2O2'];

      elseif iUseOldWay == +2
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,-1,dvLBLRTM);
        d = dlblrtm;
        %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12/
        %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_LBLRTM_H12
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/
        saver = ['save ' fout ' w d'];

      elseif iUseOldWay == +3 
        if gasid == 2

          [w,dglab,dlblrtm_co2_wv] = driver_glab_lblrtm_forn_MANYLAY_WVeffects_noN2con(gasid,fmin,fmax,...
                                     ['/home/sergio/SPECTRA/' fip],['/home/sergio/SPECTRA/' fipw],-1,-1,-1,dvLBLRTM);
          [w,dglab,dlblrtm_wv] = driver_glab_lblrtm_forn_MANYLAY_noN2con(1,fmin,fmax,['/home/sergio/SPECTRA/' fipw],-1,-1,-1,dvLBLRTM);
          dlblrtm = dlblrtm_co2_wv - dlblrtm_wv;
        else
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,-1,dvLBLRTM);
        end
        d = dlblrtm;
        %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12/
        %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_LBLRTM_H12
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/
        saver = ['save ' fout ' w d'];
      end
      eval(saver);
    elseif exist(fout,'file') > 0 & iYes > 0
      fprintf(1,'file %s already exists \n',fout);
    elseif exist(fout,'file') == 0 & iYes < 0
      fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
    end
  end               %% loop over temperature (1..11)
  fmin = fmin - dv;
%  %% one chunk is enough
%  return
%  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
%  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_LBLRTM_H12
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/
end                 %% loop over freq

% cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
% cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_LBLRTM_H12
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/
