chunkprefix = 'h';
gases = [[1 : 42] [51 : 81]];
fchunks = 50 : 1.5 : 80;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
   cdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/kcomp.h2o/';
   fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/fbin/h2o.ieee-le/';

   cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR50_80/g1.dat/kcomp/';
   fdir = '/asl/data/kcarta/H2012.ieee-le/FIR50_80/h2o.ieee-le/';

  else
   cdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/kcomp/';
   fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/fbin/etc.ieee-le/';

    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR50_80/kcomp/';
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR50_80/fbin/etc.ieee-le/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/FIR50_80/etc.ieee-le/';
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