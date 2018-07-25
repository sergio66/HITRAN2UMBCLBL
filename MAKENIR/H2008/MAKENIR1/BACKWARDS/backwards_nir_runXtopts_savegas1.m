nbox = 5;
pointsPerChunk = 10000;
gases = [1];

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

wnNIR1 = 2805;
wnNIR2 = 3330 - 25;

cd /home/sergio/SPECTRA

load /home/sergio/abscmp/refproTRUE.mat

fmax = wnNIR2; 
topts = runXtopts_params_smart(fmax); 
dv = topts.ffin*nbox*pointsPerChunk;

%% override this, see runXtopts_params_smart.m
topts = runXtopts_params_smart(2205)
dv = topts.ffin*nbox*pointsPerChunk;

while fmax >= wnNIR1
  topts = runXtopts_params_smart(fmax);
  dv = topts.ffin*nbox*pointsPerChunk;

  %% override this, see runXtopts_params_smart.m
  topts = runXtopts_params_smart(2205)
  dv = topts.ffin*nbox*pointsPerChunk;

  fmin = fmax - dv;
  for pp = -5 : +5
    gg = 1;
    fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
    gasid = gg;  

    tprof = refpro.mtemp + pp*10;
    for mm = 1 : 5
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*poffset(mm)  tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) '_' num2str(pp+6) '_' num2str(mm)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

      topts.CKD = -1;
      [w,d] = run8water(gasid,fmin,fmax,fip,topts);  

      fout = ...
        ['/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/std' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
      saver = ['save ' fout ' w d '];
      eval(saver);
      end             %% loop over partial pressure
    end               %% loop over temperature (1..11)
  fmax = fmax - dv;
  end                 %% loop over freq

