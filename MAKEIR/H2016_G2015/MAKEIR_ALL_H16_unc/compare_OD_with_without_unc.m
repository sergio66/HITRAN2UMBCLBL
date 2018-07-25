function [w,od0,odX] = compare_OD(gid,iUnc)

%% iUnc = 1 -- 6 for wavenumber, strength, air/self broad, broad exp, line shift due to press
if nargin == 1
  iUnc = 1;   %% wavenumber unc;
end  
   
od0 = [];
odX = [];
w   = [];

addpath /home/sergio/SPECTRA
%[iYes1,line12,iYes2,line16] = findlines_plot_compareHITRAN(0605,2830,gid,2012,2016);
[iYes2,line16] = findlines_plot(0605,2830,gid,2016);
iso = find(line16.iso == 1);
unc = str2num(line16.ai(iso,iUnc));
figure(6); plot(line16.wnum(iso),unc,'.'); title('strongest isotope unc index');

figure(1);
for ff = 605 : 25 : 2830
  file0 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/std' num2str(ff) '_' num2str(gid) '_6.mat'];
  fileX = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830_unc/g' num2str(gid) '.dat/std' num2str(ff) '_' num2str(gid) '_6.mat'];
  ww = (1:10000)-1;
  ww = ww*0.0025 + ff;
  odd0 = zeros(1,10000);
  oddX = zeros(1,10000);  
  if exist(file0) & exist(fileX)
    dir0 = dir(file0);
    dirX = dir(fileX);
    if dir0.bytes > 0 & dirX.bytes > 0
      fprintf(1,'loading gid %2i ff %4i \n',gid,ff);
      a0 = load(file0);
      aX = load(fileX);
      odd0 = a0.d(1,:);
      oddX = aX.d(1,:);
      if gid == 3
        odd0 = a0.d(51,:);
        oddX = aX.d(51,:);
      end      
    end
  end
  w = [w ww];
  od0 = [od0 odd0];
  odX = [odX oddX];  
end

figure(1); plot(w,od0,w,odX,'r'); title('ODs');
figure(2); semilogy(w,od0,w,odX,'r'); title('ODs');
figure(3); plot(w,odX-od0,'r'); title('odX-od0');
figure(4); plot(w,(odX-od0)./(od0+eps),'r'); title('(odX-od0)/od0');
figure(5); plot(w,odX./od0,'r'); title('odX/od0');