%% does the cross sections
%% see     head /asl/data/hitran/xsec98.ok/*.xsc | more

nbox = 5;
pointsPerChunk = 10000;

gases = 62;    %%%%%%% <<<<<<<< need to change this as needed!
gases = 51:63; %%%%%%% <<<<<<<< need to change this as needed!
gases = 51:81; %%%%%%% <<<<<<<< need to change this as needed!

%load /home/sergio/abscmp/refproTRUE.mat
%load /home/sergio/HITRAN2UMBCLBL/refpro3.mat         %% ~2004 to Dec 2009
%load /home/sergio/HITRAN2UMBCLBL/refprof_usstd2010_lbl.mat  %% July 2010 - 
  %% copied/massaged from /asl/packages/klayersV205/Data/refprof_usstd2010.mat
  %% see make_refprof2010.m

load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat         %% symbolic link

freq_boundaries

addpath /home/sergio/HITRAN2UMBCLBL/READ_XSEC/
addpath /home/sergio/SPECTRA

cd /home/sergio/SPECTRA

%hpcfname
gases = str2num(hpcfname);

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

      [iYes,gf] = findxsec_plot(fmin,fmax,gasid,2016); 
      fprintf(1,'gas freq = %3i %6i %3i %3i\n',gasid,fmin,iYes,pp);
      fout = [dirout '/g' num2str(gasid) '.dat/std' num2str(fmin)];
      fout = [fout '_' num2str(refpro.glist(gq)) '_' num2str(pp+6) '.mat'];

      ee = exist(fout,'file');
      if ee > 0
        fprintf(1,'%s already exists \n',fout);
        end

      %% see abscmp/xsectab25.m
      gamnt = profile(5,:);
      gamnt2d = ones(1e4,1) * gamnt;
      tp = profile(4,:);
      pL = profile(2,:);
      d = zeros(100,10000);
      if iYes > 0 & ee == 0
        toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk  
        eval(toucher); 
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

      if iYes > 0 & ee == 0
        saver = ['save ' fout ' w d '];
        eval(saver);
        end

      end               %% loop over gas
    end                 %% loop over temperature (1..11)
  fmin = fmin + dv;
  end                   %% loop over freq

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08