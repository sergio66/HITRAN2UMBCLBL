gases = [      110];
gases = [1 103 110];
gases = [1        ];
gases = [  103    ];
gases = [1 103    ];
fchunks = 1105 : 25 : 1705; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 0605 : 25 : 2805; fx = 0;     %% ALL
dtype = 'ieee-le';

%% edit as needed H2012, H2016 etc
for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    %% ISOTOPES other than HDO 
    gidx = gid;
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g1.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized

    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize    

    gidxx = 1;
    
  elseif gid == 103
    %% ISOTOPES
    gidx = gid;
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/fbin/hdo.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g103.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g103.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized
    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize all

    gidxx = 103;
    
  elseif gid == 110
    %% ALL ISOTOPES, including HDO 
    gidx = gid;
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le

    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g110.dat/kcomp.h2o/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S-/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength min
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, every perturbation randomized
    
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_W+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, wavenumber max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_B+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, broadening max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_P+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, pressure shift max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_S+/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, strength max
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/unc_Rn/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le, randomize all

    gidxx = 1;
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
disp('c >>>>           see eg /asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
disp('c >>>> dont forget to symbolically link the files in h2o.ieee-le to hdo.ieee-le using lner.m <<<<<')
disp('c >>>>           see eg /asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
disp('c >>>> dont forget to symbolically link the files in h2o.ieee-le to hdo.ieee-le using lner.m <<<<<')
disp('c >>>>           see eg /asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/lner.m <<<<<')
%}
