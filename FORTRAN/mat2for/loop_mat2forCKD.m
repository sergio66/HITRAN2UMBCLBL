nbox = 5; pointsPerChunk = 10000;

iNew_or_Orig = -1  %% made by /home/sergio/HITRAN2UMBCLBL/MAKE_CKD/;
iNew_or_Orig = +1  %% made by /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/;

if iNew_or_Orig < 0
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKE_CKD'];
else  
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/'];
end

eval(cder);

freq_boundaries_continuum

gases = [101 102];
fchunks = wn1 : dv : wn2;

cd /home/sergio/HITRAN2UMBCLBL/FORTRAN/mat2for

dtype = 'ieee-le';

for gg = 1 : length(gases)
  gid = gases(gg);

  if iNew_or_Orig < 0
    cdir = [dirout '/' num2str(CKD) '/' bandID '/kcomp.CKD/'];  
    cdir = [dirout '/' num2str(CKD) '/' bandID '/kcomp.CKD/'];

    fdir = [dirout '/' num2str(CKD) '/' bandID '/fbin/etc.ieee-le/'];
  else
    cdir = [dirout '//kcomp.CKD/'];
    cdir = [diroutCompressed '/'];

    fdir = [diroutCompressed '/fbin/etc.ieee-le/'];
    %% see eg gasID_103_cdir_fdir.m
    fdir = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/CKD43.ieee-le/';       %% may need to make this dir
  end

  for ff = 1 : length(fchunks);
    vchunk = fchunks(ff);
    fname = [cdir '/cg' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD) '.mat'];
    fsave = [fdir '/' chunkprefix num2str(vchunk) '_g' num2str(gid) '_CKD_' num2str(CKD) '.dat'];
    ee = exist(fname);
    ee1 = exist(fsave);
    if ee > 0 & ee1 == 0
      fprintf(1,'%s does exist, processing .... \n',fname);
      mat2forGENERIC_CKD(chunkprefix, gid, vchunk, cdir, fdir, CKD, dv, dtype)
    elseif ee > 0 & ee1 > 0
      fprintf(1,'%s does exist but so does \n',fname);
      fprintf(1,'%s : no need to process .... \n',fsave);
    elseif ee == 0
      fprintf(1,'%s does not exist, going to next .... \n',fname);
    end
  disp(' ')
  end
end
