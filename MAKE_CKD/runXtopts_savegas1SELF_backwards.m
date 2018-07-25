nbox = 5;
pointsPerChunk = 10000;
gases = [101];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

%time_pause = ceil(rand*100);
time_pause = 1;
pause(time_pause)

freq_boundaries_continuum

allfreqchunks = wn1 : dv : wn2-dv;

dirout0 = dirout;

cd /home/sergio/SPECTRA

disp(' ')
fprintf(1,'BAND = %s  wn1,wn2 = %8.6f %8.6f \n',bandID,wn1,wn2)
disp(' ')

fx = [dirout '/' num2str(CKD) '/' bandID '/g101.dat/'];
ee = exist(fx);
if ee == 0
  fprintf(1,'making directory = %s \n',fx);
  mker = ['!mkdir -p ' fx]; 
  eval(mker);
  pause
else
  fprintf(1,'directory = %s already exists \n',fx);
  disp('ret to continue : ')
  pause
  end

for iido = length(allfreqchunks) : -1 : 1
  fmin = allfreqchunks(iido);
  fmax = fmin + dv;

  for pp = -5 : +5

    gg = 1;
    gasid = gases;  
    fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

    tprof = refpro.mtemp + pp*10;

    dirout = fx;

    fout = [fx '/stdSELF' num2str(fmin)];
    fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
    if exist(fout,'file') == 0 
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      profile = [(1:100)' refpro.mpres refpro.gpart(:,gg) tprof refpro.gamnt(:,gg)]';
      %%% we need nonzero partial pressures and nonzero amts
      profile = [(1:100)' refpro.mpres refpro.mpres*1e-2 tprof refpro.mpres*1e-5]';
      fip = ['IPFILES/std_gx' num2str(gasid) '_' num2str(pp+6)];
      fid = fopen(fip,'w');
      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
      fclose(fid);

loc = 0;
quick.CKD  = CKD;
quick.local= loc;
quick.ffin = dv/pointsPerChunk;
quick.nbox = nbox;
quick.nbox = 1;
quick.divide   = 1;
quick.selfmult = 1;
quick.formult  = 0;
      [w,d] = run8watercontinuum(1,fmin,fmax,fip,quick);

      fout = [fx '/stdSELF' num2str(fmin)];
      fout = [fout '_' num2str(gg) '_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
      saver = ['save ' fout ' w d '];
      eval(saver);

    elseif exist(fout,'file') > 0 
      fprintf(1,'file %s already exists \n',fout);
      end

    end               %% loop over temperature (1..11)
  end                 %% loop over freq

cd /strowdata1/shared/sergio/HITRAN2UMBCLBL/MAKEIR_WV_H08
cd /home/sergio/HITRAN2UMBCLBL/MAKE_CKD