%% this simply does all wavenumbers for g1

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 1

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999


%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('gN_ir_list.txt');
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end
  
Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));  
Stoffset = str2num(XJOB(8:9)); Stt = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;
freq_boundaries

cd /home/sergio/SPECTRA

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = Schunk;
%% fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

wn2 = Schunk + 25; %%  <<<<<<<<<< %%% this is new!!! so that we can only do 25 cm-1 at a time

while fmin <= wn2
  fmax = fmin + dv;

  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  for tt = Stt
    tprof = refpro.mtemp + tt*10;

    iYes = findlines_plot(fmin-dv,fmax+dv,1); 

    fout = [dirout '/wobasement_std' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat']

    if exist(fout,'file') == 0 & iYes > 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

      topts.tsp_mult = -1;
      topts.LVG = 'W';
      [w,d] = run8(gasid,fmin,fmax,fip,topts);  

      saver = ['save ' fout ' w d '];
      eval(saver);
    elseif exist(fout,'file') > 0 & iYes > 0
      fprintf(1,'file %s already exists \n',fout);
    elseif exist(fout,'file') == 0 & iYes < 0
      fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
    end
  end               %% loop over temperature (1..11)
  fmin = fmin + dv;
  %% one chunk is enough
  return
end                 %% loop over freq

