airs_nodes

nbox = 5;
pointsPerChunk = 10000;
gases = 2:32;
gases = [iDoJob*2-1 iDoJob*2]

if iDoJob == 1
  gases = [2 31 32]   %% water is done separate, and node 32 = dead
  end

load /home/sergio/abscmp/refproTRUE.mat

pwd

freq_boundaries

cd /home/sergio/SPECTRA

while fmin <= wn2
  fmax = fmin + dv;
  for pp = -5 : +5
    wfreq0 = [];
    dkcomp0 = zeros(100,10000);
    for gg = 1 : length(gases)
      gasid = gases(gg);  
      fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

      if gasid == 1
        error('should run WATER separately')
        end

      gq = gasid;
      tprof = refpro.mtemp + pp*10;
      profile = ...
        [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';
      cd /home/sergio/SPECTRA
      fip = ['IPFILES/std_gx' num2str(gq) '_' num2str(pp+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

      iYes = findlines_plot(fmin-25,fmax+25,gasid); 
      fout = [dirout '/std' num2str(fmin)];
      fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
      ee = exist(fout,'file');
      if ee > 0
        fprintf(1,'%s already exists \n',fout);
        end

      d = zeros(100,10000);
      if gasid == 1 & iYes > 0 & ee == 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  
      elseif gasid > 1 & iYes > 0 & ee == 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
        [w,d] = run8(gasid,fmin,fmax,fip,topts);  
      end

      if iYes > 0 & ee == 0
        fout = [dirout '/std' num2str(fmin)];
        fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
        end

      end               %% loop over gas
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

