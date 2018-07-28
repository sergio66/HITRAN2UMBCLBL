addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat

thedir = dir('/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/H2012_XSEC/*.dat');
	      
dir2012 = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/H2012_XSEC/';                     %% only H2012
dir2016 = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/H2016_G51-63_H2012_G64-81_XSEC/'; %% mix of H2012 and H2016
%% dir2016 = '/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/';                                %% only H2016

for ii = 1 : length(thedir)
  olddir = dir([dir2012 '/' thedir(ii).name]);
  newdir = dir([dir2016 '/' thedir(ii).name]);
  fprintf(1,'%s %8i %8i %8i \n',thedir(ii).name,olddir.bytes,newdir.bytes,olddir.bytes-newdir.bytes)
  if abs(olddir.bytes-newdir.bytes) > 0
    disp('>>>>> ret to continue');
    pause
  end
  [gid0,fr0,kcomp0,B0] = for2mat_kcomp_reader([dir2012 '/' thedir(ii).name]);
  [gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader([dir2016 '/' thedir(ii).name]);  
  abs0 = B0 * squeeze(kcomp0(:,:,6));
  abs1 = B1 * squeeze(kcomp1(:,:,6));
  abs0(abs0 < 0) = 0;
  abs1(abs1 < 0) = 0;
  abs0 = abs0 .^ (4);
  abs1 = abs1 .^ (4);  
  figure(1); plot(fr0,sum(abs0'),'b.-',fr0,sum(abs1'),'r'); title([num2str(gid0) ' ' num2str(fr0(1))]);; grid
  figure(2); semilogy(fr0,sum(abs0'),'b',fr0,sum(abs1'),'r'); title([num2str(gid0) ' ' num2str(fr0(1))]);; grid  
  figure(3); plot(fr0,sum(abs1') ./ sum(abs0'),'r');      title([num2str(gid0) ' ' num2str(fr0(1))]);; grid
    ax = axis; axis([ax(1) ax(2) -0.1 +2]);

  wah0 = sum(abs0');
  wah1 = sum(abs1');  

  boo(ii) = nansum(sum(abs1') ./ sum(abs0'));
  gasid(ii) = gid0;
  freq(ii)  = fr0(1);
  maxOD(ii) = nanmax(wah0);
    
  %disp('ret'); pause
  pause(1)
  
end

%maxOD = maxOD .^ (4);
figure(4); clf; scatter(freq,log10(maxOD),30,gasid,'filled'); colormap jet; colorbar; grid
wow = find(maxOD > 2)

for iii = 1 : length(wow)
  ii = wow(iii);
  olddir = dir([dir2012 '/' thedir(ii).name]);
  newdir = dir([dir2016 '/' thedir(ii).name]);
  fprintf(1,'%s %8i %8i %8i \n',thedir(ii).name,olddir.bytes,newdir.bytes,olddir.bytes-newdir.bytes)
  if abs(olddir.bytes-newdir.bytes) > 0
    disp('>>>>> ret to continue');
    pause
  end
  [gid0,fr0,kcomp0,B0] = for2mat_kcomp_reader([dir2012 '/' thedir(ii).name]);
  [gid1,fr1,kcomp1,B1] = for2mat_kcomp_reader([dir2016 '/' thedir(ii).name]);  
  abs0 = B0 * squeeze(kcomp0(:,:,6));
  abs1 = B1 * squeeze(kcomp1(:,:,6));
  abs0(abs0 < 0) = 0;
  abs1(abs1 < 0) = 0;
  abs0 = abs0 .^ (4);
  abs1 = abs1 .^ (4);    
  figure(1); plot(fr0,sum(abs0'),'b.-',fr0,sum(abs1'),'r'); title([num2str(gid0) ' ' num2str(fr0(1))]);; grid
  figure(2); semilogy(fr0,sum(abs0'),'b',fr0,sum(abs1'),'r'); title([num2str(gid0) ' ' num2str(fr0(1))]);; grid  
  figure(3); plot(fr0,sum(abs1') ./ sum(abs0'),'r');      title([num2str(gid0) ' ' num2str(fr0(1))]);; grid
    ax = axis; axis([ax(1) ax(2) -0.1 +2]);

  wah0 = sum(abs0');
  wah1 = sum(abs1');  

  boo(ii) = nansum(sum(abs1') ./ sum(abs0'));
  gasid(ii) = gid0;
  freq(ii)  = fr0(1);
  maxOD(ii) = nanmax(wah0);
    
  %disp('ret'); pause
  pause(1)
  
end
