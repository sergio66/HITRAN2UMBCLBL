chunkprefix = 's';

gases = 1 : 32;
gases = [[2 : 42] [51 : 81]];

fchunks = 2805 : 25 : 3305;
fchunks = 3305 : 25 : 3580;

fchunks = 2830 : 25 : 3580;

dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
     cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/kcomp.h2o/';
     fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/fbin/h2o.ieee-le/';
     cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/g1.dat//kcomp.h2o/';
     fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/fbin/h2o.ieee-le/';
     disp('files eventually have to be in kWaterIsotopePath (kcarta.param)')
     error('use loop_mat2forNIR1_WV.m')
  elseif gid == 103
     cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/g103.dat//kcomp.h2o/';
     fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/fbin/h2o.ieee-le/';
     disp('files eventually have to be in kWaterIsotopePath (kcarta.param)')
     error('use loop_mat2forNIR1_WV.m')
  elseif gid == 110
     cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/g110.dat//kcomp.h2o/';
     fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/fbin/h2o.ieee-le/';
     disp('files eventually have to be in kWaterIsotopePath (kcarta.param)')
     error('use loop_mat2forNIR1_WV.m')
  else
     cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/kcomp/';
     fdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/fbin/etc.ieee-le/';

     cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/kcomp/';
     fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/NIR2830_3330/fbin/etc.ieee-le/';
     fdir = '/asl/data/kcarta/H2012.ieee-le/NIR2830_3580/etc.ieee-le/';
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