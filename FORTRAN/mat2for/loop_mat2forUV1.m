chunkprefix = 'u';
gases = [[1 : 32] [51 : 63]];
fchunks = 25000 : 1000 : 45000;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
   cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/UV25000_45000/kcomp.h2o/';
   fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/UV25000_45000/fbin/h2o.ieee-le/';
  else
   cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/UV25000_45000/kcomp/';
   fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/UV25000_45000/fbin/etc.ieee-le/';
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