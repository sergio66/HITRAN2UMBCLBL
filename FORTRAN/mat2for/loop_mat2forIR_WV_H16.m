gases = [      110];
gases = [1 103 110];
gases = [1 103    ];
gases = [      110];
gases = [  103    ];
gases = [1        ];

fchunks = 1105 : 25 : 1705; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 0605 : 25 : 2805; fx = 0;     %% ALL
dtype = 'ieee-le';

%% edit as needed H2012, H2016 etc
%% Jan 2021 : somewhere along the line Larrabee renamed /asl/data/kcarta/ to /asl/rta/kcarta
fchunks = 1005; % BLEW IT AWAY BY MISTAKE when making the tar file of kComp data in Jan 2021

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    %% ISOTOPES other than HDO 
    gidx = gid;
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/rta/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    %% unc
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g1.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized

    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize    
    %% unc

    cdir = '/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/g1.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/G2015.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    gidxx = 1;
    
  elseif gid == 103
    %% ISOTOPES
    gidx = gid;

    %% unc
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g103.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min    
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized
    
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max    
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize all
    %% unc

    cdir = '/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/g103.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/G2015.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/fbin/hdo.ieee-le/';   
    fdir = '/asl/rta/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g103.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    gidxx = 103;
    
  elseif gid == 110
    %% ALL ISOTOPES, including HDO 
    gidx = gid;
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/rta/kcarta/H2012.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g110.dat/kcomp.h2o/';
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized
    
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize all

    %%%%%%%%%%%%%%%%%%%%%%%%%
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';          
    fdir = '/asl/rta/kcarta/H2016.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

    gidxx = 110;
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
