chunkprefix = 'r';
gases = [-2 +2];

HITRAN = 2004;  
HITRAN = 2016;
HITRANvers = HITRAN - 2000;
HITRAN_last2 = HITRAN-2000;

fchunks = 2205 : 25 : 2405;
fchunks = 2205 : 25 : 2505;
dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);
  if gid == -2
    gdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_UPPER_400ppm_H' num2str(HITRAN_last2,'%02d') '/abs.dat/'];
    cdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_UPPER_400ppm_H' num2str(HITRAN_last2,'%02d') '/kcomp/'];
    fdir = ['/asl/data/kcarta_sergio/BACKGND_COUSIN_UPPER/fbin/etc.ieee-le/400ppmv_H' num2str(HITRAN_last2,'%02d') '/'];

  elseif gid == 2
    gdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_400ppm_H' num2str(HITRAN_last2,'%02d') '/abs.dat/'];
    cdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_400ppm_H' num2str(HITRAN_last2,'%02d') '/kcomp/'];
    fdir = ['/asl/data/kcarta_sergio/BACKGND_COUSIN/fbin/etc.ieee-le/400ppmv_H' num2str(HITRAN_last2,'%02d') '/'];

  end

  for ff = 1 : length(fchunks)
    vchunk = fchunks(ff);
    %%% fname = (sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk)); %% orig, from Howard
    fname = [cdir '/cg' num2str(abs(gid)) 'v' num2str(vchunk) '.mat'];

    ee = exist(fname);
    if ee > 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC(chunkprefix, abs(gid), vchunk, cdir, fdir, dtype)
    else
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end
    
  end
end
