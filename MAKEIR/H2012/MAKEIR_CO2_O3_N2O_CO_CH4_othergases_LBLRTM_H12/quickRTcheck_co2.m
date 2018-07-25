xstartup;
addpath /home/sergio/KCARTA/MATLAB

%% look at ../compare_co2.m

if ~exist('d0')
  [d0,w0] = readkcstd('quickuse_co2_umbc.dat');
  [dLBL2,w0] = readkcstd('quickuse_co2_lblrtm2.dat');
  %[dGLAB,w0] = readkcstd('quickuse_o3_glabment.dat');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

chunk = input('enter chunk : ');
toff  = input('enter toffset (-50 : 10 : +50): ');
toff = toff/10 + 6;

ff = chunk;

dirx = '/asl/data/kcarta/UMBC_CO2_H1998.ieee-le/CO2ppmv385.ieee-le/';
dirx = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/kcomp/';
fname = ['cg2v' num2str(ff) '.mat'];
fname  = [dirx fname];
loader = ['a = load(''' fname ''');'];
eval(loader);
kcomp6  = squeeze(a.kcomp(:,:,6));
B       = a.B;
k_oldUMBC   = (B*kcomp6).^4;

dir0 = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/';
file_lblrtm  = [dir0 'lblrtm/std' num2str(chunk) '_2_' num2str(toff) '.mat'];
file_lblrtm2 = [dir0 'lblrtm2/std' num2str(chunk) '_2_' num2str(toff) '.mat'];
fileGLAB     = [dir0 'glab/std' num2str(chunk) '_2_' num2str(toff) '.mat'];

chunk_lblrtm  = load(file_lblrtm);
chunk_lblrtm2 = load(file_lblrtm2);
chunk_GLAB    = load(fileGLAB);

k_lblrtm1 = chunk_lblrtm.d;
k_lblrtm2 = chunk_lblrtm2.d;
k_glab = chunk_GLAB.d;

toff = 6;
tzz = refpro.mtemp + (toff-6)*10;
tsurf = 0.5*(tzz(3) + tzz(4));

rad0 = zeros(size(chunk_GLAB.w));
rad1 = zeros(size(chunk_GLAB.w));
rad2 = zeros(size(chunk_GLAB.w));
radG = zeros(size(chunk_GLAB.w));

ff = chunk_GLAB.w; 
rad0 = ttorad(ff,tsurf);
rad1 = ttorad(ff,tsurf);
rad2 = ttorad(ff,tsurf);
radG = ttorad(ff,tsurf);

for ii = 4 : 100
  if mod(ii,10) == 0
    fprintf(1,'%3i \n',ii)
  end

  tz = tzz(ii);
  rad = ttorad(ff,tz);

  od = k_oldUMBC(:,ii);
  rad0 = rad0 .* exp(-od) + rad.*(1-exp(-od));

  od = k_lblrtm1(:,ii);
  rad1 = rad1 .* exp(-od) + rad.*(1-exp(-od));

  od = k_lblrtm2(:,ii);
  rad2 = rad2 .* exp(-od) + rad.*(1-exp(-od));

  od = k_glab(:,ii);
  radG = radG .* exp(-od) + rad.*(1-exp(-od));

  pause(0.1);
end

rc = [rad0 rad1 rad2 radG];
[fc,qc] = quickconvolve(ff,rc,0.5,0.5); tc = rad2bt(fc,qc);
figure(3); 
  plot(fc,tc - tc(:,1)*ones(1,4))
  title(['Gaussian convolve radlayer ' num2str(ii)]); 

figure(2)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad0),ff,rad2bt(ff,rad1)-rad2bt(ff,rad0),...
     ff,rad2bt(ff,rad2)-rad2bt(ff,rad0),ff,rad2bt(ff,radG)-rad2bt(ff,rad0))
hl = legend('rad0-rad0','rad1-rad0','rad2-rad0','radG-rad0'); set(hl,'fontsize',10)
title('monchromatic raw od')

figure(1)
plot(ff,rad2bt(ff,rad0),ff,rad2bt(ff,rad1),ff,rad2bt(ff,rad2),ff,rad2bt(ff,radG))
hl = legend('rad0','rad1','rad2','radG'); set(hl,'fontsize',10)
           axis([ff(1) ff(end) 180 300])
title('monchromatic raw od')

[sum(rad0) sum(rad1) sum(rad2) sum(radG)]*0.0025/1000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4); plot(ff,rad2bt(ff,rad0),w0,rad2bt(w0,[d0(:,97) dLBL2(:,97)]))
           axis([ff(1) ff(end) 180 300])
hl = legend('rad0','kc0','kc2'); set(hl,'fontsize',10)
title('monchromatic raw OD0, kcarta')

figure(5); 
  plot(w0,rad2bt(w0,d0(:,97))-rad2bt(w0,dLBL2(:,97)))
  axis([ff(1) ff(end) -5 +5])
hl = legend('kc0-kc2'); set(hl,'fontsize',10)
title('monchromatic raw OD0, kcarta')

figure(6)
woo = find(w0 >= ff(1)-0.0025/2 & w0 <= ff(end)+0.0025/2);
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,d0(woo,97)),ff,rad2bt(ff,rad2)-rad2bt(ff,dLBL2(woo,97)))
hl = legend('rad0-kc0','rad0-kc2'); set(hl,'fontsize',10)
  axis([ff(1) ff(end) -5 +5])

figure(7)
plot(ff,rad2bt(ff,rad0)-rad2bt(ff,rad2),ff,rad2bt(ff,d0(woo,97))-rad2bt(ff,dLBL2(woo,97)),'r')
title('Shows (b)(r) rad0-rad2 ~ 0.1K','fontsize',10)