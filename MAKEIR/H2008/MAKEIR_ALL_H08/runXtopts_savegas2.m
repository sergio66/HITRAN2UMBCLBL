airs_nodes

nbox = 5;
pointsPerChunk = 10000;
gases = 2;

wn1 = 500;
wn2 = 630-15;

wn1 = 500 + (iDoJob-1)*15;
wn2 = wn1 + 15;

load /home/sergio/abscmp/refproTRUE.mat

fmin = wn1; 
topts = runXtopts_params_smart(fmin); 
topts = runXtopts_params_smart(500); 
topts.hartmann_linemix = -1;
dv = topts.ffin*nbox*pointsPerChunk;

cd /home/sergio/SPECTRA

while fmin <= wn2
  fmax = fmin + dv;
  for pp = -5 : +5
    wfreq0 = [];
    dkcomp0 = zeros(100,10000);

    gasid = gases;  
    fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

    if gasid ~= 2
      error('this is only for CO2 with linemixing')
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

    fout = [dirout '/std' num2str(fmin)];
    fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
    ee = exist(fout,'file');
    if ee > 0
      fprintf(1,'%s already exists \n',fout);
      end

    if gasid == 2 & iYes > 0 & ee == 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk  
      eval(toucher); 
      [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
      saver = ['save ' fout ' w d '];
      eval(saver);
      end

%    wfreq0 = w;
%    dkcomp0 = dkcomp0 + d;

    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08