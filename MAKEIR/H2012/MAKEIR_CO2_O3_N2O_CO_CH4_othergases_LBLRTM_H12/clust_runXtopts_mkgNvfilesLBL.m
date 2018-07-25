%% this simply does all wavenumbers for gN

% local running to test
% clustcmd -L clust_runXtopts_mkgNvfiles.m 2:42
%
% otherwise when happy
% clustcmd -q medium -n 32 clust_runXtopts_mkgNvfiles.m 2:42
%
% or
% clustcmd -q long_contrib -n 32 clust_runXtopts_mkgNvfiles.m 2:42

%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil
addpath /asl/matlib/science

home = pwd;

gid = input('Enter gasID : ');
%gid = JOB;

if gid == 1
  error('not for WV')
end

if gid >= 51
  error('not for XSEC gases')
end

if gid ~= 2 & gid ~= 3 & gid ~= 5 & gid ~= 6 & gid ~= 7 & gid ~= 22
  error('only for CO2,O3,CO,CH4, and O2/N2')
end

%{
%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
%}

nbox = 5;
pointsPerChunk = 10000;
freq_boundariesLBL

figure(1); clf
addpath /home/sergio/SPECTRA
[iYes,line] = findlines_plot(wn1-dv,wn2+dv,gid);

if dv >= 25
  [iYes,line] = findlines_plot(fmin-dv,fmax+dv,gid);
else
  [iYes,line] = findlines_plot(fmin-25,fmax+dv+25,gid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);

  if dv >= 25
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
  else
    woo = find(line.wnum >= wn-25 & line.wnum <= wn+dv+25);
  end

  dv2 = max(dv,25);
  woo = find(line.wnum >= wn-dv2 & line.wnum <= wn+dv+dv2);

  if length(woo) >= 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%

cder = ['cd ' home]; eval(cder);

slash = findstr(dirout,'/');
if dirout(end) == '/'
  diroutXN = dirout(1:slash(end-1)-1);
else
  diroutXN = dirout(1:slash(end)-1);
end

diroutXN = [dirout '/'];
fout = [diroutXN '/abs.dat']
ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  if iAns == 1
    mker = ['!mkdir ' fout];
    eval(mker);
  else
    error('cannot proceed');
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% need to subtract out N2/O2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirX = dirout;
boo = findstr('.dat/lblrtm/',dirX);
foo = findstr('_2830/g',dirX);
dirN2 = [dirX(1:foo+6) '22' dirX(boo:end)];
%%% need to subtract out N2/O2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
      fN2 = [dirN2  '/std' num2str(fmin) '_' num2str(22) '_' num2str(pp+6) '.mat'];
      lser = dir(fin);
      if length(lser) == 0
        clear lser
        lser.bytes = 0;
      end

      lserN2 = dir(fN2);
      if length(lserN2) == 0
        clear lserN2
        lserN2.bytes = 0;
      end

%%      if lser.bytes > 500000
      if lser.bytes > 5000
        iSave = iSave + 1;
        fprintf(1,'  gasID freq pp = %3i %6f %3i \n',gid,fmin,pp);

%%%        loader = ['load ' fN2 ];
%%%        eval(loader);
%%%        dO2N2 = d';

        loader = ['load ' fin ];
        eval(loader);
        fr = w;
        if gid == 2 | gid == 3 | gid == 5 | gid == 6 | gid == 7 | gid == 22
          d = d'; %% darn LBL wrapper transposes the output!
        end          
%%%        k(:,:,pp+6) = d' - dO2N2';
        k(:,:,pp+6) = d';

        if pp == 0
%%%          figure(2); plot(fr,exp(-d(1,:)),fr,exp(-(d(1,:)-dO2N2(1,:))),'r'); hold on; pause(0.1); % disp('ret to continue');   
          figure(2); plot(fr,exp(-d(1,:))); hold on; pause(0.1); % disp('ret to continue');   
        end
      end
    end                 %% loop over temperature (1..11) pp

    if iSave == 11
      fprintf(1,'saving %s \n',fout);
      saver = ['save ' fout ' fr gid k ' ];
      eval(saver);
    else
      fprintf(1,'file(s) too small : gasID freq size iSave = %3i %6i %8i %2i\n',gid,fmin,lser.bytes,iSave);
    end  %% if
  else
    fprintf(1,'%s already exists .... \n',fout)
  end

  fmin = fmin + dv;
end                   %% loop over freq

figure(2); hold off;
