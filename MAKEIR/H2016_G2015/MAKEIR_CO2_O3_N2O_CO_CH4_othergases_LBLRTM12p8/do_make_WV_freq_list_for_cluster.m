%% you need this file, as it is read in by "clust_runXtopts_savegasN_fileX.m" and then parsed according to JOBID

gg = 1;
fid = fopen('file_parallelprocess_wv.txt','w');

for pp = 1 : 5
  for tt = 1 : 11
    str = [num2str(gg,'%02d') '00605' num2str(tt,'%02d') num2str(pp,'%01d')];
    fprintf(fid,'%s \n',str);
  end
end  
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NEW SOOOO SMART

fid = fopen('run_wv_all_script.sc','w');
str = ['/bin/rm slurm*.out;'];
fprintf(fid,'%s \n',str);

iCnt = 1;
ggg = 1;
  %iCnt = iCnt + 1;
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_job_WV.sbatch'];
  fprintf(fid,'%s \n',str);

ggg = 2;
  %iCnt = iCnt + 1;
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_job_WV_2.sbatch'];
  fprintf(fid,'%s \n',str);

ggg = 3;
  %iCnt = iCnt + 1;
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
   str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_job_WV_3.sbatch'];
  fprintf(fid,'%s \n',str);

ggg = 4;
  %iCnt = iCnt + 1;
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_job_WV_4.sbatch'];
  fprintf(fid,'%s \n',str);

ggg = 5;
  %iCnt = iCnt + 1;
  inds = (1:11) + (ggg-1)*11;
  i1 = inds(1);
  i2 = inds(end);
  if iCnt == 1
    strtime = ' ';
  else
    strtime = ['-d singleton'];
  end
  str = ['sbatch --array=' num2str(i1) '-' num2str(i2) ' ' strtime ' sergio_matlab_job_WV_5.sbatch'];
  fprintf(fid,'%s \n',str);

fclose(fid);

