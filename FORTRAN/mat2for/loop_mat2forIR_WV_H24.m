gases = [1 103 110];
gases = [      110];
gases = [  103    ];
gases = [1        ];
gases = [1 103    ];

fchunks = 1105 : 25 : 1705; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 0605 : 25 : 2805; fx = 0;     %% ALL
dtype = 'ieee-le';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% edit as needed H2012, H2016, H2020, H2024 etc
%% Jan 2021 : somewhere along the line Larrabee renamed /asl/data/kcarta/ to /asl/rta/kcarta
%% Jan 2026 : somewhere along the line Larrabee renamed /asl/rta/kcarta/ to /umbc/xfs3/strow/asl/rta/kcarta
%% fchunks = 1005; % BLEW IT AWAY BY MISTAKE when making the tar file of kComp data in Jan 2021

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    %% ISOTOPES other than HDO 
    gidx = gid;
    gasID_1_cdir_fdir
    gidxx = gid;
    
  elseif gid == 103
    %% ISOTOPES
    gidx = gid;
    gasID_103_cdir_fdir
    gidxx = gid;
    
  elseif gid == 110
    %% ALL ISOTOPES, including HDO 
    gidx = gid;
    gasID_110_cdir_fdir
    gidxx = gid;
    
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
    %%% fname = (sprintf('%s/cg%dv%d.mat', cdir, gidx, vchunk)); %% orig, from Howard
    fname = [cdir '/cg' num2str(gidxx) 'v' num2str(vchunk) '.mat'];

    ee = exist(fname);
    if ee > 0
      if vchunk <= 2805
        chunkprefix = 'r';
      else
        chunkprefix = 's';
      end
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, gidxx, vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end
  end
end

%%% no need to do this
%{
disp('c >>>> dont forget to symbolically link the files in h2o.ieee-le to hdo.ieee-le using lner.m <<<<<')
disp('c >>>>           see eg /asl/rta/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
disp('c >>>> dont forget to symbolically link the files in h2o.ieee-le to hdo.ieee-le using lner.m <<<<<')
disp('c >>>>           see eg /asl/rta/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
disp('c >>>> dont forget to symbolically link the files in h2o.ieee-le to hdo.ieee-le using lner.m <<<<<')
disp('c >>>>           see eg /asl/rta/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
%}

disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
disp('>>> now go to /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC and run eg comp_IRdatabase_H2016.sc <<<')
