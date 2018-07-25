nbox = 5;
pointsPerChunk = 10000;
gases = [1];

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

load /home/sergio/abscmp/refproTRUE.mat

freq_boundaries

cd /home/sergio/SPECTRA

while fmin <= wn2
  fmax = fmin + dv;
  for pp = -5 : +5
    gg = 1;
    fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
    gasid = gg;  

    tprof = refpro.mtemp + pp*10;
    for mm = 1 : 5

      fout = [dirout '/g1/std' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
      if exist(fout,'file') == 0
        profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*poffset(mm)  tprof refpro.gamnt(:,gg)]';
        fip = ['IPFILES/std_gx' num2str(gg) '_' num2str(pp+6) '_' num2str(mm)];
        fid = fopen(fip,'w');
        fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
        fclose(fid);

        topts.CKD = -1;
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  

        saver = ['save ' fout ' w d '];
        eval(saver);
      else
        fprintf(1,'file %s already exists \n',fout);
        end
      end             %% loop over partial pressure
    end               %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                 %% loop over freq

