%% this simply does all wavenumbers for gN, loops over 11 T and reads  gN_ir_listN_T11.txt instead of gN_ir_list.txt
%% so it only does one gas, one chunk, all 11 Toffset

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this simply does all wavenumbers for gN
%% to make the individual chuncks/gases into eg /asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/gX.dat, run this with 
%%   sbatch --array=1-20000%256 --output='/dev/null' sergio_matlab_chip_makegas3_42.sbatch     or
%%   sbatch --array=1-20000%256                      sergio_matlab_chip_makegas3_42.sbatch 1    or
%% but first make sure you run
%%  loop_filelist_gN             to make initial filelist for all gases 
%% then as time goes on run
%%  loop_filelist_gN_missing     to make missing filelist
%% 
%% and check progress using
%%  loop_gas_done_already
%%
%% compare against previous database using eg
%%  compare_mol_H2016_H2020_indchunks.m    for individual chunks
%%  compare_mol_H2016_H2020_allchunks.m    for allchunks chunks

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 1;
end

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('gN_ir_listN_T11.txt');
%% this should be 7 digit code  (gasID=2digit,wavenumberchunk=5digit)
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 6
  XJOB = ['0' num2str(gasIDlist(JOB))];
end
fprintf(1,'JOB = %3i XJOB = %s \n',JOB,XJOB);

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));  
%% Stoffset = str2num(XJOB(8:9)); Stt = Stoffset - 6;

nbox = 5;
pointsPerChunk = 10000;
gases = Sgid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

addpath0

gg    = Sgid;
gasid = Sgid;  
gid   = Sgid;
freq_boundaries

cd /home/sergio/SPECTRA

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmin0 = 1105 cm-1 so quit')
  return
end

%while fmin <= fmax
fminxyz = fmin;
while fmin <= fminxyz
  fmax = fmin + dv;

  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  for xtt = 1 : 11
    fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i .. doing T offset %2i of 11 \n',XJOB,Sgid,Schunk,xtt);

    tt = xtt - 6;
    tprof = refpro.mtemp + tt*10;

    iYes = findlines_plot(fmin-dv,fmax+dv,gasid); 

    fout = [dirout '/std' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '.mat'];

    if exist(fout,'file') == 0 & iYes > 0
      fprintf(1,'% making %s \n',fout)
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      fip = ['/home/sergio/SPECTRA/IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

      [w,d,hitran_fname] = run8(gasid,fmin,fmax,fip,topts);  

      saver = ['save ' fout ' w d '];
      eval(saver);
    elseif exist(fout,'file') > 0 & iYes > 0
      fprintf(1,'file %s already exists \n',fout);
    elseif exist(fout,'file') == 0 & iYes < 0
      fprintf(1,'no lines for chunk starting %8.6f \n',fmin);
    end
  end               %% loop over temperature (1..11)
  fmin = fmin + dv; %% this is a bit irrelevant since ff loop is fmin : fmin 
end                 %% loop over freq

fprintf(1,'FINISHED clust_runXtopts_savegasN_file_11T.m : JOB = %4i done, used hitran_fname = %s \n',hitran_fname);

cder_home
