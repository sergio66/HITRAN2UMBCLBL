chunkprefix = 'q';
gases = [[1 : 42] [51 : 81] [103]];
%gases = [[103]];
fchunks = 500 : 5 : 805;
fchunks = 500 : 5 : 880;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g1.dat/abs.dat/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g1.dat/kcomp/';    
    fdir = '/asl/data/kcarta/H2016.ieee-le/FIR500_805/hdo.ieee-le/';  %%%% <<<< note how G1 and G103 go into hdo.ieee-le
  elseif gid == 103
    gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat/abs.dat/';
    cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat/kcomp/';    
    fdir = '/asl/data/kcarta/H2016.ieee-le/FIR500_805/hdo.ieee-le/';  %%%% <<<< note how G1 and G103 go into hdo.ieee-le
  else
     gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/abs.dat/';
     cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/kcomp/';
     fdir = '/asl/data/kcarta/H2016.ieee-le/FIR500_805/etc.ieee-le/'
  end

  for ff = 1 : length(fchunks);
    vchunk = fchunks(ff);
    fname = (sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk));
    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, gid, vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end
  end
end
