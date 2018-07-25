%% same as clust_runXtopts_savegasN_file_*.m except it figures which  "Toff5_" subdirs ....

%% this simply does all wavenumbers for gN

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%%% OLD WAY
%{
%% test eg JOB='0102230054'; clust_runXtopts_savegasN_file
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
JOB = getenv('SLURM_ARRAY_TASK_ID');
Sgid     = str2num(JOB(1:2));                        %% should be 1
Schunk   = str2num(JOB(3:7));                        %% for IR 605 : 25 : 2805
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;    %% should be 1 - 11 ---> -5 : +5
Sppmult  = str2num(JOB(10));                         %% should be 1 - 5
%}

%% to see what chunks should be made, check out
%% PARAMETER (kCompParamFile = 
%%     /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC/PARAM_TEMP/testH2012_oldCO2

%%% NEW WAY gids to do == 
thefile = load('file_parallelprocess_wv.txt');   %%% 297 entries in there
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
% JOB = 3*11 + 5;  %% so this is (third+1) gas == gas  1, offset 5, pp(1)
% JOB = 1*11 + 5;  %% so this is (sixth+1) gas == gas 12, offset 5
JOB = thefile(JOB);
JOB = num2str(JOB,'%010d');
Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;
Sppmult  = str2num(JOB(10));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('see /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LNFL2.6/aer_v_3.2/line_files_By_Molecule/01_H2O/Readme')
%{
>>> disp('qtips04.m : for water the isotopes are 161  181  171  162  182  172');

lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl

originally
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O

now
lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O_use_this_for_all

ie (a) have moved 01_H2O to 01_H2O_use_this_for_all
   (b) currently symbolically link          01_H2O  to  01_h2o_162_excl         which is everything but the HDO (isotope 4) database  (gas 1)
   (c) after this is done symbolically link 01_H2O  to  01_h2o_162_only         which is ONLY the HDO isotope                         (gas 103)
   (d) after this is done symbolically link 01_H2O  to  01_H2O_use_this_for_all which is default                                      (gas 110)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];
ppmult = poffset;
ppmult = ppmult(Sppmult);
fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i ppmult = %8.6f \n',JOB,Sgid,Schunk,Stoffset,ppmult);

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
      cder = ['cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/Toff5_' num2str(Stoffset,'%02d')]; eval(cder);
      rmerTAPEX = ['!/bin/rm TAPE5 TAPE6 TAPE9 TAPE10 TAPE11 TAPE12']; eval(rmerTAPEX);      
      
      if iUseOldWay == +1
        %% v1 OLD
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
        dall = dlblrtm;

        %% compute ODs due to other gases (O2+N2) by putting current gas contribution = 0
        [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_N2O2fake(gasid,fmin,fmax,['/home/sergio/SPECTRA/' fip],-1,-1);
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
  fmin = fmin + dv;
%  %% one chunk is enough
%  return
%  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12
end                 %% loop over freq

% cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_H12
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_H12
