airs_nodes
iDoJob = 2;

nbox = 5;
pointsPerChunk = 10000;
gases = 2:32;
gases = [iDoJob*2-1 iDoJob*2]

if iDoJob == 1
  gases = [2 31 32];   %% water is done separate, and node 32 = dead
  end

gases = 6;

wnNIR1 = 2805;
wnNIR2 = 3330 - 25;

load /home/sergio/abscmp/refproTRUE.mat

fmax = wnNIR2; 
topts = runXtopts_params_smart(fmax); 
dv = topts.ffin*nbox*pointsPerChunk;

while fmax >= wnNIR1
  topts = runXtopts_params_smart(fmax)
  dv = topts.ffin*nbox*pointsPerChunk;
 
  %% override this, see runXtopts_params_smart.m
  topts = runXtopts_params_smart(2205)
  dv = topts.ffin*nbox*pointsPerChunk;

  fmin = fmax - dv;
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
      d = zeros(100,10000);
      if gasid == 1 & iYes > 0
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  
      elseif gasid > 1 & iYes > 0
        fprintf(1,'g,w1,w2,toffset = %3i %6i %6i %2i\n',gasid,fmin,fmax,pp);
        [w,d] = run8(gasid,fmin,fmax,fip,topts);  
      end

      if iYes > 0
        fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/std'];
        fout = [fout num2str(fmin)];
        fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
        end

%      wfreq0 = w;
%      dkcomp0 = dkcomp0 + d;

      fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/std'];
      fout = [fout num2str(fmin) '_' num2str(pp+6) '.mat'];
%      saver = ['save ' fout ' wfreq0 dkcomp0 '];
%      eval(saver);      
      end               %% loop over gas
    fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/std' ];
    fout = [fout num2str(fmin) '_' num2str(pp+6) '.mat'];
%    saver = ['save ' fout ' wfreq0 dkcomp0 '];
%    eval(saver);
    end                 %% loop over temperature (1..11)
  fmax = fmax - dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKENIR