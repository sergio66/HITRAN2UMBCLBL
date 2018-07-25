xstartup;
addpath /home/sergio/KCARTA/MATLAB

%% look at ../compare_co2.m

if ~exist('d0')
  plevs = load('/home/sergio/MATLABCODE/airslevels.dat');
  plevs = plevs(5:101);
  hgt = p2h(plevs);
  [d0,w0] = readkcstd('quickuse_co2_umbc_fir.dat');
  [dLBL2,w0] = readkcstd('quickuse_co2_lblrtm2_fir.dat');
  plot(sum(d0),1:97,sum(dLBL2),1:97)
  plot(0.0015/1000*sum(d0-dLBL2),hgt/1000)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

500:15:605
chunk = input('enter chunk (500:15:605): ');
toff  = input('enter toffset (-50 : 10 : +50): ');
toff = toff/10 + 6;

ff = chunk;

dir0 = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR500_605/g2.dat/';
file_0       = [dir0 'std' num2str(chunk) '_2_' num2str(toff) '.mat'];
file_lblrtm2 = [dir0 'lblrtm2/std' num2str(chunk) '_2_' num2str(toff) '.mat'];

chunk_0       = load(file_0);
chunk_lblrtm2 = load(file_lblrtm2);

k_0       = chunk_0.d';
k_lblrtm2 = chunk_lblrtm2.d;

tzz = refpro.mtemp + (toff-6)*10;
tsurf = 0.5*(tzz(3) + tzz(4));

rad0 = zeros(size(chunk_0.w));
rad2 = zeros(size(chunk_0.w));

ff = chunk_0.w; 
rad0 = ttorad(ff,tsurf);
rad2 = ttorad(ff,tsurf);

for ii = 4 : 100
  if mod(ii,10) == 0
    fprintf(1,'%3i \n',ii)
  end

  tz = tzz(ii);
  rad = ttorad(ff,tz);

  od = k_0(:,ii);
  rad0 = rad0 .* exp(-od) + rad.*(1-exp(-od));

  od = k_lblrtm2(:,ii);
  rad2 = rad2 .* exp(-od) + rad.*(1-exp(-od));

  pause(0.1);
end

rc = [rad0  rad2];
[fc,qc] = quickconvolve(ff,rc,0.5,0.5); tc = rad2bt(fc,qc);
figure(3); 
  plot(fc,tc - tc(:,1)*ones(1,2))
  title(['Gaussian convolve radlayer ' num2str(ii)]); 

figure(2)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad0),ff,rad2bt(ff,rad2)-rad2bt(ff,rad0))
hl = legend('rad0-rad0','rad2-rad0'); set(hl,'fontsize',10)
title('monchromatic raw od')

figure(1)
plot(ff,rad2bt(ff,rad0),ff,rad2bt(ff,rad2),'r')
hl = legend('rad0','rad2'); set(hl,'fontsize',10)
title('monchromatic raw od')

[sum(rad0) sum(rad2)]*0.0015/1000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4); plot(ff,rad2bt(ff,rad0),w0,rad2bt(w0,[d0(:,97) dLBL2(:,97)]))
           axis([ff(1) ff(end) 220 300])
hl = legend('rad0','kc0','kc2'); set(hl,'fontsize',10)
title('monchromatic raw OD0, kcarta')

figure(5); 
  plot(w0,rad2bt(w0,d0(:,97))-rad2bt(w0,dLBL2(:,97)))
  axis([ff(1) ff(end) -10 +10])
hl = legend('kc0-kc2'); set(hl,'fontsize',10)
title('monchromatic raw OD0, kcarta')

figure(6)
woo = find(w0 >= ff(1)-0.0025/2 & w0 <= ff(end)+0.0025/2);
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,d0(woo,97)),ff,rad2bt(ff,rad2)-rad2bt(ff,dLBL2(woo,97)))
hl = legend('rad0-kc0','rad0-kc2','rad0-kcW'); set(hl,'fontsize',10)


figure(7)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad2),ff,rad2bt(ff,d0(woo,97))-rad2bt(ff,dLBL2(woo,97)),'r')
title('Shows (b)(r) rad0-rad2 ~ 0.1K','fontsize',10)