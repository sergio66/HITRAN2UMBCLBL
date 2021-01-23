%% for the IR/HIGHRES, see chunkprefix = 'x';
gases = [1 103 110];
gases = [1        ];
gases = [  103    ];
gases = [1 103    ];
gases = [      110];

fchunks = 0605 : 05 : 0855; fx = 0;     %% ALL
fchunks = 0855 : 05 : 1205; fx = 0;     %% ALL
fchunks = 0605 : 05 : 1205; fx = 0;     %% ALL
dtype = 'ieee-le';

%% H2102
for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    %% ISOTOPES other than HDO 
    gidx = gid;
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/kcomp.h2o/';
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le
    
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/lblrtm0.0005/kcomp.h2o/';
    fdir = '/asl/data/kcarta_sergio/H2012.ieee-le/IR605/etc.ieee-le/lblrtm0.0005/';
    
    gidxx = 1;
  elseif gid == 103
    %% ISOTOPES
    gidx = gid;
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/fbin/hdo.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/';        %%%% <<<< note how G1 and G103 go into hdo.ieee-le

    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/lblrtm0.0005/kcomp.h2o/';
    fdir = '/asl/data/kcarta_sergio/H2012.ieee-le/IR605/etc.ieee-le/lblrtm0.0005/';

    gidxx = 103;
  elseif gid == 110
    %% ALL ISOTOPES, including HDO 
    gidx = gid;
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/kcomp.h2o/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/fbin/h2o.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/h2o_ALLISO.ieee-le/';  %%%% <<<< note how G110 goes into h2o_ALLISO.ieee-le
    gidxx = 1;

    gidx = gid;
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8//kcomp.h2o/0.0005/';
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/lblrtm0.0005/';
    gidxx = 1;

  end

  ee = exist(fdir);
  eec = exist(cdir);
  if ee == 0 & eec > 0
    fprintf(1,'compressed dir = %s does not have ieee bin dir\n',cdir);
    iYN = input('make dir (-1/+1) : ');
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
      chunkprefix = 'x';
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