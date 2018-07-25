xstartup;
addpath /home/sergio/KCARTA/MATLAB

iYes = input('do you want to see difference between H2008 and H2012 (-1/+1)? ');
if iYes > 0
  addpath /home/sergio/SPECTRA
  %% [iYes1,line1,iYes2,line2] = findlines_plot_compareHITRAN(wv1,wv2,gid,HITRAN1,HITRAN2);
  [iYes1,line1,iYes2,line2] = findlines_plot_compareHITRAN(980,1205,3);
  %% hmm there are differences, shucks!!!!!!!!!
end

[h,ha,p,pa] = rtpread('local_pin_feb2002_sea_airsnadir_g80_op.co2.rtp');

%if ~exist('d0')
%  %% all gases in kcarta have wgt = 1 ...
%  [d0,w0]      = readkcstd('quickuse_o3_umbc.dat');
%  [dLBL2,w0]   = readkcstd('quickuse_o3_lblrtm2.dat');
%  [dWOBASE,w0] = readkcstd('quickuse_o3_wobasement.dat');
%end

if ~exist('d0')
  %% only O3 has wgt = 1, all other gases == 0, acos(3/5) everywhere
  [d0,w0]      = readkcstd('quickuse_o3ONLY_umbc.dat');
  [dLBL2,w0]   = readkcstd('quickuse_o3ONLY_lblrtm2.dat');
  [dWOBASE,w0] = readkcstd('quickuse_o3ONLY_wobasement.dat');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

chunk = input('enter chunk : ');
toff  = input('enter toffset (-50 : 10 : +50): ');
toff = toff/10 + 6;

dir0 = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/';
file0        = [dir0 'std' num2str(chunk) '_3_' num2str(toff) '.mat'];
file_lblrtm  = [dir0 'lblrtm/std' num2str(chunk) '_3_' num2str(toff) '.mat'];
file_lblrtm2 = [dir0 'lblrtm2/std' num2str(chunk) '_3_' num2str(toff) '.mat'];
fileWOBASE   = [dir0 'WOBASEMENT/wobasement_std' num2str(chunk) '_3_' num2str(toff) '.mat'];

chunk0        = load(file0);
chunk_lblrtm  = load(file_lblrtm);
chunk_lblrtm2 = load(file_lblrtm2);
chunkWOBASE   = load(fileWOBASE);

disp('hmm also using H2008 for RAW UMBC-LBL voigt ODS')
dir08  = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g3.dat/';
file08 = [dir08 'std' num2str(chunk) '_3_' num2str(toff) '.mat'];
chunk08        = load(file08);

tzz = refpro.mtemp + (toff-6)*10;
tsurf = 0.5*(tzz(3) + tzz(4));

ff = chunk0.w; 

%% do background thermal
rad08b = zeros(size(chunk0.w))';
rad0b = zeros(size(chunk0.w))';
rad1b = zeros(size(chunk0.w))';
rad2b = zeros(size(chunk0.w))';
radWb = zeros(size(chunk0.w))';

theta = acos(3/5)*180/pi
for ii = 100 : -1 : 4
  if mod(ii,10) == 0
    fprintf(1,'backgnd thermal %3i \n',ii)
  end

  tz = tzz(ii);
  rad = ttorad(ff,tz);

  od = chunk0.d(ii,:)';
  od = od/cos(theta*pi/180);  %% use diffusive approx when coming down
  rad0b = rad0b .* exp(-od) + rad.*(1-exp(-od));

  od = chunk08.d(ii,:)';
  od = od/cos(theta*pi/180);  %% use diffusive approx when coming down
  rad08b = rad08b .* exp(-od) + rad.*(1-exp(-od));

  od = chunk_lblrtm.d(:,ii);
  od = od/cos(theta*pi/180);  %% use diffusive approx when coming down
  rad1b = rad1b .* exp(-od) + rad.*(1-exp(-od));

  od = chunk_lblrtm2.d(:,ii);
  od = od/cos(theta*pi/180);  %% use diffusive approx when coming down
  rad2b = rad2b .* exp(-od) + rad.*(1-exp(-od));

  od = chunkWOBASE.d(ii,:)';
  od = od/cos(theta*pi/180);  %% use diffusive approx when coming down
  radWb = radWb .* exp(-od) + rad.*(1-exp(-od));

  pause(0.1);
end

%% surface
rad0 = zeros(size(chunk0.w));
rad08 = zeros(size(chunk08.w));
rad1 = zeros(size(chunk0.w));
rad2 = zeros(size(chunk0.w));
radW = zeros(size(chunk0.w));

emis = interp1(p.efreq(:,49),p.emis(:,49),ff)';
rad0  = emis.*ttorad(ff,tsurf);   %% from UMBC-LBL, voigt
rad08 = emis.*ttorad(ff,tsurf);   %% from UMBC-LBL, voigt H2008
rad1  = emis.*ttorad(ff,tsurf);   %% first try at LBLRTM
rad2  = emis.*ttorad(ff,tsurf);   %% second try at LBLRTM
radW  = emis.*ttorad(ff,tsurf);   %% from UMBC-LBL, voigt wobasement

rad0  = rad0 + (1-emis) .* rad0b;
rad08 = rad08 + (1-emis) .* rad08b;
rad1  = rad1 + (1-emis) .* rad1b;
rad2  = rad2 + (1-emis) .* rad2b;
radW  = radW + (1-emis) .* radWb;

