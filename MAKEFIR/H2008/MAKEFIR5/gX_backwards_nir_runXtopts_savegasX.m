airs_nodes

nbox = 5;
pointsPerChunk = 10000;

%%% gases = 9; <<<<<<<<<<<<<<<----------------------------
gases = load('gidfname');
fprintf(1,'processing gasid = %3i \n',gases);
rmer = ['!/bin/rm gidfname']; eval(rmer);

freq_boundaries

load /home/sergio/abscmp/refproTRUE.mat

fmax = wn2; 
fmax = wn2 + dv; 

cd /home/sergio/SPECTRA

while fmax >= wn1
  fmin = fmax - dv;
  for pp = +5 : -1 : -5    %%% flipped from -5 : +5 as we are going backwards!
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

      fout = [dirout '/std' num2str(fmin)];
      fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
      ee = exist(fout,'file');
      if ee > 0
        fprintf(1,'%s already exists \n',fout);
        end

      iYes = findlines_plot(fmin-25,fmax+25,gasid); 
      d = zeros(100,10000);
      if gasid == 1 & iYes > 0 & ee == 0
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  
      elseif gasid > 1 & iYes > 0 & ee == 0
        fprintf(1,'g,w1,w2,toffset = %3i %6i %6i %2i\n',gasid,fmin,fmax,pp);
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
  fmax = fmax - dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR2