chunkprefix = 'q';
gases = [2];

fchunks = 500 : 15 : 605;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    error('use loop_mat2forIR_WV.m AND BE REALLY CAREFUL WITH ISO dirs')
    cdir = ' ';
    fdir = ' ';

  elseif gid == 2
    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR500_605/g2.dat/lblrtm2/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';  %%% <<<< yeah wierd place but go on!!!!!

  else
    error('only do gid 2')
    %% H2008
    cdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/kcomp/';
    fdir = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/fbin/etc.ieee-le/';

    %% H2012
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/kcomp/';          
    fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/fbin/etc.ieee-le/';   
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/';
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
