xstartup

iChunk = input('Enter which chunk to look at : ');
iT     = input('enter which toffset to look at (-50 -40 ... +40 +50) : ');
iLAorUA = input('enter (+1) LA or (-1) UA or (0) both : ');

iT = (iT+50)/10 + 1; iT = max(iT,1); iT = min(iT,11);

if iLAorUA == 1
  ix = 001 : 100;
elseif iLAorUA == -1
  ix = 101 : 135;
elseif iLAorUA == 0
  ix = 001 : 135;
end

profile = ...
  load('/asl/data/kcarta//KCARTADATA/RefProf.For.v107up_CO2ppmv385/xrefgas2');

%%%% 
fname0 = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/abs.dat/g2v'];
fname385 = [fname0 num2str(iChunk) '_0.mat'];
fname363 = [fname0 num2str(iChunk) '_0_363ppmv.mat'];

a385 = load(fname385);
a363 = load(fname363);

k363 = squeeze(a363.k(:,ix,iT)); p363 = squeeze(a363.planck(:,ix,iT));
k385 = squeeze(a385.k(:,ix,iT)); p385 = squeeze(a385.planck(:,ix,iT));

%%%%

addpath /home/sergio/KCARTA/MATLAB
fname0 = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/0_Xnlte/'];
fname0 = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/0_Znlte_m5/'];

fname385 = [fname0 'std2205_2_' num2str(iT) '.dat'];
[d,w] = readkcstd(fname385);
fname385 = [fname0 'std2205_2_' num2str(iT) '.dat_UA'];
[dua,wua] = readkcua(fname385);
fname385 = [fname0 'std2205_2_' num2str(iT) '.dat_PLANCK'];
[p,w] = readkcplanck(fname385);

dall = [d dua(:,1:35)]; 
ixx = find(w >= iChunk-0.0025/2,1); ixx = ixx:ixx+10000-1;
k385 = dall(ixx,ix);            p385 = p(ixx,ix);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fr = a363.fr;
r0   = ttorad(fr,profile(4,4)); %% LTE (no planck)
r363 = ttorad(fr,profile(4,4)); %% NLTE
r385 = ttorad(fr,profile(4,4)); %% NLTE
x363 = ttorad(fr,profile(4,4)); %% NLTE, with 385 Planck
for ii = 4 : 100
  temp = profile(ii,4);
  r0 = r0.*exp(-k385(:,ii)) + ttorad(fr,temp).*(1-exp(-k385(:,ii)));
  r363 = r363.*exp(-k363(:,ii)) + ...
         ttorad(fr,temp).*(1-exp(-k363(:,ii))).*p363(:,ii);
  r385 = r385.*exp(-k385(:,ii)) + ...
         ttorad(fr,temp).*(1-exp(-k385(:,ii))).*p385(:,ii);
  x363 = x363.*exp(-k363(:,ii)) + ...
         ttorad(fr,temp).*(1-exp(-k363(:,ii))).*p385(:,ii);
end
tx = rad2bt(fr,[r0 r363 r385 x363]);
figure(1); clf; plot(fr,tx(:,3)*ones(1,4) - tx);
  hl=legend('NLTE385-LTE385','NLTE385-NLTE363','blah','NLTE385-NLTE363X385');
  set(hl,'fontsize',10); grid
  title('BTDs from radtrans');
figure(2); clf; plot(fr,tx(:,3)*ones(1,2) - tx(:,[2 4]));
  hl=legend('NLTE385-NLTE363','NLTE385-NLTE363X385');
  set(hl,'fontsize',10); grid
  title('BTDs from radtrans');
figure(3); clf; plot(fr,tx(:,2)-tx(:,4));
  hl=legend('NLTE385-NLTE363X385');
  set(hl,'fontsize',10); grid
  title('BTs from radtrans');
ret

figure(1); clf; plot(a385.fr,k363./k385); title('k363 / k385');
figure(2); clf; plot(a385.fr,p363./p385); title('p363 / p385');
ffx = 1:5:10000;
figure(3); clf; plot(k363(ffx,:)./k385(ffx,:),1:length(ix),'b',...
                     p363(ffx,:)./p385(ffx,:),1:length(ix),'r');
  title('k363/k385(b) and p363/p365(r)');

ksum = sum(k363');
imin = find(ksum == min(ksum),1); imax = find(ksum == max(ksum),1);
ffx = [imin imax];
figure(4); clf; plot(k363(ffx,:)./k385(ffx,:),1:length(ix),'x-',...
                     p363(ffx,:)./p385(ffx,:),1:length(ix),'o-');
  title('k363/k385(b) and p363/p365(r)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frtp0 = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/IPFILES/';
[h,ha,prof363,pa] = rtpread([frtp0 'toffset_0_USSTD_363.op.rtp']);
[h,ha,prof385,pa] = rtpread([frtp0 'toffset_0_USSTD.op.rtp']);

figure(5);
subplot(121); plot(prof363.ptemp-prof385.ptemp,1:101); 
  set(gca,'ydir','reverse'); 
  axis([-1 1 0 100]); title('T363-T385 profiles')
subplot(122); plot(prof363.gas_2./prof385.gas_2,1:101); 
  set(gca,'ydir','reverse');
  axis([0.94 0.95 0 100]);
title('363amt/385amt');

