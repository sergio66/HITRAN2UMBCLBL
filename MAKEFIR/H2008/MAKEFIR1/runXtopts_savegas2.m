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
    if gasid == 2 & iYes > 0
      [w,d] = run8co2(gasid,fmin,fmax,fip,topts);  
    end

    if iYes > 0
      fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/FIR500_605/std'];
      fout = [fout num2str(fmin)];
      fout = [fout '_' num2str(gq) '_' num2str(pp+6) '.mat'];
      saver = ['save ' fout ' w d '];
      eval(saver);
      end

%    wfreq0 = w;
%    dkcomp0 = dkcomp0 + d;

    fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/std'];
    fout = [fout num2str(fmin) '_' num2str(pp+6) '.mat'];
%    saver = ['save ' fout ' wfreq0 dkcomp0 '];
%    eval(saver);      

    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR1