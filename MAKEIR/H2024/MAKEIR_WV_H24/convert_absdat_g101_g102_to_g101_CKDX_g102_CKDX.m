%% this simply does all wavenumbers for gN
%% to put the Toffset chunks together before compression into /asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/abs.dat, run this with
%%   sbatch --array=1-42 sergio_matlab_makegas3_42.sbatch 3

%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath0

home = pwd;

%gid = input('Enter gasID : ');
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 101;  
  JOB = 102;
end

gid = JOB;
if gid ~= 101 & gid ~= 102
  error('this is SELF/FORN continuum')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbox = 5;
pointsPerChunk = 10000;
freq_boundaries_continuum

%%%%%%%%%%%%%%%%%%%%%%%%%
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = 1; %% always find continuum

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

dirout = [dirout '/g' num2str(JOB) '.dat/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fout = [diroutXN '/abs.dat'];

ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  iAns = -1;  %% this should have been made!!!!!!
  if iAns == 1
    mker = ['!mkdir ' fout];
    eval(mker);
  else
    error('cannot proceed');
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2); clf;
fmin = wn1; 
fmin = iaChunk(1);
while fmin <= iaChunk(end)
  fmax = fmin + dv;

  iSave = 0;
  fr = [];
  k = zeros(10000,100,11);

  fout1 = [diroutXN '/abs.dat/g' num2str(gid) 'v' num2str(fmin) '.mat'];
  fout2 = [diroutXN '/abs.dat/g' num2str(gid) 'v' num2str(fmin) '_CKD_' num2str(CKD) '.mat'];  

  if exist(fout1)
    mver = ['!mv ' fout1 ' ' fout2];
    fprintf(1,'%4i %s \n',fmin,mver)
    eval(mver)
  end

  fmin = fmin + dv;
end
