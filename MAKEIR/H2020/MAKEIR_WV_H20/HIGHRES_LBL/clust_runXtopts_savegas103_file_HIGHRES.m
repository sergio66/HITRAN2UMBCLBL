%% this simply does all wavenumbers for g103

% was   clustcmd -q long_contrib -n 11 clust_runXtopts_savegasN_file.m file_parallelprocess_CO2.txt
% now   sbatch --array=1-11 sergio_matlab_jobB.sbatch

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% test eg JOB='020223005'; clust_runXtopts_savegasN_file

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
% JOB = 2;
% JOB = getenv('SLURM_ARRAY_TASK_ID');
% JOB = '020060506';
theJOB = load('file_parallelprocess_HDO.txt');
JOB = theJOB(JOB);
JOB = ['0' num2str(JOB)];

%% JOB = '010086006'

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Spp = Stoffset - 6;

fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',JOB,Sgid,Schunk,Stoffset);

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
%% load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

%freq_boundaries_g1_LBL
freq_boundaries_g103_LBL

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

      iYes = findlines_plot(fmin-25,fmax+25,1); 

      fout = [dirout '/stdHDO' num2str(fmin)];
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
        topts.which_isotope = [1 2 3 4 5 6];; %% use isotopes all
        topts.which_isotope = [1 2 3   5 6];; %% use all EXCEPT isotope 4 = HDO
        topts.which_isotope = [-1 4];;        %% use all isotopes except 4 = HDO

        topts.which_isotope = [4];; %% only use isotopes 4 = HDO
	try
          [w,d] = run8water(gasid,fmin,fmax,fip,topts);  
        catch
	  warning(' >>>>>>>>> looks like no lines!!!')
          ind = 1:10000;
	  w = fmin + (ind-1)*dv/10000;
	  d = ones(100,10000)*1e-15;
	end
	
        fout = [dirout '/stdHDO' num2str(fmin)];
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
end                 %% loop over freq

