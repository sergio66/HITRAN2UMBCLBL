%% same as clust_runXtopts_savegasN_file_2.m except it goes to "Toff_" subdirs ....

%% this simply does all wavenumbers for gN

% local running to test
% clustcmd -L clust_runXtopts_savegasN_file.m '020173001'
%
% otherwise when happy
% clustcmd -q medium -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
%
% or
% clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% test eg JOB='020223005'; clust_runXtopts_savegasN_file

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff_' num2str(Stoffset,'%02d')]; eval(addpather);
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/GLAB/Toff_' num2str(Stoffset,'%02d')];   eval(addpather);
addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/XHUANG

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;
freq_boundaries

if gid == 7 | gid == 22
  error('this is NOT for gid = 7,22')
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

while fmin <= wn2
  fmax = fmin + dv;

  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

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

      %% [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/GLAB/Toff_' num2str(Stoffset,'%02d')]; eval(cder);

      [w,dglab] = driver_glab_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],Stoffset*+1,-1);
      dall = dglab;

      d = dall;
      cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_GLAB_H12/
      saver = ['save ' fout ' w d'];
      eval(saver);
    elseif exist(fout,'file') > 0 & iYes > 0
      fprintf(1,'file %s already exists \n',fout);
    elseif exist(fout,'file') == 0 & iYes < 0
      fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
    end
  end               %% loop over temperature (1..11)
  fmin = fmin + dv;
%  %% one chunk is enough
%  return
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_GLAB_H12
end                 %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_GLAB_H12