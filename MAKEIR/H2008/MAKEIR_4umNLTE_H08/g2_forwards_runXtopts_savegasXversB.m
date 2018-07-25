% same as g2_forwards_runXtopts_savegasX.m except loops over Toffset
% same as g2_forwards_runXtopts_savegasX.m except loops over Toffset
% same as g2_forwards_runXtopts_savegasX.m except loops over Toffset

% local running to test
% clustcmd -L g2_forwards_runXtopts_savegasXversB.m 1:11
%
% otherwise when happy
% clustcmd -q medium -n 11 g2_forwards_runXtopts_savegasXversB.m 1:11

%% look at eg ~sergio/KCARTA/SRCv1.16/NONLTE/sergio/VT_48PROFILES_120_400ppmv/sergio_mergeMAIN/vt1_s0.prf for a NLTE profile file

%% see /home/sergio/KCARTA/SRCv1.16/NONLTE/sergio/AIRSDATA_NLTE_VIBTEMPS_Puertas

solzen = 0;

raToffset = -5 : 5;

addpath /home/sergio/HITRAN2UMBCLBL/MAKEIR_4umNLTE
homedir = pwd;

JOB
iProfile = raToffset(JOB);
fprintf(1,'this is g2_forwards_runXtopts_savegasXversB.m solzen = %3i TOFF = %3i \n',solzen,iProfile*10);

nbox = 5;
pointsPerChunk = 10000;

time_pause = ceil(rand*100);
%pause(time_pause)
pause(1)       %% <<<<<<-------

freq_boundaries

gases = 2;

startchunk = wn1;

fprintf(1,'processing gasid with startchunk = %3i %8.4f \n',gases,startchunk);

wn1 = startchunk;

load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

fmin = wn1; 
fmax = wn2; 

dirout0 = dirout;

wn2 = fmin;   %% so we do one big thing!!!!

while fmin <= wn2
  fmax = fmin + dv;
  for pp = iProfile

    ppp = pp + 6;

    wfreq0 = [];
    dkcomp0 = zeros(100,10000);

    gasid = gases;  
    fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

    gq = gasid;
    tprof = refpro.mtemp + pp*10;
    profile = ...
        [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';

    dirout = [dirout0 '/' num2str(solzen) '/'];
    cder = ['cd ' dirout]; eval(cder);

    fout = ['std' num2str(fmin) '_' num2str(gq) '_' num2str(pp+6) '.dat'];

    ee = exist(fout,'file')
    if ee > 0
      fprintf(1,'%s already exists \n',fout);
    end

    if gasid > 1 & ee == 0
      %toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      %eval(toucher);

      make_fstd_ip(dirout0,solzen,ppp,-1);

      fprintf(1,'g,w1,w2,toffset = %3i %6i %6i %2i\n',gasid,fmin,fmax,pp);
      sedder = ['!sed    -e "s/SSS/' num2str(solzen) '/g" '];
      sedder = [sedder ' -e "s/PPP/' num2str(ppp) '/g" '];

      fnml = ['nlte_sol_' num2str(solzen)  '_toff_' num2str(ppp) '.nml'];
      sedder = [sedder homedir '/quickuseNLTE_template.nml > ' fnml];
      eval(sedder);
      kcartaer = ['!/home/sergio/KCARTA/BIN/bkcarta.x ' fnml ' ' fout];

      eval(kcartaer)
      rmer = ['!/bin/rm ' fnml]; eval(rmer);
      cder = ['cd ' homedir]; eval(cder);

    end

  end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_4umNLTE
