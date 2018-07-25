chunkprefix = 'r';
gases = 2;

fchunks = 2205 : 25 : 2405;
fchunks = 2205 : 25 : 2505;
dtype = 'ieee-le';

solangs = [0 40 60 80 85 90];

for sol = solangs
  gid = 2;
  cdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/kcomp/';
  fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/fbin/etc.ieee-le/';

  for ff = 1 : length(fchunks);
    vchunk = fchunks(ff);

    iTYPE = 1;
    fname = [cdir '/cgL' num2str(gid) 'v' num2str(vchunk) 's' num2str(sol) '.mat'];
    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC_4umNLTE(chunkprefix, gid, vchunk, sol, iTYPE, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end

    iTYPE = 2;
    fname = [cdir '/pgL' num2str(gid) 'v' num2str(vchunk) 's' num2str(sol) '.mat'];
    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC_4umNLTE(chunkprefix, gid, vchunk, sol, iTYPE, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end

    iTYPE = 3;
    fname = [cdir '/cgU' num2str(gid) 'v' num2str(vchunk) 's' num2str(sol) '.mat'];
    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC_4umNLTE(chunkprefix, gid, vchunk, sol, iTYPE, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end

    iTYPE = 4;
    fname = [cdir '/pgU' num2str(gid) 'v' num2str(vchunk) 's' num2str(sol) '.mat'];
    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC_4umNLTE(chunkprefix, gid, vchunk, sol, iTYPE, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end

  end
end
