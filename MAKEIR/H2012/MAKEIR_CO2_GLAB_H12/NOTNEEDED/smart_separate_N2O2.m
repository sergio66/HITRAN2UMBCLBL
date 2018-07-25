%% assumes everything done by clust_runXtopts_savegasN_file_N2O2only.m has been moved to
%% /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtmN2O2/

iO2 = input('do O2 (-1/+1) : ');
if iO2 > 0
  nbox = 5;
  pointsPerChunk = 10000;

  gid = 7;
  freq_boundaries
  dirTEMP = [dirout '/TEMP'];
  dirO2_umbc = findstr('/lbl',dirout); dirO2_umbc = dirout(1:dirO2_umbc);

  iYes = 0;
  iNo = 0;
  thedir = dir([dirO2_umbc '*.mat']);
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
  dirN2_umbc = findstr('/lbl',dirout); dirN2_umbc = dirout(1:dirN2_umbc);

  iYes = 0;
  iNo = 0;
  thedir = dir([dirN2_umbc '*.mat']);
  fprintf(1,'expecting to find %3i files for N2 = %2i chunks \n',length(thedir),length(thedir)/11)
  for ii = 1 : length(thedir)
    xyz = thedir(ii).bytes;
    fname = thedir(ii).name;   %% this woulod be of the form eg std2730_22_9.mat
    
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
