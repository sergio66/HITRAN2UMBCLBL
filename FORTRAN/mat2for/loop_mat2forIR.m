chunkprefix = 'r';
gases = 51 : 81;
gases = [3 : 42];
gases = [[51 : 81]];
gases = [3 4 5 6 9 12];  %% for uncertainty
gases = 2;
gases = [7 22];   %% ew MT CKD3.2 version
gases = 3;
gases = [[3 : 42] [51 : 81]];
gases = [[3 : 49] [51 : 81]];

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

    gasID_2_cdir_fdir

  else

    gasID_3_81_cdir_fdir
    
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
      %fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, gid, vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist .... \n',fname);
    end
  end
end

disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2020.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2020.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2020.sc <<<')
