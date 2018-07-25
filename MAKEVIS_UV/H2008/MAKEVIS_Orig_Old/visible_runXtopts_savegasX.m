nbox = 5;
pointsPerChunk = 10000;
gases = [1 2 3 4 5 6 7];

%%%% to do things for MODIS vis
wnVIS = [4650 6095 8065 11550 15150 18150 20055 21250];
wnVIS = [4650 6095 8065 11550 15150 18150 20055 21250] - 12.5;
wnVIS1 = 4500;
wnVIS1 = 6050;
wnVIS2 = 22000;

%%% sims for NIR tests
wnVIS1 = 4000;
wnVIS2 = 4500;

wnVIS1 = 4250;
wnVIS2 = 4350;

load /home/sergio/abscmp/refproTRUE.mat

fmin = wnVIS1; 
topts = runXtopts_params_smart(fmin); 
dv = topts.ffin*nbox*pointsPerChunk;

while fmin <= wnVIS2
  topts = runXtopts_params_smart(fmin);
  dv = topts.ffin*nbox*pointsPerChunk;
  fmax = fmin + dv;
  for pp = -5 : +5
    wvis0 = [];
    dvis0 = zeros(100,10000);
    for gg = 1 : length(gases)
      fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
      gasid = gg;  

      tprof = refpro.mtemp + pp*10;
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      fip = ['IPFILES/std_gx' num2str(gg) '_' num2str(pp+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

      if gasid == 1
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  
      else
        [w,d] = run8(gasid,fmin,fmax,fip,topts);  
      end

      fout = ...
        ['/carrot/s1/sergio/RUN8_VISDATABASE/VIS4000_4500/std' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '.mat'];
      saver = ['save ' fout ' w d '];
      eval(saver);

      wvis0 = w;
      dvis0 = dvis0 + d;

      fout = ['/carrot/s1/sergio/RUN8_VISDATABASE/std' num2str(fmin) '_' num2str(pp+6) '.mat'];
      saver = ['save ' fout ' wvis0 dvis0 '];
      eval(saver);      %% loop over gas
      end
    fout = ['/carrot/s1/sergio/RUN8_VISDATABASE/std' num2str(fmin) '_' num2str(pp+6) '.mat'];
    saver = ['save ' fout ' wvis0 dvis0 '];
    eval(saver);
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

