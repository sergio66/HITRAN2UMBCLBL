function compare_LBLRTM_2_6_vers_12p8_vs_vers12p17(gid,dir1,dir2,vchunk)

%% see gasID_lblrtm_cdir_fdir.m
addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat/
  
if nargin == 0
  gid = 2;
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

figure(1); clf;
figure(2); clf;
for ff = vchunk
 f1 = [dir1 '/r' num2str(ff) '_g' num2str(gid) '.dat'];
 f2 = [dir2 '/r' num2str(ff) '_g' num2str(gid) '.dat']; 
 if exist(f1) & exist(f2)
   fprintf(1,'gid = %2i ff = %4i %s %s \n',gid,ff,f1,f2);
   [gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader(f1);
   [gid2,fr2,kcomp2,B2] = for2mat_kcomp_reader(f2);

   od1 = B1 * squeeze(kcomp1(:,:,6));
   od2 = B2 * squeeze(kcomp2(:,:,6));
   
   %figure(1); semilogy(fr1,od1,'b',fr2,od2,'r')
   figure(1); plot(fr1,od1./od2); hold on
   figure(2); plot(fr1,sum(od1,2) ./ sum(od2,2)); hold on
   figure(3); plot(od1(1,:)./od2(1,:),1:100); 
   pause
 end
end

figure(1); hold off
figure(2); hold off
