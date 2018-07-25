%function [fr,od1,od2] = compare_oldunc_modifiedunc(ix,ig,ichunk);

%% %function [fr,od1,od2] = compare_oldunc_modifiedunc(ix,ig,ichunk);

%% old uncertainties done in Dec 2017, use the HITRAN formulation "as is"
%% new uncertainties done in May 2018, use the HITRAN formulation "as suggested by Iouli Gordon"

ix = input('enter (1) wavenumber (2) strength  (3) broadening (4) pressure shift (5) random : ');
ig = input('enter gasID (1,103,3,4,5,6,9) : ');
ichunk = input('enter chunk 605:25:2830) : ');

if ig == 1 | ig == 103
  dir0 = ['/asl/data/kcarta/H2016.ieee-le/IR605/hdo.ieee-le/'];
else
  dir0 = ['/asl/data/kcarta/H2016.ieee-le/IR605/etc.ieee-le/'];
end

if ix == 1
  xstr = 'unc_W+';
  ystr = 'unc_W+_old';    
elseif ix == 2
  xstr = 'unc_S+';
  ystr = 'unc_S+_old';  
elseif ix == 3
  xstr = 'unc_B+';
  ystr = 'unc_B+_old';
elseif ix == 4
  xstr = 'unc_P+';
  ystr = 'unc_P+_old';  
elseif ix == 5
  xstr = 'unc_R';
  ystr = 'unc_R+_old';
  ystr = 'unc_S+';        
end

ii = 0;
for xchunk = 605:25:2830
  ii = ii + 1;
  f0 = [dir0      '/r' num2str(xchunk) '_g' num2str(ig) '.dat'];
  f1 = [dir0 xstr '/r' num2str(xchunk) '_g' num2str(ig) '.dat'];
  f2 = [dir0 ystr '/r' num2str(xchunk) '_g' num2str(ig) '.dat'];
  ee0(ii) = exist(f0);
  ee1(ii) = exist(f1);
  ee2(ii) = exist(f2);  
end
if sum(ee0) ~= sum(ee1)
  disp(' ')
  fprintf(1,'ohoh gas %3i is missing the following chunks \n',ig);
  bwah = find(ee0 ~= ee1);
  xchunk = 605:25:2830;
  xchunk(bwah)
  disp(' ')  
end

f0 = [dir0      '/r' num2str(ichunk) '_g' num2str(ig) '.dat'];
f1 = [dir0 xstr '/r' num2str(ichunk) '_g' num2str(ig) '.dat'];
f2 = [dir0 ystr '/r' num2str(ichunk) '_g' num2str(ig) '.dat'];

addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/mat2for
addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat
addpath /home/sergio/SPECTRA

[iYes,line] = findlines_plot(ichunk,ichunk+25,ig,2016);
ai = line.ai;
%     wnum_unc_index   = str2num(unc_index(:,1));    line center
%     stren_unc_index  = str2num(unc_index(:,2));    line strength
%     abroad_unc_index = str2num(unc_index(:,3));    air broadening
%     sbroad_unc_index = str2num(unc_index(:,4));    self broadening
%     abcoef_unc_index = str2num(unc_index(:,5));    temp dependence of broadening
%     tsp_unc_index    = str2num(unc_index(:,6));    pressure shift
if ix == 1
  ai = ai(:,1);
elseif ix == 2  
  ai = ai(:,2);
elseif ix == 3  
  ai = ai(:,3);
elseif ix == 4  
  ai = ai(:,6);
end
if ix <= 4
  ai = str2num(ai);
  figure(1);  plot(line.wnum,ai,'.');
  figure(2);  hist(ai);
end  
  
if exist(f0) & exist(f1) & exist(f2)
  fprintf(1,'reading %s \n',f0)
  [gid,fr,kcomp0,B0] = for2mat_kcomp_reader(f0);
  fprintf(1,'reading %s \n',f1)
  [gid,fr,kcomp1,B1] = for2mat_kcomp_reader(f1);
  fprintf(1,'reading %s \n',f2)  
  [gid,fr,kcomp2,B2] = for2mat_kcomp_reader(f2);
else
  fprintf(1,'%s existence = %2i \n',f0,exist(f0))
  fprintf(1,'%s existence = %2i \n',f1,exist(f1))
  fprintf(1,'%s existence = %2i \n',f2,exist(f2))  
  return
end

if ig ~= 1 & ig ~= 103
  od0 = B0 * squeeze(kcomp0(:,:,6)); od0 = od0.^(0.25);
  od1 = B1 * squeeze(kcomp1(:,:,6)); od1 = od1.^(0.25);
  od2 = B2 * squeeze(kcomp2(:,:,6)); od2 = od2.^(0.25);
else
  od0 = B0 * squeeze(kcomp0(:,:,6,2)); od0 = od0.^(0.25);
  od1 = B1 * squeeze(kcomp1(:,:,6,2)); od1 = od1.^(0.25);
  od2 = B2 * squeeze(kcomp2(:,:,6,2)); od2 = od2.^(0.25);
end

figure(3); plot(fr,od2./od0,'r',fr,od2./od1,'b',fr,od1./od0,'k'); title(['(r) new/no pert (b) new/old pert (k)old/no pert ' ystr(5:6)]);
figure(4); plot(fr,od2(:,1),'ro-',fr,od1(:,1),'b.-',fr,od0(:,1),'k'); title(['(r) new pert (b) old pert (k) no pert ' ystr(5:6)]);
  grid