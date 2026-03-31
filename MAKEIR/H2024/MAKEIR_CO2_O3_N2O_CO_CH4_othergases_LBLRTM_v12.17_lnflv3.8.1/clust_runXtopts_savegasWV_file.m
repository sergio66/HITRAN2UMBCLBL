%% same as clust_runXtopts_savegasN_file_*.m except it figures which  "Toff_" subdirs ....

%% this simply does all wavenumbers for gN

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

parse_job_string_WV

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wv_readme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];
ppmult = poffset;
ppmult = ppmult(Sppmult);
fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i ppmult = %8.6f \n',JOB,Sgid,Schunk,Stoffset,ppmult);

adderpath
addpather = ['addpath ' outputdirToffALL '/ToffWV_' num2str(Stoffset,'%02d')]; eval(addpather);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

load_refprof

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;

set_the_freq_boundaries  %%% make sure you do this!!!!!

ee = exist(dirout);
if ee == 0
  mker = ['!mkdir -p ' dirout];
  eval(mker);
  fprintf(1,'made dir = %s \n',dirout);
end

%if gid == 7 | gid == 22
%  error('this is NOT for gid = 7,22')
%end

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

    if gid <= 40
      iYes = findlines_plot(fmin-dv,fmax+dv,gg); 
    else
      iYes = 1;
    end

    fout = [dirout '/stdH2O' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '_' num2str(Sppmult) '.mat'];	    
    fprintf(1,'fout = %s \n',fout);

    if exist(fout,'file') == 0 & iYes > 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);

      cd /home/sergio/SPECTRA
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*ppmult tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6) '_' num2str(Sppmult)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
      fclose(fid);

      %% [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      cder = ['cd ' outputdirToffALL '/ToffWV_' num2str(Stoffset,'%02d')]; eval(cder);
      rmerTAPEX = ['!/bin/rm TAPE5 TAPE6 TAPE9 TAPE10 TAPE11 TAPE12']; eval(rmerTAPEX);      
      
      if iUseOldWay == +1
        %% v1 OLD
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas contribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
	cder_here	

        if max(d(:)) > 1e-40
          saver = ['save ' fout ' w d dall dN2O2'];
	  eval(saver);
        else
          rmer = ['!/bin/rm  ' fout];
	  eval(rmer);
	  fprintf(1,'looks like ODs were too small (max = %8.6e) .. not worth saving %s !! \n',max(d(:)),fout);
	end
	
      elseif iUseOldWay == +2
        %% v2 NEW
	if gasid ~= 7 & gasid ~= 22 & gasid <= 32
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
	elseif  gasid == 7 | gasid == 22
          %[w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2true(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1); %% OLD
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1); %% NEW
	elseif gasid >= 51 & gasid < 63
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
	else
	  error('need 1 <= gid <= 32   and 51 <= gid <= 63')
	end
        d = dlblrtm;
	cder_here

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
  cder_here
end                 %% loop over freq

cder_here
