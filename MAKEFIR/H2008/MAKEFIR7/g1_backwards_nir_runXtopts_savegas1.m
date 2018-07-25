nbox = 5;
pointsPerChunk = 10000;
gases = [1];

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

freq_boundaries

load /home/sergio/abscmp/refproTRUE.mat

fmin = wn1; 
fmax = wn2 + dv; 

cd /home/sergio/SPECTRA

while fmax >= wn1
  fmin = fmax - dv;
  for pp = +5 : -1 : -5      %% flipped from -5 : +5 as we are going backwards!
    gg = 1;
    fprintf(1,'gas freq = %3i %6i \n',gg,fmin);
    gasid = gg;  

    tprof = refpro.mtemp + pp*10;
    for mm = 1 : 5

      fout = [dirout '/std' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
      if exist(fout,'file') == 0
        profile = [(1:100)' refpro.mpres refpro.gpart(:,gg)*poffset(mm)  tprof refpro.gamnt(:,gg)]';
        fip = ['IPFILES/std_gx' num2str(gg) '_' num2str(pp+6) '_' num2str(mm)];
        fid = fopen(fip,'w');
        fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
        fclose(fid);

        topts.CKD = -1;
        [w,d] = run8water(gasid,fmin,fmax,fip,topts);  

        fout = [dirout '/std' num2str(fmin)];
        fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_' num2str(mm) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
      else
        fprintf(1,'file %s already exists \n',fout);
        end
      end             %% loop over partial pressure
    end               %% loop over temperature (1..11)
  fmax = fmax - dv;
  end                 %% loop over freq

