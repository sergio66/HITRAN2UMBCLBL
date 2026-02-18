%% this simply does all wavenumbers for g1
%% to make the individual chuncks/gases into eg /asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/gX.dat, run this with 
%%   sbatch --array=1-8492%256 --output='/dev/null' sergio_matlab_makegas3_42.sbatch     or
%%   sbatch --array=1-8492%256                      sergio_matlab_makegas3_42.sbatch 1    or
%% but first make sure you run
%%  loop_filelist_xsecN.m             to make initial filelist for all gases 
%% 
%% and check progress using
%%  loop_gas_done_already
%%
%% compare against previous database using eg
%%  compare_mol_H2016_H2020_indchunks.m    for individual chunks
%%  compare_mol_H2016_H2020_allchunks.m    for allchunks chunks

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 586
%JOB = 800
if length(JOB) == 0
  JOB = 1;
end

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('gN_ir_xseclist.txt');
gasIDlist = load('gN_ir_xseclist2.txt');
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));  
Stoffset = str2num(XJOB(8:9)); Stt = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);

%% does the cross sections
%% see     head /asl/data/hitran/xsec98.ok/*.xsc | more

nbox = 5;
pointsPerChunk = 10000;

gases = 51:63; %%%%%%% <<<<<<<< need to change this as needed!
gases = 51:81; %%%%%%% <<<<<<<< need to change this as needed!
gases = Sgid;
gid   = Sgid;

%load /home/sergio/abscmp/refproTRUE.mat
%load /home/sergio/HITRAN2UMBCLBL/refpro3.mat         %% ~2004 to Dec 2009
%load /home/sergio/HITRAN2UMBCLBL/refprof_usstd2010_lbl.mat  %% July 2010 - 
  %% copied/massaged from /asl/packages/klayersV205/Data/refprof_usstd2010.mat
  %% see make_refprof2010.m
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link

%addpath /home/sergio/HITRAN2UMBCLBL/READ_XSEC/
addpath0
addpath /home/sergio/git/UMBC_LBL/READ_XSEC/

freq_boundaries

cd /home/sergio/SPECTRA

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

while fmin <= wn2
  fmax = fmin + dv;
  for tt = Stt
    wfreq0 = [];
    dkcomp0 = zeros(100,10000);
    for gg = 1 : length(gases)
      gasid = gases(gg);  

      gq = find(refpro.glist == gasid);
      tprof = refpro.mtemp + tt*10;
      profile = ...
        [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';
      cd /home/sergio/SPECTRA

      iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
      iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81
      iSwitchXsecDataBase = 9999;  %% now we have       H2020 for g51-81
      if gasid <= iSwitchXsecDataBase
        %[iYes,gf] = findxsec_plot(fmin,fmax,gasid,2016);
        [iYes,gf] = findxsec_plot(fmin,fmax,gasid,2020);
      else
        [iYes,gf] = findxsec_plot(fmin,fmax,gasid,2012);
      end
      fprintf(1,'gas freq = %3i %6i %3i %3i\n',gasid,fmin,iYes,tt);
      fout = [dirout '/std' num2str(fmin) '_' num2str(refpro.glist(gq)) '_' num2str(tt+6) '.mat'];

      %% see abscmp/xsectab25.m
      gamnt = profile(5,:);
      gamnt2d = ones(1e4,1) * gamnt;
      tp = profile(4,:);
      pL = profile(2,:);
      d = zeros(100,10000);
      if exist(fout,'file') == 0 & iYes > 0
        fprintf(1,'% making %s \n',fout)
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk  
        eval(toucher); 
        %[w,d] = calc_xsec(gf,fmin,fmax-dv,dv,tp,pL,1);  
        v1 = fmin; v2 = fmax-dv;
        dvv = dv/pointsPerChunk;
        nvpts = 1 + round((v2-v1)/dvv);
        %[gasid fmin fmax dv dvv nvpts]
        %[d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL,1);
	figno = 1;
	if gasid <= iSwitchXsecDataBase
          %[d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL,figno,2016);
          [d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL,figno,2020);
	else
          [d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL,figno,2012);
	end
        d = d.*gamnt2d;
        d = d';    %%% need same dimensions as rest of gases!

        saver = ['save ' fout ' w d '];
        eval(saver);
	fprintf(1,'saved %s \n',fout);

      elseif exist(fout,'file') > 0 & iYes > 0
        fprintf(1,'file %s already exists \n',fout);
      elseif exist(fout,'file') == 0 & iYes < 0
        fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
      end

      %ee = exist(fout,'file');
      %if ee > 0
      %  fprintf(1,'%s already exists \n',fout);
      %end
      %if iYes > 0 & ee == 0
      %end

    end               %% loop over gas
  end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  %% one chunk is enough
  return
end                   %% loop over freq

fprintf(1,'FINISHED clust_runXtopts_savexsecN_file.m : JOB = %4i done, used hitran_fname = %s \n',hitran_fname);

cder_home


