gases = [      110];
gases = [1 103    ];
gases = [1 103 110];
fchunks = 2405 : 25 : 2805; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 2405 : 25 : 3405; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 1105 : 25 : 1705; fx = 1;     %% ISOTOPES + OTHERS
fchunks = 0605 : 25 : 2805; fx = 0;     %% ALL
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1 | gid == 103 
    %% ISOTOPES + OTHERS
    gidx = gid;
    cdir='/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/kcomp.h2o/';          
    fdir='/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/fbin/hDo.ieee-le/';   
  else
    %% ALL
    gidx = 1;
    cdir='/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/kcomp_ALLISO.h2o/';
    fdir='/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/fbin/h2o_ALLISO.ieee-le/';
    end

  for ff = 1 : length(fchunks);
    vchunk = fchunks(ff);
    %%% fname = (sprintf('%s/cg%dv%d.mat', cdir, gidx, vchunk)); %% orig, from Howard
    fname = [cdir '/cg' num2str(gidx) 'v' num2str(vchunk) '.mat'];

    ee = exist(fname);
    if ee > 0
      if vchunk <= 2805
        chunkprefix = 'r';
      else
        chunkprefix = 's';
        end
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, gidx, vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
      end
    end
  end