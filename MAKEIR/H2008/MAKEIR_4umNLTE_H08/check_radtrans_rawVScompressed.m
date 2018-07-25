clear all

iChunk = input('Enter Chunk : ');
iSol   = input('Enter sol (0,40,60,80,85) : ');
toff   = input('enter toffset -50 -40 ... +40 +50 : ');

toff0 = toff;
toff = (toff - -50) / 10 + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% these are the 1 .. 100 layers
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
plevsA = refpro.mpres;
ptempA = refpro.mtemp;
clear refpro

%% these are the 101 .. 135 layers
ua = load('/home/sergio/HITRAN2UMBCLBL/MAKEIR_4umNLTE/ua_usstd.txt');
plevsB = ua(:,2)/1013.25;
ptempB = ua(:,5);

plevs = [plevsA; plevsB];
ptemp = [ptempA; ptempB];

ptemp = ptemp + toff0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%do radtrans through orig layers

korigname = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/abs.dat/';
korigname = [korigname 'g2v' num2str(iChunk) '_' num2str(iSol) '.mat'];
korig = load(korigname);

k0 = squeeze(korig.k(:,:,toff));
p0 = squeeze(korig.planck(:,:,toff));
ts = ptemp(1);
fr = korig.fr;

r0 = ttorad(fr,ts);
for ii = 1 : 135
  tx = ptemp(ii);
  od = k0(:,ii);
  planck = p0(:,ii);
  r0 = r0.*exp(-od) + ttorad(fr,tx).*planck.*(1-exp(-od));
  %r0 = r0.*exp(-od) + ttorad(fr,tx).*(1-exp(-od));
  rsave0(ii,:) = r0;
  plot(fr,rad2bt(fr,r0)); title(num2str(ii)); ret(0.1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kcompname0 = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/kcomp/';

klc = [kcompname0 'cgL2v' num2str(iChunk) 's' num2str(iSol) '.mat'];
klp = [kcompname0 'pgL2v' num2str(iChunk) 's' num2str(iSol) '.mat'];
kuc = [kcompname0 'cgU2v' num2str(iChunk) 's' num2str(iSol) '.mat'];
kup = [kcompname0 'pgU2v' num2str(iChunk) 's' num2str(iSol) '.mat'];

klc = load(klc);
klp = load(klp);
kuc = load(kuc);
kup = load(kup);

odL = klc.B * squeeze(klc.kcomp(:,:,toff)); odL = odL.^4;
odU = kuc.B * squeeze(kuc.kcomp(:,:,toff)); odU = odU.^4;
plL = klp.B * squeeze(klp.kcomp(:,:,toff)); plL = plL.^4;
plU = kup.B * squeeze(kup.kcomp(:,:,toff)); plU = plU.^4;

r1 = ttorad(fr,ts);
for ii = 1 : 100
  tx = ptemp(ii);

  od     = odL(:,ii);
  planck = plL(:,ii);

  r1 = r1.*exp(-od) + ttorad(fr,tx).*planck.*(1-exp(-od));
  %r1 = r1.*exp(-od) + ttorad(fr,tx).*(1-exp(-od));
  rsave1(ii,:) = r1;
  plot(fr,rad2bt(fr,r1)); title(num2str(ii)); ret(0.1);
end

for ii = 101 : 135
  tx = ptemp(ii);

  od     = odU(:,ii-100);
  planck = plU(:,ii-100);

  r1 = r1.*exp(-od) + ttorad(fr,tx).*planck.*(1-exp(-od));
  %r1 = r1.*exp(-od) + ttorad(fr,tx).*(1-exp(-od));
  rsave1(ii,:) = r1;
  plot(fr,rad2bt(fr,r1)); title(num2str(ii)); ret(0.1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5);   plot(fr,rad2bt(fr,r0),'bo',fr,rad2bt(fr,r1),'r'); ret(0.1);
figure(6)
  pcolor(fr,1:135,rad2bt(fr,rsave0')'-rad2bt(fr,rsave1')')
  shading flat; caxis([-0.2 +0.2]); colorbar;
  title('T0 - T1')
figure(7);  
  ix = 100; plot(fr,rad2bt(fr,rsave0(ix,:)')-rad2bt(fr,rsave1(ix,:)'),'b'); hold on
  ix = 135; plot(fr,rad2bt(fr,rsave0(ix,:)')-rad2bt(fr,rsave1(ix,:)'),'r'); hold off

figure(1)
  pcolor(fr,1:100,odL'./k0(:,1:100)'); shading flat;
  caxis([0.975 1.025]); colorbar
  title('OD at LA')
figure(2)
  pcolor(fr,1:35,odU'./k0(:,101:135)'); shading flat;
  caxis([0.975 1.025]); colorbar
  title('OD at UA')
figure(3)
  pcolor(fr,1:100,plL'./p0(:,1:100)'); shading flat;
  caxis([0.975 1.025]); colorbar
  title('planck at LA')
figure(4)
  pcolor(fr,1:35,plU'./p0(:,101:135)'); shading flat;
  caxis([0.975 1.025]); colorbar
  title('planck at UA')

%{
figure(1);
  plot(fr,odL(:,10),'o-',fr,k0(:,10),'r'); title('OD at lay 10')
  plot(fr,odL(:,10)./k0(:,10),'r'); title('OD at lay 10')
figure(2);
  plot(fr,odU(:,10),'o-',fr,k0(:,110),'r'); title('OD at lay 110')
  plot(fr,odU(:,10)./k0(:,110),'r'); title('OD at lay 110')
figure(3);
  plot(fr,plL(:,95),'o-',fr,p0(:,95),'r'); title('planck at lay 95')
  plot(fr,plL(:,95)./p0(:,95),'r'); title('planck at lay 95')
figure(4);
  plot(fr,plU(:,10),'o-',fr,p0(:,110),'r'); title('planck at lay 110')
  plot(fr,plU(:,10)./p0(:,110),'r'); title('planck at lay 110')
%}
