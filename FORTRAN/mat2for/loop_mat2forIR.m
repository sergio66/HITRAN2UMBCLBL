chunkprefix = 'r';
gases = 51 : 81;
gases = [3 : 42];
gases = [[51 : 81]];
gases = [3 4 5 6 9 12];  %% for uncertainty
gases = [[3 : 42] [51 : 81]];
gases = 2;
gases = [7 22];   %% ew MT CKD3.2 version

fchunks = 605 : 25 : 2830;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    error('use loop_mat2forIR_WV.m AND BE REALLY CAREFUL WITH ISO dirs')
    cdir = ' ';
    fdir = ' ';
  elseif gid == 2
    cdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_CO2/kcomp/';
    fdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_CO2/fbin/etc.ieee-le/';

       disp('from cmprunIR_OTHERS.m')
       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
       disp('WARNING!!!! NANs may show up in the abs.dat, which show up in the kcomp files')
       disp('so go back to eg /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LINEMIXUMBC_H12')
       disp('and run find_nan_put_zeros.m')
       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')

    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcomp/'
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcompNOZEROS/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/linemixUMBC/';

    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/kcomp/'
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/kcompNOZEROS/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/hartmann/';

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_385ppm/kcomp/full/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/co2_LM_HITRAN_385ppm/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/kcomp/full/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/co2_LM_HITRAN_400ppm/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/kcomp/full/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/co2_LM_HITRAN_400ppm_fixed1/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/kcomp/full/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/co2_LM_HITRAN_400ppm_fixed2/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/kcomp/full/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/co2_LM_HITRAN_400ppm_fixed3/';

  else
    %% H2008
    cdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/kcomp/';
    fdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/fbin/etc.ieee-le/';

    %% H2012
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/kcomp/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/fbin/etc.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/';

    %% H2016 uncertainty
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/kcomp/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_S-/';  %% strength min
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_Rn/';  %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized
    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_W+/';  %% wavenumber max    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_B+/';  %% broadening max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_P+/';  %% pressure shift max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_S+/';  %% strength max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/unc_Rn/';  %% randomize all    

    %% G2015
    cdir = '/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/kcomp/';          
    fdir = '/asl/data/kcarta/G2015.ieee-le/IR605/etc.ieee-le/';

    %% H2016
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/kcomp/';          
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/';

  end

  ee = exist(fdir);
  eec = exist(cdir);
  if ee == 0 & eec > 0
    fprintf(1,'compressed dir = %s does not have ieee bin dir %s \n',cdir,fdir);
    iYN = input('make ieee dir (-1/+1) : ');
    if iYN > 0
      mker = ['!mkdir -p ' fdir];
      eval(mker);
    end
  end

  for ff = 1 : length(fchunks);
    vchunk = fchunks(ff);
    %%% fname = (sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk)); %% orig, from Howard
    fname = [cdir '/cg' num2str(gid) 'v' num2str(vchunk) '.mat'];

    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, gid, vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end
  end
end

disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
