%% this simply does all wavenumbers for g1

% local running to test
% clustcmd -L clust_runXtopts_savegasN_file.m '050173001'
%
% otherwise when happy
% clustcmd -q medium -n 64 clust_runXtopts_savegasN_file.m gN_list.txt
%
% or
% clustcmd -q long_contrib -n 64 clust_runXtopts_savegasN_file.m gN_list.txt

%% file will contain AB CDE.G HI  which are gasID, wavenumber, temp offset   
%%                   12 345.7 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

home = pwd; 

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
  %% warning here we could have eg 01 082.5 06   ie we are interested in [gas 01] [greq 82.5] [toffset 06]
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

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
fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

while fmin <= wn2
  fmax = fmin + dv;

  fprintf(1,'gas freq = %3i %6i \n',gg,fmin);

  for tt = Stt
    tprof = refpro.mtemp + tt*10;

    iYes = findlines_plot(fmin-dv,fmax+dv,1); 

    fout = [dirout '/std' num2str(fmin) '_' num2str(gg) '_' num2str(tt+6) '.mat'];
    if exist(fout,'file') == 0 & iYes > 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(tt+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

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
  cder = ['cd ' home]; eval(cder);
  return
end                 %% loop over freq

cder = ['cd ' home]; eval(cder);
