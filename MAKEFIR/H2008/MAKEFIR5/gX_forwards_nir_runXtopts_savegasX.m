addpath /asl/matlab/aslutil

nbox = 5;
pointsPerChunk = 10000;

time_pause = ceil(rand*100);
pause(time_pause)
%pause(1)       %% <<<<<<------

freq_boundaries

clear gases
dash = findstr(hpcfname,'_');
if length(dash) == 0
  gases = str2num(hpcfname);
elseif length(dash) == 1
  gases(1) = str2num(hpcfname(1:dash-1));
  gases(2) = str2num(hpcfname(dash+1:length(hpcfname)));
else
  error('error in hpcfname')
  end

woof = isfinite(gases);
if sum(woof) ~= length(gases)
  error('error2 in hpcfname')
  end

if length(gases) == 1
  %% user forgot to put in start chunk
  gases = gases(1);
  startchunk = wn1;
else
  startchunk = gases(2);
  gases = gases(1);
  end
fprintf(1,'processing gasid with startchunk = %3i %8.4f \n',gases,startchunk);

wn1 = startchunk;

load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

fmin = wn1; 
fmax = wn2; 

cd /home/sergio/SPECTRA

dirout0 = dirout;

if length(intersect(gases,1)) == 1
  error('do not use gX_forwards_nir_runXtopts_savegasX for WV');
end

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

      fout = [dirout '/std' num2str(fmin)];
      fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
      ee = exist(fout,'file');
      if ee > 0
        fprintf(1,'%s already exists \n',fout);
        end

      iYes = findlines_plot(fmin-25,fmax+25,gasid); 
      d = zeros(100,10000);

%      if gasid == 1 & iYes > 0 & ee == 0
%        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
%        eval(toucher);
%        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  

      if gasid > 1 & iYes > 0 & ee == 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
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
  fmin = fmin + dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR5