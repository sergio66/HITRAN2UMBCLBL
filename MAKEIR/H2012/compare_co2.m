clear all
figure(1); clf
figure(2); clf
figure(3); clf

clear all

ff0 = input('Enter chunk eg 655 : ');

addpath /home/sergio/SPECTRA
%findlines_plot_compareHITRAN(655,680,2,1998,2012);
findlines_plot_compareHITRAN(ff0,ff0+25,2,2000,2012);

for ff = ff0
  dirx = '/asl/data/kcarta/UMBC_CO2_H1998.ieee-le/CO2ppmv385.ieee-le/';
  dirx = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/kcomp/';
  fname = ['cg2v' num2str(ff) '.mat'];
  fname  = [dirx fname];
  loader = ['a = load(''' fname ''');'];
  eval(loader);
  kcomp6  = squeeze(a.kcomp(:,:,6));
  B       = a.B;
  k_oldUMBC   = (B*kcomp6).^4;

  dirx = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcompNOZEROS/';
  fname = ['cg2v' num2str(ff) '.mat'];
  fname  = [dirx fname];
  loader = ['a = load(''' fname ''');'];
  eval(loader);
  kcomp6  = squeeze(a.kcomp(:,:,6));
  B       = a.B;
  k_newUMBC   = (B*kcomp6).^4;

  dirx = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/kcompNOZEROS/';
  fname = ['cg2v' num2str(ff) '.mat'];
  fname  = [dirx fname];
  loader = ['a = load(''' fname ''');'];
  eval(loader);
  kcomp6  = squeeze(a.kcomp(:,:,6));
  B       = a.B;
  k_newHART   = (B*kcomp6).^4;

  fr = a.fr;
end        %%% loop over wavenumbers

figure(4); plot(fr,(k_oldUMBC ./ k_newUMBC)); title('oldUMBC/newUMBC')
figure(5); plot(fr,(k_oldUMBC ./ k_newHART)); title('oldUMBC/newHART')
figure(6); plot(fr,(k_newHART ./ k_newUMBC)); title('newHART/newUMBC')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refgas2_kc = load('/asl/data/kcarta/KCARTADATA/RefProf_July2010.For.v115up_CO2ppmv385/refgas2');

refgas2_kcomp = load('../../REFPROF/refproTRUE.mat');

figure(7);
  plot(refgas2_kc(:,5),refgas2_kc(:,2),'bo-',refgas2_kcomp.refpro.gamnt(:,2),refgas2_kcomp.refpro.mpres,'r')
  plot(refgas2_kc(:,5),refgas2_kc(:,2)./refgas2_kcomp.refpro.mpres,'r') 

  plot(refgas2_kc(:,4),refgas2_kc(:,2),'bo-',refgas2_kcomp.refpro.mtemp,refgas2_kcomp.refpro.mpres,'r')
  plot(refgas2_kc(:,4),refgas2_kc(:,2)./refgas2_kcomp.refpro.mpres,'r')

addpath /asl/matlib/aslutil
tprof = refgas2_kc(:,4);
rad_oldUMBC = ttorad(fr,tprof(3));
rad_newUMBC = ttorad(fr,tprof(3));
rad_newHART = ttorad(fr,tprof(3));
for ii = 4 : 100
  tempz = tprof(ii);
  od = k_oldUMBC(:,ii)'; rad_oldUMBC = rad_oldUMBC .* exp(-od) + ttorad(fr,tempz) .* (1-exp(-od));
  od = k_newUMBC(:,ii)'; rad_newUMBC = rad_newUMBC .* exp(-od) + ttorad(fr,tempz) .* (1-exp(-od));
  od = k_newHART(:,ii)'; rad_newHART = rad_newHART .* exp(-od) + ttorad(fr,tempz) .* (1-exp(-od));
end

plot(fr,rad2bt(fr,rad_oldUMBC),fr,rad2bt(fr,rad_newUMBC),fr,rad2bt(fr,rad_newHART))
plot(fr,rad2bt(fr,rad_oldUMBC)-rad2bt(fr,rad_newUMBC),fr,rad2bt(fr,rad_oldUMBC)-rad2bt(fr,rad_newHART))

addpath /home/sergio/MATLABCODE
[fc,qc] = quickconvolve(fr,[rad_oldUMBC; rad_newUMBC; rad_newHART],0.5,0.5);
plot(fr,rad2bt(fr,rad_oldUMBC)-rad2bt(fr,rad_newUMBC),'b',fr,rad2bt(fr,rad_oldUMBC)-rad2bt(fr,rad_newHART),'r',...
     fc,rad2bt(fc,qc(:,1))-rad2bt(fc,qc(:,2)),'c',fc,rad2bt(fc,qc(:,1))-rad2bt(fc,qc(:,3)),'m')

figure(8)
plot(fc,rad2bt(fc,qc(:,1))-rad2bt(fc,qc(:,2)),'c',fc,rad2bt(fc,qc(:,1))-rad2bt(fc,qc(:,3)),'m',...
     fc,rad2bt(fc,qc(:,2))-rad2bt(fc,qc(:,3)),'k')
  hl = legend('oldUMBC-newUMBC','oldUMBC-newHART','newUMBC-newHART','location','southeast');
  set(hl,'fontsize',10); grid