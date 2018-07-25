%% you need this file, as it is read in by "clust_runXtopts_savegasN_fileX.m" and then parsed according to JOBID
fid = fopen('file_parallelprocess_allgases.txt','w');
for ggg = 1 : length(gid)
  gg = gid(ggg);
  for tt = 1 : 11
    str = [num2str(gg,'%02d') '00605' num2str(tt,'%02d')];
    str = [num2str(gg,'%02d') '02005' num2str(tt,'%02d')];
    str = [num2str(gg,'%02d') fminSTR num2str(tt,'%02d')];        
    fprintf(fid,'%s \n',str);
  end
end  
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%% ORIG, give one hour, WASTE
fid = fopen('run_big_script.sc','w');
iCnt = 0;
deltat_min = 30;            %% job spacing in minutes
deltat_hour = deltat_min/60;; %% job spacing in hours
for ggg = length(gid) : -1 : 1
  iCnt = iCnt + 1;
  gg = gid(ggg);
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['--begin=now+' num2str((ggg-1)*deltat_hour) 'hour'];
    strtime = ['--begin=now+' num2str((iCnt-1)*deltat_min) 'minutes'];    
  end
  str = ['/bin/rm slurm*.out; sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_jobB.sbatch'];
  fprintf(fid,'%s \n',str);
end  
fclose(fid);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NEW SOOOO SMART
fid = fopen('run_big_script.sc','w');
str = ['/bin/rm slurm*.out;'];
fprintf(fid,'%s \n',str);
iCnt = 0;
for ggg = length(gid) : -1 : 1
  iCnt = iCnt + 1;
  gg = gid(ggg);
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_jobB.sbatch'];
  fprintf(fid,'%s \n',str);
end  
fclose(fid);

fid = fopen('run_big_script_2.sc','w');
str = ['/bin/rm slurm*.out;'];
fprintf(fid,'%s \n',str);
iCnt = 0;
for ggg = length(gid) : -1 : 1
  iCnt = iCnt + 1;
  gg = gid(ggg);
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_jobB_2.sbatch'];
  fprintf(fid,'%s \n',str);
end  
fclose(fid);

fid = fopen('run_big_script_3.sc','w');
str = ['/bin/rm slurm*.out;'];
fprintf(fid,'%s \n',str);
iCnt = 0;
for ggg = 1 : length(gid)
  iCnt = iCnt + 1;
  gg = gid(ggg);
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
   str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_jobB_3.sbatch'];
  fprintf(fid,'%s \n',str);
end  
fclose(fid);

fid = fopen('run_big_script_4.sc','w');
str = ['/bin/rm slurm*.out;'];
fprintf(fid,'%s \n',str);
iCnt = 0;
for ggg = 1 : length(gid)
  iCnt = iCnt + 1;
  gg = gid(ggg);
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_jobB_4.sbatch'];
  fprintf(fid,'%s \n',str);
end  
fclose(fid);

