%% does the cross sections
%% see     head /asl/data/hitran/xsec98.ok/*.xsc | more

airs_nodes

nbox = 5;
pointsPerChunk = 10000;

gases = [3 7];           %%%%%%% <<<<<<<< need to change this as needed!
gases = [3 7 9 10 20];   %%%%%%% <<<<<<<< need to change this as needed!  
gases = [3];             %%%%%%% <<<<<<<< need to change this as needed!  
gases = [9];             %%%%%%% <<<<<<<< need to change this as needed!  

load /home/sergio/abscmp/refproTRUE.mat

pwd

freq_boundaries

addpath /home/sergio/HITRAN2UMBCLBL/READ_XSEC/
addpath /home/sergio/HITRAN2UMBCLBL/MAKEVIS1

cd /home/sergio/KCARTA/INCLUDE/
airslevelheights
dz = abs(diff(DATABASELEVHEIGHTS)) * 1000; %% change to m
dz = fliplr(dz)*100;  %% change to cm
cd /home/sergio/HITRAN2UMBCLBL/MAKEVIS1

while fmin <= wn2
  fmax = fmin + dv;
  for pp = -5 : +5
    wfreq0 = [];
    dkcomp0 = zeros(100,10000);
    for gg = 1 : length(gases)
      gasid = gases(gg);  

      gq = find(refpro.glist == gasid);
      tprof = refpro.mtemp + pp*10;
      profile = ...
        [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';
      cd /home/sergio/SPECTRA

      [iYes,gf] = findxsec_plot_UV(fmin,fmax,gasid); 
      fprintf(1,'gas freq = %3i %6i %3i\n',gasid,fmin,iYes);

      %% see abscmp/xsectab25.m
      gamnt = profile(5,:);
      gamnt2d = ones(1e4,1) * gamnt;
      tp = profile(4,:);
      pL  = profile(2,:);
      pLL = profile(3,:);
      d = zeros(100,10000);
      if gasid > 1 & iYes > 0
        v1 = fmin; v2 = fmax-dv;
        dvv = dv/pointsPerChunk;
        nvpts = 1 + round((v2-v1)/dvv);
        if gasid ~= 3
          [d,w] = calc_xsec_UV(gasid,fmin,fmax-dvv,dvv,tp,pL);  
        else
          [d,w] = calc_xsec_UV_ozone_li_zhu(gasid,fmin,fmax-dvv,dvv,tp,pLL);  
          end
        if gasid == 7
          hgt2d = dz;
          hgt2d = ones(1e4,1) * hgt2d;  %% this is in cm
          %% d is in cm^5/molecule^2, gamnt2d is molecule/cm2
          d = d.*(gamnt2d./hgt2d).*(gamnt2d./hgt2d);  %%so this is in cm
          d = d.*hgt2d;                               %%this is dimensionless
          %% zender claims col amt (O2-O2) = 13 x 10^42 molecules2/cm5
          woof = sum(gamnt./dz .* gamnt./dz .*dz)*(6.023e26)^2;
          woof = sum(((gamnt./dz).^2).*dz)*(6.023e26)^2;
          woof = sum((gamnt).^2./dz)*(6.023e26)^2;
        elseif gasid == 3
          hgt2d = dz;
          hgt2d = ones(1e4,1) * hgt2d;  %% this is in cm
          %% d is in 1/cm
          d = d.*hgt2d;
        else
          %% d is in cm^2/molecule, gamnt2d is molecule/cm2
          d = d.*gamnt2d;  
          end
        d = d';    %%% need same dimensions as rest of gases!
        end

      if iYes > 0
        fout = [dirout '/std' num2str(fmin)]; 
        fout = [fout '_xsec_' num2str(gasid) '_' num2str(pp+6) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
        end

      end               %% loop over gas
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

