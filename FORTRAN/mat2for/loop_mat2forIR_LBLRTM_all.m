chunkprefix = 'r';
gases = 51 : 81;
gases = [[2 : 32] [51 : 63]];
gases = [[51 : 63]];
gases = [[22]];
gases = [[51]];
gases = [2 6];

fchunks = 605 : 25 : 2830;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    gdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/WV/abs.dat'];
    cdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/WV/kcomp.h2o'];
    fdir = ' ';
    error('use loop_mat2forIR_LBLRTM_WV.m AND BE REALLY CAREFUL WITH ISO dirs')
    cdir = ' ';
    fdir = ' ';

  else
    %% H2012
    %cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/kcomp/';          
    %fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/fbin/etc.ieee-le/';   
    %fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/';
  
    gdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/all/abs.dat'];
    cdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/all/kcomp'];
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/lblrtm12.2/etc.ieee-le/';
    
    gdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.4/all/abs.dat'];
    cdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.4/all/kcomp'];
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/lblrtm12.4/etc.ieee-le/';

    %% H2016
    gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat'];
    cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/kcomp'];
    fdir = '/asl/data/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/';
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
