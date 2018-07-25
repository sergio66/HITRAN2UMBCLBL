chunkprefix = 'x';

gases = 51 : 81;
gases = [[3 : 42] [51 : 81]];

gases = [2 3 6 7 22];
gases = [7 22];
gases = [3 6];

gases = [2 3];

fchunks = 605 : 05 : 855;
fchunks = 855 : 05 : 1205;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == 1
    error('use loop_mat2forIR_WV.m AND BE REALLY CAREFUL WITH ISO dirs')
    cdir = ' ';
    fdir = ' ';

  elseif gid == 2
    %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, should be fine
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm/kcomp/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm/';

    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm2/kcomp/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';

    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0005/kcomp/';
    fdir = '/asl/data/kcarta_sergio/H2012.ieee-le/IR605/etc.ieee-le/lblrtm0.0005/';

  elseif gid == 3
    %%  >>> made by UMBC LBL w/o basement
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/WOBASEMENT/kcomp/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/WOBASEMENT/';

    %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, should be fine
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm/kcomp/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm/';

    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm2/kcomp/';
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';

    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm0.0005/kcomp/';
    fdir = '/asl/data/kcarta_sergio/H2012.ieee-le/IR605/etc.ieee-le/lblrtm0.0005/';

  elseif gid == 5
    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g5.dat/lblrtm2/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';

  elseif gid == 6
    %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, should be fine
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm/';

    %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm2/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';

  elseif gid == 7
    %%% >>>>>>>>>>>>> done with MY way of doing things, WRONG SHOULD NOT TRUST
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm/';

  elseif gid == 22
    %%% >>>>>>>>>>>>> done with MY way of doing things, WRONG SHOULD NOT TRUST AS ONLY PUTS continuum
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm/';

    %%% >>>>>>>>>>>>> done with AER way of doing things, PUTS continuum AND lines
    cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm2/kcomp/'
    fdir = '/asl/data/kcarta/H2012.ieee-le/IR605/etc.ieee-le/lblrtm2/';

  else
    error('only do gid 2,3,6,7,22')
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
