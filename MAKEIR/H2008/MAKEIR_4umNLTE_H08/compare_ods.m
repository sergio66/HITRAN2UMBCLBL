cd /asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/60
xstartup
addpath /home/sergio/KCARTA/MATLAB

[d49,w49] = readkcstd('quickuseLTE.dat');

[dua,w] = readkcUA('std2205_2_6.dat_UA'); whos
[dPlanck,w] = readkcPlanck('std2205_2_6.dat_PLANCK');    %% lower atm/UA planck modifiers
[d,w] = readkcstd('std2205_2_6.dat'); whos

dOD = [d(:,1:100) dua(:,1:35)];
xdOD = [d(:,1:100) dua(:,[2 2:35])];
semilogx(dPlanck(70001,1:132),1:132,'o-')
semilogx(dOD(70001,1:135),1:135,'o-',xdOD(70001,1:135),1:135,'ro-')

absdat = load('/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/abs.dat/g2v2355.mat');

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_4umNLTE
ix = find(w >= min(absdat.fr) & w <= max(absdat.fr));
ix = 10001:20000;
ix = 60001:70000;

ix49 = find(w49 >= min(absdat.fr) & w49 <= max(absdat.fr));
ix49 = 700001:710000;

jj = 4;
  plot(w(ix),d(ix,jj)./squeeze(absdat.k(:,jj,6)),w(ix),d(ix,jj)./d49(ix49,jj)/(385/370))
  semilogy(absdat.fr,d(ix,jj),w(ix),squeeze(absdat.k(:,jj,6)),w(ix),d49(ix49,jj))
