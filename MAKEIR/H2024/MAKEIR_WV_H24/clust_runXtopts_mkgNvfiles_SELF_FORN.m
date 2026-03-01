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
  %JOB = 102;
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

  fout = [diroutXN '/abs.dat/g' num2str(gid) 'v' num2str(fmin) '_CKD_' num2str(CKD) '.mat'];
  if exist(fout) == 0
    fprintf(1,'processing %8.2f \n',fmin)

    for tt = -5 : +5
      fin = [dirout '/std' num2str(fmin) '_' num2str(gid) '_' num2str(tt+6) '.mat'];

      if gid == 101
        fin = [dirout '/stdSELF' num2str(fmin)];
      else
        fin = [dirout '/stdFORN' num2str(fmin)];
      end
      
      %fin = [fin '_' num2str(gid) '_' num2str(tt+6) '_CKD_' num2str(CKD) '.mat'];
      fin = [fin '_' num2str(1) '_' num2str(tt+6) '_CKD_' num2str(CKD) '.mat'];      

      lser = dir(fin);
      if length(lser) == 0
        clear lser
        lser.bytes = 0;
      end
      if lser.bytes > 500000
        iSave = iSave + 1;
        fprintf(1,'  gasID freq tt = %3i %6f %3i \n',gid,fmin,tt);
        loader = ['load ' fin ];
        eval(loader);
        fr = w;
        k(:,:,tt+6) = d';
        if tt == 0
          figure(2); plot(fr,exp(-d(1,:))); hold on; pause(0.1); % disp('ret to continue');   
        end
      end
    end                 %% loop over temperature (1..11) tt

    if iSave == 11
      fprintf(1,'saving %s \n',fout);
      saver = ['save ' fout ' fr gid k ' ];
      eval(saver);
    else
      fprintf(1,'file(s) too small : gasID freq size = %s %3i %6i %8i \n',fin,gid,fmin,lser.bytes);
    end  %% if
  else
    fprintf(1,'%s already exists .... \n',fout)
  end

  fmin = fmin + dv;
end                   %% loop over freq

figure(2); hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
if needed convert names from eg
  /umbc/rs/pi_sergio/WorkDirDec2025/H2024_RUN8_NIRDATABASE/IR_605_2830//abs.dat/g101v2855.mat
to
  /umbc/rs/pi_sergio/WorkDirDec2025/H2024_RUN8_NIRDATABASE/IR_605_2830//abs.dat/g101v2855_CKD_43.mat

by calling convert_absdat_g101_g102_to_g101_CKDX_g102_CKDX
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

