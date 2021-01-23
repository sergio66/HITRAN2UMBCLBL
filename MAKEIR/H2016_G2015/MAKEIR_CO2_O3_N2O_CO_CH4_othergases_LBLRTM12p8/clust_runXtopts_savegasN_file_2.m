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

%% same as clust_runXtopts_savegasN_file.m except it goes to "Toff2_" subdirs ....

%% this simply does all wavenumbers for gN

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

parse_job_string

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat
%% compare to INCLUDE/kcarta.param
%%         PARAMETER (kOrigRefPath =
%%      $          '/asl/data/kcarta_sergio/KCDATA/RefProf_July2010.For.v115up_CO2ppmv385/')

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff2_' num2str(Stoffset,'%02d')]; eval(addpather);
addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/XHUANG

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;

freq_boundaries                           %% these are standard, using 0.0025 cm-1 output
%% freq_boundariesLBL                     %% these are high res, using 0.0005 cm-1 output
%% choose_usualORhighORveryhigh_freqres   %% iUsualORHigh = -1 or -2

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

if gasid == 1
  error('cannot use this for WV')  
end
if ((gasid < 2 & gasid > 47) & (gasid < 51 & gasid > 81))
  error('need  2 <= gid <= 47 OR 51 <= gid <= 81')
end

fmax = wn2;
%fmax = 1705;
while fmax >= wn1 + dv
  fmin = fmax - dv;

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

    fout = [dirout '/std' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat'];
    fprintf(1,'fout = %s \n',fout);

    if exist(fout,'file') == 0 & iYes > 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);

      cd /home/sergio/SPECTRA
      gpro = find(gg == refpro.glist);
      fprintf(1,'    gasID %2i corresponds to refpro gas %2i \n',gg,gpro);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gpro) tprof refpro.gamnt(:,gpro)]';
      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
      fclose(fid);

      %% [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff2_' num2str(Stoffset,'%02d')]; eval(cder);
      rmerTAPEX = ['!/bin/rm TAPE5 TAPE6 TAPE9 TAPE10 TAPE11 TAPE12']; eval(rmerTAPEX);      
      
      if iUseOldWay == +1
        %% v1 OLD
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas contribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_CO2_LBLRTM_H16/

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
	if gasid ~= 7 & gasid ~= 22 & gasid <= 47
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
	elseif gasid == 7 | gasid == 22
          %[w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2true(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1); %% OLD
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1); %% NEW
	elseif gasid >= 51 & gasid <= 81
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
	else
	  error('need 1 <= gid <= 47   and 51 <= gid <= 81')
	end
        d = dlblrtm;
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H16

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
  fmax = fmax - dv;
%  %% one chunk is enough
%  return
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H16
end                 %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H16
