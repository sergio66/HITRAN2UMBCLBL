addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat

lbldir  = '/asl/data/kcarta/H2012.ieee-le/IR605/lblrtm12.4/etc.ieee-le/CO2_400ppmv/';   %% 400 ppm
lbldir  = '/asl/data/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';   %% 400 ppm
umbcdir = '/asl/data/kcarta_sergio/UMBC_CO2_H1998.ieee-le/CO2ppmv400.ieee-le/';         %% 400 ppm

lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LMBirn/';           %% 385 ppm
lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/';               %% 385 ppm

outputdir
lmdir = output_dir0;

wall = [];
lblrtmall = [];
umbcall   = [];
lmall     =  [];

toffset = 11;
toffset = input('enter toffset 1..11 : ');

iShape = input('for LM ods enter (-1) voigt (0) first (+1) full : ');

fStart = 2430; fStop = 2430;
fStart = 0605; fStop = 0780;
fStart = 2205; fStop = 2280;
fStart = 2405; fStop = 2480;
fStart = 1355; fStop = 1405;
fx = input('Enter [fStart fStop] : ');
fStart = fx(1); fStop = fx(2);

for ii = fStart : 25 : fStop
  fname = [lbldir '/r' num2str(ii) '_g2.dat'];
  [gid,fr,kcomp,B] = for2mat_kcomp_reader(fname);
  od = B * squeeze(kcomp(:,:,toffset));
  od = od.^4;
  od = od(:,3);
  wall = [wall fr];
  lblrtmall = [lblrtmall od'];

  fname = [umbcdir '/r' num2str(ii) '_g2.dat'];
  [gid,fr,kcomp,B] = for2mat_kcomp_reader(fname);
  od = B * squeeze(kcomp(:,:,toffset));
  od = od.^4;
  od = od(:,3);
  umbcall = [umbcall od'];

  fname = [lmdir '/std' num2str(ii,'%04d') '_2_' num2str(toffset,'%02d') '.mat'];
  fname = [lmdir '/std' num2str(ii) '_2_' num2str(toffset) '.mat'];  
  lm = load(fname);
  if iShape == -1
    d = lm.dvoigt(3,:);
  elseif iShape == 0
    d = lm.dfirst(3,:);
  elseif iShape == +1
    d = lm.dfull(3,:);
  end
  d = max(d,0);
  
  lmall = [lmall d*400/385];

  figure(1); plot(wall,lblrtmall,'b',wall,umbcall,'g',wall,lmall,'r','linewidth',2); ylabel('OD');
    hl = legend('LBLRTM 12.8','UMBC','HITRAN16 LM'); set(hl,'fontsize',10);  
  figure(2); semilogy(wall,lblrtmall,'b',wall,umbcall,'g',wall,lmall,'r','linewidth',2); ylabel('OD');
    hl = legend('LBLRTM 12.8','UMBC','HITRAN16 LM'); set(hl,'fontsize',10);  
  pause(0.1)
end

figure(3); plot(wall,umbcall./lblrtmall,'g',wall,lmall./lblrtmall,'r','linewidth',2)
axis([min(wall) max(wall) 0.5 1.5]); grid
hl = legend('UMBC/LBLRTM 12.8','HITRAN16 LM/LBLRTM 12.8'); set(hl,'fontsize',10); ylabel('OD ratio')

figure(4); plot(wall,exp(-lblrtmall),'b',wall,exp(-umbcall),'g',wall,exp(-lmall),'r','linewidth',2); grid
hl = legend('LBLRTM 12.8','UMBC','HITRAN16 LM'); set(hl,'fontsize',10); ylabel('transmission')

figure(5); plot(wall,exp(-umbcall)-exp(-lblrtmall),'g',wall,exp(-lmall)-exp(-lblrtmall),'r','linewidth',2); grid
hl = legend('UMBC - LBLRTM 12.8','HITRAN16 LM - LBLRTM 12.8'); set(hl,'fontsize',10); ylabel('transmission diff')
