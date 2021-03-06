%% this simply does all wavenumbers for g1

% local running to test
% clustcmd -L clust_runXtopts_savegas1_file.m '010060501'
%
% otherwise when happy
% clustcmd -q medium -n 64 clust_runXtopts_savegas1_file.m g1_list.txt
%
% or
% clustcmd -q long_contrib -n 64 clust_runXtopts_savegas1_file.m g1_list.txt

%% file will contain AB CDE.G HI  which are gasID, wavenumber, temp offset   
%%                   12 345.7 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
  %% warning here we could have eg 01 082.5 06   ie we are interested in [gas 01] [greq 82.5] [toffset 06]
Stoffset = str2num(JOB(8:9)); Spp = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = [1];  gid = 1;

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

freq_boundaries

cd /home/sergio/SPECTRA

%% qtips04.m : for water the isotopes are 161  181  171  162  182  172
%% so HDO = HOD = 162

%% don't need concept of JOB for G1 (so few chunks) but let us prototype anyway
fmin0 = fmin;

if Schunk >= fmin0
  fmin = Schunk;
else
  Schunk
  disp('the start wavnumber is SMALLER than fmain = 1105 cm-1 so quit')
  return
end

%% qtips04.m : for water the isotopes are 161  181  171  162  182  172
%% so HDO = HOD = 162
while fmin <= wn2
  fmax = fmin + dv;
  for pp = Spp
    gg = 1;
    gg = Sgid;
    fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
    gasid = gg;  

    tprof = refpro.mtemp + pp*10;
    for mm = 1 : 5

      iYes = findlines_plot(fmin-dv,fmax+dv,1); 

      fout = [dirout '/stdH2O' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
      if exist(fout,'file') == 0 & iYes > 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
        profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*poffset(mm)  tprof refpro.gamnt(:,gg)]';
        fip = ['IPFILES/std_gx' num2str(gg) 'x_' num2str(pp+6) '_' num2str(mm)];
        fid = fopen(fip,'w');
        fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
        fclose(fid);

        topts.CKD = -1;
        % topts.which_isotope = [1 2 3 4 5 6];; %% use isotopes all
        % topts.which_isotope = [1 2 3   5 6];; %% use all EXCEPT isotope 4 = HDO
        % topts.which_isotope = [-1 4];;        %% use all isotopes except 4 = HDO
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  

        fout = [dirout '/stdH2O' num2str(fmin)];
        fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
      elseif exist(fout,'file') > 0 & iYes > 0
        fprintf(1,'file %s already exists \n',fout);
      elseif exist(fout,'file') == 0 & iYes < 0
        fprintf(1,'no water lines for chunk starting %8.6f \n',fmin);
      end
    end             %% loop over partial pressure
  end               %% loop over temperature (1..11)
  fmin = fmin + dv;
  %% one chunk is enough
  return
end                 %% loop over freq

