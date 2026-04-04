if ~exist('JOBB')
  JOBB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
end
if length(JOBB) == 0
  JOBB = 1;
  JOBB = 9;  
  JOBB = 11;
  JOBB = 5;
end  

JOB = JOBB;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/SPECTRA/CKDLINUX
Sgid     = 07;
Schunk   = 605;
Stoffset = JOB; Stt = Stoffset - 6;
tt = Stt;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

load_refprof

adderpath
addpather = ['addpath ' outputdirToffALL '/Toff_' num2str(Stoffset,'%02d')]; eval(addpather);

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;

set_the_freq_boundaries  %%% make sure you do this!!!!!

if gid ~= 07
  error('this is only for gid = 07')
end

cd /home/sergio/SPECTRA/CKDLINUX/MT_CKD-4.3/run_example/

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = Schunk;
%% fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
end

% wn2 = Schunk + 25; %%  <<<<<<<<<< %%% this is new!!! so that we can only do 25 cm-1 at a time

o2range = [1280        1840];  %% CKD continuum dies at 1350 cm-1, but HITRAN2024 says there are weal lines at 1290 cm-1
n2range = [1997.790    2900];
n2range = [1930.00     2900];  %% CKD continuum dies at 1997 cm-1, but HITRAN2024 says there are weal lines at 1930 cm-1

if gid == 22
  gasYESrange = n2range;
else
  gasYESrange = o2range;
end  

Pall  = refpro.mpres;
Qall  = refpro.gamnt(:,gid);
PPall = refpro.gpart(:,gid);

Tall  = refpro.mtemp;
Tall  = Tall + tt*10;

LenCell = convert_input_run8prof_to_gas_cell_length(Pall,PPall,Tall,Qall);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while fmin <= wn2
  fmax = fmin + dv;
  w = (1:10000);
  w = (w-1)*0.0025 + fmin;
  
  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  %% should really be gid but put 1 since this is O2/N2 continuum which goe way beyond the few lines
  %%  1300-1800 cm-1 for O2, peaking at 1550 cm-1
  %%  1850-2650 cm-1 for N2, peaking at 2350 cm-1
  if (fmin <= gasYESrange(2) & fmax >= gasYESrange(1))
    iYes = 1;
  else
    iYes = -1;
  end

  fout = [dirout '/std' num2str(fmin)];
  fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat']

  if exist(fout,'file') == 0 & iYes > 0
    toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
    eval(toucher);

    cder = ['cd /home/sergio/SPECTRA/CKDLINUX/MT_CKD-4.3/run_example/']; eval(cder);

    for ll = 1 : 100
      fip = ['temp_o2input_' num2str(JOBB)];    
      fid = fopen(fip,'w');
      fxout = dowrite_n2_or_o2_new(fid,gid,ll,fmin,fmax,JOBB,Pall*1013.25,Tall,PPall*1013.25,LenCell);      
      fclose(fid);

      fprintf(1,'for CKD4.3 O2/N2 cntnm_sergio_v4.3_linux_gnu_dbl fip,fxout = %s %s \n',fip,fxout);
      str = ['!../cntnm_sergio_v4.3_linux_gnu_dbl < ' fip];
      eval(str)
      junk = read_MT_CKD4p3_sergio(fxout);
      rmer = ['!/bin/rm ' fxout ' ' fip]; eval(rmer)
      
      w1 =  junk.data(:,1);
      od1 = junk.data(:,2);      
      d(:,ll) = interp1(w1,od1,w,[],'extrap');      
      bad = find(w < gasYESrange(1) | w > gasYESrange(2)); d(bad,ll) = 0.0;
    end
    cder_here
     
    saver = ['save ' fout ' w d'];
    eval(saver);
  elseif exist(fout,'file') > 0 & iYes > 0
    fprintf(1,'file %s already exists \n',fout);
  elseif exist(fout,'file') == 0 & iYes < 0
    fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
  end
  
  fmin = fmin + dv;
%  %% one chunk is enough
%  return
  cder_here
end                 %% loop over freq

cder_here
