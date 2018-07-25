%% does the cross sections
%% see     head /asl/data/hitran/xsec98.ok/*.xsc | more

airs_nodes

nbox = 5;
pointsPerChunk = 10000;

gases = 51:63; %%%%%%% <<<<<<<< need to change this as needed!
gases = 62;    %%%%%%% <<<<<<<< need to change this as needed!

wn1 = 500;
wn2 = 630-15;

load /home/sergio/abscmp/refproTRUE.mat

fmin = wn1; 
topts = runXtopts_params_smart(fmin); 
topts = runXtopts_params_smart(500); 
dv = topts.ffin*nbox*pointsPerChunk;

addpath /home/sergio/HITRAN2UMBCLBL/READ_XSEC/

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

%      fip = ['IPFILES/std_gx' num2str(gasid) '_' num2str(pp+6)];
%      fid = fopen(fip,'w');
%      fprintf(fid,'%3i %10.8f %10.8f %7.3f %10.8e \n',profile);
%      fclose(fid);

      [iYes,gf] = findxsec_plot(fmin,fmax,gasid); 
      fprintf(1,'gas freq = %3i %6i %3i\n',gasid,fmin,iYes);

      %% see abscmp/xsectab25.m
      gamnt = profile(5,:);
      gamnt2d = ones(1e4,1) * gamnt;
      tp = profile(4,:);
      pL = profile(2,:);
      d = zeros(100,10000);
      if gasid > 1 & iYes > 0
        %[w,d] = calc_xsec(gf,fmin,fmax-dv,dv,tp,pL,1);  
        v1 = fmin; v2 = fmax-dv;
        dvv = dv/pointsPerChunk;
        nvpts = 1 + round((v2-v1)/dvv);
        %[gasid fmin fmax dv dvv nvpts]
        %[d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL,1);  
        [d,w] = calc_xsec(gasid,fmin,fmax-dvv,dvv,tp,pL);  
        d = d.*gamnt2d;
        d = d';    %%% need same dimensions as rest of gases!
        end

      if iYes > 0
        fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/FIR500_605/std'];
        fout = [fout num2str(fmin)];
        fout = [fout '_' num2str(gasid) '_' num2str(pp+6) '.mat'];
        saver = ['save ' fout ' w d '];
        eval(saver);
        end

      fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/std'];
      fout = [fout num2str(fmin) '_' num2str(pp+6) '.mat'];
      end               %% loop over gas
    fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/std' ];
    fout = [fout num2str(fmin) '_' num2str(pp+6) '.mat'];
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEFIR1