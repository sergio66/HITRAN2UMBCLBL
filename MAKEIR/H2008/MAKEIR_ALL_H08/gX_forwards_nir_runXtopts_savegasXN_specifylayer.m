cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08'];
eval(cder);

nbox = 5;
pointsPerChunk = 10000;

time_pause = ceil(rand*100);
pause(1)

freq_boundaries

xgasid = input('Enter GasId (3-32) : ')
hpcfname = num2str(xgasid);
iLayer = input('enter layer : ');

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

wn1 = startchunk;

%load /home/sergio/HITRAN2UMBCLBL/refpro3.mat       %% Howards, 2008
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat    %% latest

fmin = wn1; 
fmax = wn2; 

cd /home/sergio/SPECTRA

dirout0 = dirout;

wn1 = input('Enter start chunk : ');
wn2 = input('Enter stop  chunk : ');
fmin = wn1;
fprintf(1,'processing gasid with startchunk = %3i %8.4f \n',gases,fmin);

while fmin <= wn2
  fmax = fmin + dv;
%  for pp = -5 : +5
  for pp = 0 : 0
    wfreq0 = [];
    dkcomp0 = zeros(1,10000);
    for gg = 1 : length(gases)
      gasid = gases(gg);  
      fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

      if gasid == 1 | gasid == 2
        error('should run WATER or CO2 separately')
        end

      gq = gasid;
      tprof = refpro.mtemp + pp*10;
      profile = ...
        [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';
      profile = profile(:,iLayer);

      cd /home/sergio/SPECTRA
      fip = ['IPFILES/test_std_gx' num2str(gq) '_' num2str(pp+6)];
      fid = fopen(fip,'w');
%      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fprintf(fid,'%3i %10.8e %10.8e %7.3f %10.8e \n',profile);
      fclose(fid);

      dirout = [dirout0 '/g' num2str(gasid) '.dat/'];

      fout = [dirout '/notranspose_test_std' num2str(fmin)];
      fout = [fout '_' num2str(gq) '_' num2str(pp+6) '_' num2str(iLayer) '.mat'];  %% default lineshape
      ee = exist(fout,'file')

      if ee > 0
        fprintf(1,'%s already exists \n',fout);
      else
        fprintf(1,'%s created .... \n',fout);
        end

      iYes = findlines_plot(fmin-25,fmax+25,gasid); 
      d = zeros(1,10000);

      if gasid > 1 & iYes > 0 & ee == 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
        eval(toucher);
        fprintf(1,'g,w1,w2,toffset = %3i %6i %6i %2i\n',gasid,fmin,fmax,pp);
        [w,d] = run8(gasid,fmin,fmax,fip,topts);  
        saver = ['save ' fout ' w d iLayer'];
        eval(saver);
        end

      end               %% loop over gas
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08'];
eval(cder);