%% look at /home/sergio/MATLABCODE/KCMIX2/PACKAGE_UPnDOWNLOOK_2014_NLTE/private/BACKGND_THERMAL/vary_rtherm.m for better model
for ii = 4 : 100
  if mod(ii,10) == 0
    fprintf(1,'upwelling %3i \n',ii)
  end

  tz = tzz(ii);
  rad = ttorad(ff,tz);

  od = chunk0.d(ii,:)';
  rad0 = rad0 .* exp(-od) + rad.*(1-exp(-od));

  od = chunk08.d(ii,:)';
  rad08 = rad08 .* exp(-od) + rad.*(1-exp(-od));

  od = chunk_lblrtm.d(:,ii);
  rad1 = rad1 .* exp(-od) + rad.*(1-exp(-od));

  od = chunk_lblrtm2.d(:,ii);
  rad2 = rad2 .* exp(-od) + rad.*(1-exp(-od));

  od = chunkWOBASE.d(ii,:)';
  radW = radW .* exp(-od) + rad.*(1-exp(-od));

 % figure(1); 
 %   plot(ff,rad2bt(ff,rad0),ff,rad2bt(ff,rad1),ff,rad2bt(ff,rad2),ff,rad2bt(ff,radW)); 
 %   title(num2str(ii)); 
 % figure(2); 
 %   plot(ff,rad2bt(ff,rad0)-rad2bt(ff,radW),ff,rad2bt(ff,rad1)-rad2bt(ff,radW),...
 %        ff,rad2bt(ff,rad2)-rad2bt(ff,radW),ff,rad2bt(ff,radW)-rad2bt(ff,radW)); 
 %   title(num2str(ii)); 

 %  rc = [rad0 rad1 rad2 radW];
 %  [fc,qc] = quickconvolve(ff,rc,1,1); tc = rad2bt(fc,qc);
 %  figure(3); 
 %    plot(fc,tc - tc(:,4)*ones(1,4))
 %    title(num2str(ii)); 

  pause(0.1);
end

rc = [rad0 rad1 rad2 radW rad08];
[fc,qc] = quickconvolve(ff,rc,1,1); tc = rad2bt(fc,qc);
figure(1); 
  plot(fc,tc(:,[1:3 5]) - tc(:,4)*ones(1,4)); hold on
  plot(fc,tc(:,2)-tc(:,4),'go');   hold off
  axis([min(fc) max(fc) -0.04 +0.04]);
  axis([min(fc) max(fc) -0.04 +0]);
  title('Gaussian convolve radlayer TOA');
    hl = legend('rad0-radW','rad1-radW','rad2-radW','rad08-radW','location','east'); set(hl,'fontsize',10)
  
figure(2)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,radW),ff,rad2bt(ff,rad1)-rad2bt(ff,radW),...
     ff,rad2bt(ff,rad2)-rad2bt(ff,radW),ff,rad2bt(ff,rad08)-rad2bt(ff,radW))
hl = legend('rad0-radW','rad1-radW','rad2-radW','rad08-radW'); set(hl,'fontsize',10)
title('monchromatic raw od')

figure(3);
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad08))
hl = legend('rad0-rad08'); set(hl,'fontsize',10)
title('monchromatic raw od H2012-H2008')
disp('ret to continue'); pause

figure(4); plot(ff,rad2bt(ff,rad0),w0,rad2bt(w0,[d0(:,97) dLBL2(:,97) dWOBASE(:,97)]))
           axis([ff(1) ff(end) 220 300])
hl = legend('rad0','kc0','kc2','kcW'); set(hl,'fontsize',10)
title('monchromatic raw OD0 : matlab vs kcarta')

figure(5); 
  plot(w0,rad2bt(w0,d0(:,97))-rad2bt(w0,dLBL2(:,97)),w0,rad2bt(w0,d0(:,97))-rad2bt(w0,dWOBASE(:,97)),'r')
  axis([ff(1) ff(end) -0.1 +0.1])
hl = legend('kc0-kc2','kc0-kcW'); set(hl,'fontsize',10)
title('monchromatic kcarta using UMBC vs LBL')

figure(6); 
  plot(w0,rad2bt(w0,dLBL2(:,97))-rad2bt(w0,d0(:,97)),w0,rad2bt(w0,dLBL2(:,97))-rad2bt(w0,dWOBASE(:,97)),'r')
  axis([ff(1) ff(end) -0.1 +0.1])
hl = legend('kc2-kc0','kc2-kcW'); set(hl,'fontsize',10)
title('monchromatic kcarta using UMBC vs LBL')

figure(7)
woo = find(w0 >= ff(1)-0.0025/2 & w0 <= ff(end)+0.0025/2);
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,d0(woo,97)),ff,rad2bt(ff,rad2)-rad2bt(ff,dLBL2(woo,97)),...
     ff,rad2bt(ff,radW)-rad2bt(ff,dWOBASE(woo,97)))
hl = legend('rad0-kc0','rad2-kc2','radW-kcW'); set(hl,'fontsize',10)
title('like for like : matlab-kcarta')

figure(8)
woo = find(w0 >= ff(1)-0.0025/2 & w0 <= ff(end)+0.0025/2);
plot(ff,rad2bt(ff,rad0),ff,rad2bt(ff,d0(woo,97)))
hl = legend('rad0','kc0'); set(hl,'fontsize',10)
title('like for like : matlab vs kcarta')

figure(9)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad2),ff,rad2bt(ff,d0(woo,97))-rad2bt(ff,dLBL2(woo,97)),'r',...
     ff,rad2bt(ff,rad0)-rad2bt(ff,radW),'k')
title('Shows (k) rad0-radW ~ 0.01K and (b)(r) rad0-rad2 ~ 0.1K','fontsize',10)

figure(10)
  plot(w0,260+100*(rad2bt(w0,d0(:,97))-rad2bt(w0,dLBL2(:,97))),w0,rad2bt(w0,d0(:,97)),'r')
  hl = legend('260+100*(kc0-kc2)','kc0'); set(hl,'fontsize',10)
  axis([ff(1) ff(end) 220 300])
grid
