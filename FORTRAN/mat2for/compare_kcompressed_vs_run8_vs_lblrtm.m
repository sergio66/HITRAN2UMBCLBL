function [w,kcomp,drun8,dlblrtm,drawOD] = compare_kcompressed_vs_run8_vs_lblrtm(gid,ff,Toffset,layerN)

addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat

%% also see /umbc/rs/pi_sergio/WorkDirDec2025/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_v12.17_lnflv3.8.1/Readme
%% also see compare_LBLRTM_2_6_vers_12p8_vs_vers12p17.m

%% these are all gases made by UMBC LBL H2024
dirWV =  '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/hdo.ieee-le';
dirALL = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/etc.ieee-le';

%% these are CO2/CH4 made by LBLRTM 12.17 or 12.8
dir17 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
dir08 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if gid == 2 | gid == 6
  dir1 = dir17;
elseif gid == 1
  dir1 = dirWV;
else
  dir1 = dirALL;
end

kpow = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1 = [dir1 '/r' num2str(ff) '_g' num2str(gid) '.dat'];
if exist(f1)

  %% >>>>>>>>>>>>>>>>>>>>>>>>>
  disp(' ')
  fprintf(1,'loading in kcompressed data for gid = %2i ff = %4i Toffset = %2i %s \n',gid,ff,Toffset,f1);
  [gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader(f1);

  od1 = B1 * squeeze(kcomp1(:,:,Toffset));

  od1 = od1.^kpow;
  kcomp = od1(:,layerN);

  %% >>>>>>>>>>>>>>>>>>>>>>>>>
  %% this is to load in what clust_runXtopts_savegasN_file.m computed, see plot_Toffset.m  
  nbox = 5;
  pointsPerChunk = 10000;
  iUsualORHigh = 1;
  freq_boundariesLBL
  frawname = [dirout '/std' num2str(ff) '_' num2str(gid) '_' num2str(Toffset) '.mat'];
  disp(' ')  
  fprintf(1,'loading in raw LBLRTM or UMBC_LBL data for gid = %2i ff = %4i Toffset = %2i %s \n',gid,ff,Toffset,frawname);
  theraw = load(frawname);
  drawOD = theraw.d(:,layerN);

  %% >>>>>>>>>>>>>>>>>>>>>>>>>
  %% this is to compute driver_runXtopts_nosavegasN_onelay(gid,ff,Toffset,layerN);
  addpath /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_v12.17_lnflv3.8.1/
  disp(' ')  
  fprintf(1,'running driver_runXtopts_nosavegasN_onelay for gid = %2i ff = %4i Toffset = %2i \n',gid,ff,Toffset);  
  [w,wglab,drun8,dglab,dlblrtm] = driver_runXtopts_nosavegasN_onelay(gid,ff,Toffset,layerN);
  %whos w wglab drun8 dglab dlblrtm
  [fc,qc] = quickconvolve(w,[drun8; dlblrtm; kcomp'; drawOD'],0.25,0.25);

  %% >>>>>>>>>>>>>>>>>>>>>>>>>
  disp(' ')
  
  figure(1); clf; semilogy(w,drun8,'gx-',w,dlblrtm,'b.-',w,kcomp,'rx-',w,drawOD,'k')
    legend('run8','lblrtm','kCompressed','raw','location','best'); title('monochromatic 0.0025 cm-1')
  figure(1); clf; semilogy(fc,qc(:,1),'g',fc,qc(:,2),'b.-',fc,qc(:,3),'rx-',fc,qc(:,4),'k','linewidth',2)
    legend('run8','lblrtm','kCompressed','raw','location','best'); title('convolved 0.25 cm-1')
  disp('notice dlblrtm/drawOD are THE SAME, drun8 is close (if not CO2)')
    
  figure(2); clf; semilogy(w,kcomp,'b.-',w,drun8,'r');   title('monochromatic 0.0025 cm-1'); legend('kCompressed','run8','location','best')
  figure(3); clf; semilogy(w,kcomp,'b.-',w,dlblrtm,'r'); title('monochromatic 0.0025 cm-1'); legend('kCompressed','lblrtm','location','best')

  figure(4); clf; plot(w,kcomp'./dlblrtm,'bo-',w,drun8./dlblrtm,'g',w,drawOD'./dlblrtm,'rx-');
    legend('kCompressed/dlblrtm','drun8/dlblrtm','drawOD/dlblrtnm','location','best'); title('monochromatic 0.0025 cm-1')

  figure(5); clf; plot(w,kcomp'./drun8,'bo-',w,dlblrtm./drun8,'g',w,drawOD'./drun8,'rx-');
    legend('kCompressed/drun8','dlblrtm/drun8','drawOD/drun8','location','best'); title('monochromatic 0.0025 cm-1')


end

