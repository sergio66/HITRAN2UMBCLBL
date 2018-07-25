%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% water isotopes are 161  181  171  XX162XX  182  172
%% where 162 is HDO

%% runXtopts_savegas1_special is for 1105-1430 and 2405-2830 cm-1 
%%   where we use only isotopes 161  181  171  182  172

%% runXtopts_savegas103 will do the same bands, but isotope 162 only

%% runXtopts_savegas1_allisotopes will do 605-1105,1430-2405,2830 onwards
%%   for all isotopes 161  181  171  162  182  172
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbox = 5;
pointsPerChunk = 10000;
gases = [102];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

%time_pause = ceil(rand*100);
time_pause = 1;
pause(time_pause)

freq_boundaries_continuum

allfreqchunks = 605 : 25 : 2830-25;

dirout0 = dirout;

cd /home/sergio/SPECTRA

for iido = 1 : length(allfreqchunks)
  fmin = allfreqchunks(iido);
  fmax = fmin + dv;

  for pp = -5 : +5

    gg = 1;
    gasid = gases;  
    fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

    tprof = refpro.mtemp + pp*10;

    dirout = [dirout0 '/g' num2str(gasid) '.dat/'];

    fout = [dirout '/stdFORN' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
    if exist(fout,'file') == 0 
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      %%% we need nonzero partial pressures and nonzero amts
      profile = [(1:100)' refpro.mpres refpro.mpres*1e-2 tprof refpro.mpres*1e-5]';
      fip = ['IPFILES/std_gx' num2str(gasid) '_' num2str(pp+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

loc = 0;
quick.CKD  = CKD;
quick.local= loc;
quick.ffin = dv/pointsPerChunk;
quick.nbox = nbox;
quick.nbox = 1;
quick.divide   = 1;
quick.selfmult = 0;
quick.formult  = 1;
      [w,d] = run8watercontinuum(1,fmin,fmax,fip,quick);

      fout = [dirout '/stdFORN' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
      saver = ['save ' fout ' w d '];
      eval(saver);

    elseif exist(fout,'file') > 0 
      fprintf(1,'file %s already exists \n',fout);
      end

    end               %% loop over temperature (1..11)
  end                 %% loop over freq

