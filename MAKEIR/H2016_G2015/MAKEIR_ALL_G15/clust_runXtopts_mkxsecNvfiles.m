%% this simply does all wavenumbers for g1

% local running to test
% clustcmd -L clust_runXtopts_mkxsecNvfiles.m 51:81
%
% otherwise when happy
% clustcmd -q medium -n 32 clust_runXtopts_mkxsecNvfiles.m 51:81
%
% or
% clustcmd -q long_contrib -n 32 clust_runXtopts_mkxsecNvfiles.m 51:81

%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil
addpath /asl/matlib/science

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_ALL_G15

%gid = input('Enter gasID : ');
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 51
gid = JOB;
if gid < 51
  error('not for MOL GAS IDs')
end

%{
%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
%}

nbox = 5;
pointsPerChunk = 10000;
freq_boundaries

figure(1); clf
addpath /home/sergio/SPECTRA/READ_XSEC

iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81
if gid <= iSwitchXsecDataBase
  bands = list_bands(gid,2015);
else
  bands = list_bands(gid,2012);
end  
numbands = length(bands.v1);

%%%%%%%%%%%%%%%%%%%%%%%%%
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = findxsec_plot_fast(wn,wn+dv,bands);
  if woo >= 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_ALL_G15

slash = findstr(dirout,'/');
diroutXN = dirout(1:slash(end)-1);

fout = [diroutXN '/abs.dat'];
ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  %iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  iAns = 1;
  if iAns == 1
    mker = ['!mkdir ' fout];
    eval(mker);
  else
    error('cannot proceed');
  end
end

figure(2); clf;
fmin = wn1; 
fmin = iaChunk(1);
while fmin <= iaChunk(end)
  fmax = fmin + dv;

  iSave = 0;
  fr = [];
  k = zeros(10000,100,11);

  fout = [diroutXN '/abs.dat/g' num2str(gid) 'v' num2str(fmin) '.mat'];
  if exist(fout) == 0
    fprintf(1,'processing %8.2f \n',fmin)

    for pp = -5 : +5
      fin = [dirout '/std' num2str(fmin) '_' num2str(gid) '_' num2str(pp+6) '.mat'];
      lser = dir(fin);
      if length(lser) == 0
        clear lser
        lser.bytes = 0;
      end
      if lser.bytes > 500000
        iSave = iSave + 1;
        fprintf(1,'  gasID freq pp = %3i %6f %3i \n',gid,fmin,pp);
        loader = ['load ' fin ];
        eval(loader);
        fr = w;
        k(:,:,pp+6) = d';
        if pp == 0
          figure(2); plot(fr,exp(-d(1,:))); hold on; pause(0.1); % disp('ret to continue');   
        end
      end
    end                 %% loop over temperature (1..11) pp

    if iSave == 11
      fprintf(1,'saving %s \n',fout);
      saver = ['save ' fout ' fr gid k ' ];
      eval(saver);
    else
      fprintf(1,'file(s) too small : gasID freq size = %3i %6i %8i \n',gid,fmin,lser.bytes);
    end  %% if
  else
    fprintf(1,'%s already exists .... \n',fout)
  end

  fmin = fmin + dv;
end                   %% loop over freq

figure(2); hold off;
