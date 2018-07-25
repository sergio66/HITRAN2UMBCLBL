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
gases = [1];

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

time_pause = ceil(rand*100);
%time_pause = 1;
pause(time_pause)

freq_boundaries_new

iWV_Type = +0;      %% this is the special WV : all isotopes but 162
allfreqchunks = 605 : 25 : 2830-25;
hdochunks = [];
for ii = 1 : iNumBands
  wn1 = wn1all(ii);
  wn2 = wn2all(ii);
  xx = wn1 : 25 : wn2;
  hdochunks = [hdochunks xx];
  end
hdochunks = sort(hdochunks);  %% do all chunks beginning with this
%% these frequencies tally up with those in
%% /asl/s1/sergio/xRUN8_NIRDATABASE/IR_2405_3005_WV/fbin/h2o.ieee-le

dirout0 = dirout;

cd /home/sergio/SPECTRA

%% qtips04.m : for water the isotopes are 161  181  171  162  182  172
%% so HDO = HOD = 162
for iido = 1 : length(hdochunks)
  fmin = hdochunks(iido);
  fmax = fmin + dv;
  for pp = -5 : +5
    gg = 1;
    fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
    gasid = gg;  

    tprof = refpro.mtemp + pp*10;
    for mm = 1 : 5

      iYes = findlines_plot(fmin-25,fmax+25,1); 

      dirout = [dirout0 '/g' num2str(gasid) '.dat/'];

      fout = [dirout '/stdH2O' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
      if exist(fout,'file') == 0 & iYes > 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
        profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*poffset(mm)  tprof refpro.gamnt(:,gg)]';
        fip = ['IPFILES/std_gx' num2str(gg) '_' num2str(pp+6) '_' num2str(mm)];
        fid = fopen(fip,'w');
        fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
        fclose(fid);

        topts.CKD = -1;
        topts.which_isotope = [-1 4];; %% use all isotopes except 4 = HDO
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
  %fmin = fmin + dv;
  end                 %% loop over freq

