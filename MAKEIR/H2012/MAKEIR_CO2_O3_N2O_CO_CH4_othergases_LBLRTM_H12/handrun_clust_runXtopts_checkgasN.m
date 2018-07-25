%% JUST DO LAYER 20
disp('WARNING : runs in LBLRTM/Toff5_06 ... so will overwrite TAPE5/TAPE6 there ... ');

% Sgid     = str2num(JOB(1:2));
% Schunk   = str2num(JOB(3:7));  
% Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;

JOB = 'test';
Sgid     = input('Enter gasID : ');
Schunk   = 605;
Stoffset = 6; Stt = Stoffset - 6;

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
addpather = ['addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff5_' num2str(Stoffset,'%02d')]; eval(addpather);
addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/XHUANG

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;
freq_boundaries       %%% these are standard, using 0.0025 cm-1 output
%% freq_boundariesLBL    %%% these are high res, using 0.0005 cm-1 output

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

iLay = 20;
if gg == 1
  iLay = 4;
end
%fprintf(1,' \n doing layer %2i \n\n',iLay)

iLay = input('Enter which layer : ');


dvBIG = 500.0;
while fmin <= wn2
  disp(' ')
  fmax = fmin + dvBIG;
  fmax = min(fmax,2830);
  
  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  for tt = Stt
    tprof = refpro.mtemp + tt*10;

    if gid <= 47
      iYes = findlines_plot(fmin-dv,fmax+dv,gg);
    else
      iYes = read_LBRTM_FSCDXS(fmin-dv,fmax+dv,gg);
    end

    fout = [dirout '/std_test_layer' num2str(iLay,'%02d') '_' num2str(fmin) '_' num2str(fmax)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat'];
    fprintf(1,'fout = %s \n',fout);

    if exist(fout,'file')
      rmer = ['!/bin/rm ' fout];
      eval(rmer);
    end
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
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff5_' num2str(Stoffset,'%02d')]; eval(cder);
      rmerTAPEX = ['!/bin/rm TAPE5 TAPE6 TAPE9 TAPE10 TAPE11 TAPE12 ODint_001'];
      eval(rmerTAPEX);
      
      if iUseOldWay == +1
        %% v1 OLD
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas contribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay);
        dN2O2 = dlblrtm;

        d = dall - dN2O2;
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12/

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
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay);
	elseif  gasid == 7 | gasid == 22
          %[w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2true(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay); %% OLD
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay); %% NEW
	elseif gasid >= 51 & gasid <= 63
          [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1,iLay);
	else
	  error('need 1 <= gid <= 47   and 51 <= gid <= 63')
	end
        d = dlblrtm;
        %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12/
        cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12

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
  fmin = fmin + dvBIG;
%disp('testing :  one chunk is enough')
%return
%  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12
end                 %% loop over freq

% cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wall = [];
dall = [];
fmin = 605;
while fmin <= 2605
  fmax = min(fmin + dvBIG,2830);
  fout = [dirout '/std_test_layer' num2str(iLay,'%02d') '_' num2str(fmin) '_' num2str(fmax)];
  fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat'];
  if exist(fout)
    loader = ['junk = load(''' fout ''');'];
    eval(loader);
    wall = [wall junk.w];
    dall = [dall junk.d'];
  end
  fmin = fmin + dvBIG;
end
figure(1); clf; semilogy(wall,dall); title([num2str(gid) ' : from 500 cm-1 chunks'])

