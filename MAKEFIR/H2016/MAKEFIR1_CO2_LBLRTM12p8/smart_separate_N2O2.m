addpath /home/sergio/SPECTRA
clear all

disp(' >>>>  assumes everything done by clust_runXtopts_savegasN_file_N2O2only.m has been moved to')
disp(' >>>>  /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtmN2O2backup/ as a backup copy');
disp(' ')

nbox = 5;
pointsPerChunk = 10000;

woosh = 'lblrtmN2O2';
woosh = 'TEMP';

gid = 7;
freq_boundaries
thedir0 = dir([dirout '/*.mat']);
fprintf(1,'found %3i files in ORIG place made by clust_runXtopts_savegasN_file_N2O2only.m \n (%s) \n',length(thedir0),dirout);
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%
%% first check to see if things have been backed up 

backupDir = findstr('/g7.dat',dirout); backupDir = ([dirout(1:backupDir+7) 'lblrtmN2O2backup/']);
backdir = dir([backupDir '/*.mat']);
fprintf(1,'found %3i files in BACKUP dir \n (%s) \n',length(backdir),backupDir);
disp(' ');

iO2N2 = input('copy files from orig->backup? (-1/+1) : ');
if iO2N2 > 0
  cper = ['!/bin/cp -a ' dirout '/*.mat ' backupDir '.'];
  eval(cper)
end

%%%%%%%%%%%%%%%%%%%%%%%%%

%% now cp the lblrtm files to g7.dat/lblrtm/TEMP abnd g22.dat/lblrtm/TEMP

%thedirX = dir('/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm2/TEMP/');
dirX = findstr('/g7.dat',dirout); dirX = ([dirout(1:dirX+7) woosh '/']); dirX = [dirout '/' woosh '/'];
thedirX = dir([dirX '/*.mat']);
fprintf(1,'found %3i files moved to O2 temp place \n (%s) \n',length(thedirX),dirX);
%lser = ['!ls -lt ' dirX '/*.mat'];
%eval(lser);
disp(' ')

dirY = findstr('/g7.dat',dirX); dirY = ([dirout(1:dirY) '/g22.dat/' dirX(dirY+8:end)]);
thedirY = dir([dirY '/*.mat']);
fprintf(1,'found %3i files moved to N2 temp place \n (%s) \n',length(thedirY),dirY);
%lser = ['!ls -lt ' dirY '/*.mat'];
%eval(lser);
disp(' ')


if length(thedir0) > 0
  iO2N2 = input('move files from orig->temp place (for N2/O2)? (warning first clear .mat files from temp place and then from dirout !!!) (-1/+1) : ');
  if iO2N2 > 0
    %% cp to O2
    rmer = ['!/bin/rm ' dirX '/*.mat'];
    eval(rmer);
    mver = ['!/bin/cp -a ' dirout '/*.mat ' dirX '/.'];
    eval(mver);

    %% cp to N2
    rmer = ['!/bin/rm ' dirY '/*.mat'];
    eval(rmer);
    mver = ['!/bin/cp -a ' dirout '/*.mat ' dirY '.'];
    eval(mver);

    %% now finally blow away files from dirout, so after this script is run we only end up with few O2 files
    %% rm from dirout
    rmer = ['!/bin/rm  ' dirout '/*.mat'];
    eval(rmer);

  end
end

%{
/bin/mv /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm2/*.mat /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtmN2O2/.
/bin/cp /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtmN2O2/*.mat /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm2/.
%}

disp('ret to continue : ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iO2 = input('do O2 (-1/+1) : ');
if iO2 > 0
  nbox = 5;
  pointsPerChunk = 10000;

  gid = 7;
  freq_boundaries
  dirTEMP = [dirout '/TEMP'];
  dirO2_umbclbl_ORIG = findstr('/lbl',dirout); dirO2_umbclbl_ORIG = dirout(1:dirO2_umbclbl_ORIG);

  iYes = 0;
  iNo = 0;
  thedir = dir([dirO2_umbclbl_ORIG '*.mat']);
  fprintf(1,'expecting to find %3i files for O2 = %2i chunks \n',length(thedir),length(thedir)/11)
  for ii = 1 : length(thedir)
    xyz = thedir(ii).bytes;
    fname = thedir(ii).name;
    fexpect = [dirTEMP '/' fname];
    if exist(fexpect)
      cper = ['!/bin/cp -a ' fexpect ' ' dirout '/.'];
      eval(cper)
      iYes = iYes + 1;
    else
      iNo = iNo + 1;
    end
  end
  fprintf(1,'of the expected %3i files for O2, successfully found %3i and could not find %3i \n',length(thedir),iYes,iNo);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iN2 = input('do N2 (-1/+1) : ');
if iN2 > 0
  nbox = 5;
  pointsPerChunk = 10000;

  gid = 22;
  freq_boundaries
  dirTEMP = [dirout '/TEMP'];
  dirN2_umbclbl_ORIG = findstr('/lbl',dirout); dirN2_umbclbl_ORIG = dirout(1:dirN2_umbclbl_ORIG);

  iYes = 0;
  iNo = 0;
  thedir = dir([dirN2_umbclbl_ORIG '*.mat']);
  fprintf(1,'expecting to find %3i files for N2 = %2i chunks \n',length(thedir),length(thedir)/11)
  for ii = 1 : length(thedir)
    xyz = thedir(ii).bytes;
    fname = thedir(ii).name;   %% this would be of the form eg std2730_22_9.mat
    
    xyz = findstr('_22_',fname); 
    fnamex = [fname(1:xyz-1) '_7_' fname(xyz+4:end)];  %% this is how they were saved by clust_runXtopts_savegasN_file_N2O2only.m

    fexpect = [dirTEMP '/' fnamex];
    if exist(fexpect)
      cper = ['!/bin/cp -a ' fexpect ' ' dirout '/' fname];
      eval(cper)
      iYes = iYes + 1;
    else
      iNo = iNo + 1;
    end
  end
  fprintf(1,'of the expected %3i files for N2, successfully found %3i and could not find %3i \n',length(thedir),iYes,iNo);
end
