chunkprefix = 'r';
gases = 51 : 81;
gases = [[2 : 32] [51 : 63]];
gases = [[51 : 63]];
gases = [[22]];
gases = [[51]];
gases = 2;

fchunks = 605 : 25 : 2830;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 2

    %%%%%%%%%
    %%% these are the 2018 tries
    %this is basically full mixing
    %gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/abs.dat/'];
    %cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/kcomp/'];
    %fdir = ['/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2018/oldCO2_385ppmv/'];    

    gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/abs.dat/voigt/'];
    cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/kcomp/voigt/'];
    fdir = ['/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2018/voigtCO2_385ppmv/'];    

    gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/abs.dat/firstorder/'];
    cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/kcomp/firstorder/'];
    fdir = ['/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2018/firstorderCO2_385ppmv/'];    

    gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/abs.dat/full/'];
    cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/kcomp/full/'];
    fdir = ['/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2018/fullCO2_385ppmv/'];    

    %%%%%%%%%
    %%% these are the 2020 tries
    gdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2_LM/g2.dat_LM5ptbox_Mar2021_400ppm/abs.dat/full/'];
    cdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2_LM/g2.dat_LM5ptbox_Mar2021_400ppm/kcomp/full/'];
    fdir = ['/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2021/fullCO2_400ppmv/'];    

  end

  for ff = 1 : length(fchunks)
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
