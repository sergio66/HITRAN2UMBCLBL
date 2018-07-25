%% same as clust_runXtopts_savegasN_file.m except it goes to "Toff2_" subdirs ....

%% this simply does all wavenumbers for gN

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

homedir = pwd;

parse_job_string

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff2_' num2str(Stoffset,'%02d')]; eval(addpather);
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

iUseOldWay = +1;  %% this uses old way, which calls driver_glab_lblrtm_forn_MANYLAY (gasN + N2/O2 od)
                  %%                    then calls  driver_glab_lblrtm_forn_MANYLAY_N2O2_fake (N2/O2 od)
                  %% finally gasN is the difference between the two
iUseOldWay = +2;  %% this uses new way, which calls driver_glab_lblrtm_forn_MANYLAY_noN2con (gasN)

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
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff2_' num2str(Stoffset,'%02d')]; eval(cder);

      if iUseOldWay == +1
        %% v1 OLD       
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas conribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
        if max(d(:)) > 1e-40
          saver = ['save ' fout ' w d dall dN2O2'];
          eval(saver);
        else
           rmer = ['!/bin/rm  ' fout];
           eval(rmer);
           fprintf(1,'looks like ODs were too small (max = %8.6e) .. not worth saving %s !! \n',max(d(:)),fout);
        end
        cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR/H2016/MAKEFIR1_CO2_LBLRTM12p8/
	
      elseif iUseOldWay == +2
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        d = dlblrtm;
        cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR/H2016/MAKEFIR1_CO2_LBLRTM12p8/
        if max(d(:)) > 1e-40
          saver = ['save ' fout ' w d'];
          eval(saver);
        else
           rmer = ['!/bin/rm  ' fout];
           eval(rmer);
           fprintf(1,'looks like ODs were too small (max = %8.6e) .. not worth saving %s !! \n',max(d(:)),fout);
        end
      end

    elseif exist(fout,'file') > 0 & iYes > 0
      fprintf(1,'file %s already exists \n',fout);
    elseif exist(fout,'file') == 0 & iYes < 0
      fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
    end
  end               %% loop over temperature (1..11)
  fmin = fmin + dv;
%  %% one chunk is enough
%  return
  cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR/H2016/MAKEFIR1_CO2_LBLRTM12p8/
end                 %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR/H2016/MAKEFIR1_CO2_LBLRTM12p8/
