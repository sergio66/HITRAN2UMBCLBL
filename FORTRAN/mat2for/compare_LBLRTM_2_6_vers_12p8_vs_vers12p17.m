function compare_LBLRTM_2_6_vers_12p8_vs_vers12p17(gid,Toffset,dir1,dir2,vchunk)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see gasID_lblrtm_cdir_fdir.m
%   compare_LBLRTM_2_6_vers_12p8_vs_vers12p17(2,1..11);
%   compare_LBLRTM_2_6_vers_12p8_vs_vers12p17(6,1..11);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
kpow = 4;
[gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader('/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le//r605_g6.dat');
[gid2,fr2,kcomp2,B2] = for2mat_kcomp_reader('/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le//r605_g6.dat');
   od1 = B1 * squeeze(kcomp1(:,:,6));
   od2 = B2 * squeeze(kcomp2(:,:,6));
   od1 = od1.^kpow;
   od2 = od2.^kpow;
[min(od1(:)) max(od1(:)) min(od2(:)) max(od2(:))]
[min(od1(:)) max(od1(:)) min(od2(:)) max(od2(:))]

figure(1); imagesc(od1'); colorbar
figure(2); imagesc(od2'); colorbar
figure(2); imagesc(od2'); colorbar; cx = caxis;
figure(1); colormap jet; caxis(cx)

figure(3); imagesc(od1'./od2'); colorbar;
colormap jet

addpath /home/sergio/git/matlabcode/COLORMAP
figure(3); imagesc(od1'./od2' - 1); colorbar; caxis([-1 +1]*10)
colormap(usa2)

figure(4)
ii = 1; plot(fr1,od1(:,ii),fr2,od2(:,ii))
ii = 100; plot(fr1,od1(:,ii),fr2,od2(:,ii))
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat/
  
if nargin == 0
  Toffset = 6;
  gid = 2;
  dir1 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
  dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';
  vchunk = 605 : 25 : 2830;
end

if gid == 2
  if nargin == 1
    Toffset = 6;    
    dir1 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 2
    dir1 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 3
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 4
    vchunk = 605 : 25 : 2830;
  end
else
  if nargin == 1
    Toffset = 6;        
    dir1 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 2
    dir1 = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/lblrtm12.17/etc.ieee-le/';
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 3
    dir2 = '/umbc/xfs3/strow/asl/rta/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/';
    vchunk = 605 : 25 : 2830;
  elseif nargin == 4
    vchunk = 605 : 25 : 2830;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kpow = 4;

figure(1); clf;
figure(2); clf;

for ff = vchunk
 f1 = [dir1 '/r' num2str(ff) '_g' num2str(gid) '.dat'];
 f2 = [dir2 '/r' num2str(ff) '_g' num2str(gid) '.dat']; 
 if exist(f1) & exist(f2)
   fprintf(1,'gid = %2i ff = %4i %s %s \n',gid,ff,f1,f2);
   [gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader(f1);
   [gid2,fr2,kcomp2,B2] = for2mat_kcomp_reader(f2);

   od1 = B1 * squeeze(kcomp1(:,:,Toffset));
   od2 = B2 * squeeze(kcomp2(:,:,Toffset));

   od1 = od1.^kpow;
   od2 = od2.^kpow;
   
   %figure(1); semilogy(fr1,od1,'b',fr2,od2,'r')
   figure(1); plot(fr1,od1./od2); hold on
   figure(2); plot(fr1,sum(od1,2) ./ sum(od2,2)); hold on
   figure(3); plot(od1(1,:)./od2(1,:),1:100); 
   pause(1)

   bad1 = find(od1(:) < 0);
   bad2 = find(od2(:) < 0);   
   if length(bad1) > 0
     for jj = 1 : 100
       noo1(jj) = length(find(od1(:,jj) < 0));
       noo2(jj) = length(find(od2(:,jj) < 0));       
     end
     badlayers1 = find(noo1 > 0)
     badlayers2 = find(noo2 > 0)     
     xxxx = find(od1(:,badlayers1(1)) < 0);

     %% this is compare_kcompressed_vs_run8_vs_lblrtm.m
     %% this is compare_kcompressed_vs_run8_vs_lblrtm.m
     %% this is compare_kcompressed_vs_run8_vs_lblrtm.m
     
     %% this is to load in what clust_runXtopts_savegasN_file.m computed, see plot_Toffset.m
     nbox = 5;
     pointsPerChunk = 10000;
     iUsualORHigh = 1;
     freq_boundariesLBL
     frawname = [dirout '/std' num2str(ff) '_' num2str(gid) '_' num2str(Toffset) '.mat'];
     drawOD = load(frawname);

     %% this is to compute driver_runXtopts_nosavegasN_onelay(gid,ff,Toffset,badlayers1(1));
     addpath /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM_v12.17_lnflv3.8.1/
     [w,wglab,drun8,dglab,dlblrtm] = driver_runXtopts_nosavegasN_onelay(gid,ff,Toffset,badlayers1(1));
     whos w wglab drun8 dglab dlblrtm
     [fc,qc] = quickconvolve(w,[drun8; dlblrtm; od1(:,badlayers1(1))'; od2(:,badlayers1(1))'; drawOD.d(:,badlayers1(1))'],0.25,0.25);
     
     figure(1); clf; semilogy(w,drun8,'g',w,dlblrtm,'b.-',w,od1(:,badlayers1(1)),'r',w,od2(:,badlayers1(1)),'k',w,drawOD.d(:,badlayers1(1)),'c')
       legend('run8','lblrtm','OD1','OD2','raw','location','best')
     figure(1); clf; semilogy(fc,qc(:,1),'g',fc,qc(:,2),'b.-',fc,qc(:,3),'r',fc,qc(:,4),'k',fc,qc(:,5),'c','linewidth',2)
       legend('run8','lblrtm','OD1','OD2','raw','location','best')
     disp('notice dlblrtm/drawOD are THE SAME, drun8 is close')
       
     figure(2); clf; semilogy(w,od1(:,badlayers1(1)),w,drun8);   legend('OD1','run8','location','best')
     figure(2); clf; semilogy(w,od1(:,badlayers1(1)),w,dlblrtm); legend('OD1','lblrtm','location','best')       
     figure(3); clf; semilogy(w(xxxx),od1(xxxx,badlayers1(1)),w,drun8)
     keyboard_nowindow
     
   end
 end
end

figure(1); hold off
figure(2); hold off
