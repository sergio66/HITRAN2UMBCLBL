clear all;

wall = [];
dfull = [];
dnone = [];
ddefault = [];

load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/std605_2_6.mat
  wall = [wall w]; dfull = [dfull d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/std630_2_6.mat
  wall = [wall w]; dfull = [dfull d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/std655_2_6.mat
  wall = [wall w]; dfull = [dfull d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/std680_2_6.mat
  wall = [wall w]; dfull = [dfull d];

load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/nolinemix_std605_2_6.mat
  dnone = [dnone d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/nolinemix_std630_2_6.mat
  dnone = [dnone d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/nolinemix_std655_2_6.mat
  dnone = [dnone d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/FULLlinemixUMBC/nolinemix_std680_2_6.mat
  dnone = [dnone d];

load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/std605_2_6.mat
  ddefault = [ddefault d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/std630_2_6.mat
  ddefault = [ddefault d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/std655_2_6.mat
  ddefault = [ddefault d];
load /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/std680_2_6.mat
  ddefault = [ddefault d];

clear w d
profile = load('/home/sergio/SPECTRA/IPFILES/std_co2');

press = profile(:,2)*1013.25;
ptemp = profile(:,4);
stemp = ptemp(4);

rad0 = ttorad(wall,stemp);
radF = ttorad(wall,stemp);

figure(1); clf;

for ii = 4 : 100
  od = dnone(ii,:);
  boo = find(isnan(od)); od(boo) = 0;

  odF= ddefault(ii,:);
  boo = find(isnan(odF)); odF(boo) = 0;

  plot(wall,od./odF); title([num2str(ii) ' : ' num2str(press(ii)) ' mb']); pause(0.1);
end

for ii = 4 : 100
  od = dnone(ii,:);
  boo = find(isnan(od)); od(boo) = 0;
  rad0 = rad0 .* exp(-od) + ttorad(wall,ptemp(ii)) .* (1 - exp(-od));

  od = ddefault(ii,:);
  boo = find(isnan(od)); od(boo) = 0;  
  radF = radF .* exp(-od) + ttorad(wall,ptemp(ii)) .* (1 - exp(-od));
end

figure(1); plot(wall,rad2bt(wall,rad0),'b',wall,rad2bt(wall,radF),'r')
figure(2); plot(wall,rad2bt(wall,rad0) - rad2bt(wall,radF),'r')

addpath /home/sergio/MATLABCODE
[fc,qc0] = quickconvolve(wall,rad0,0.5,0.5);
[fc,qcF] = quickconvolve(wall,radF,0.5,0.5);
[fc,qc0] = convolve_airs(wall,rad0,1:200);
[fc,qcF] = convolve_airs(wall,radF,1:200);
figure(2); plot(fc,rad2bt(fc,qc0) - rad2bt(fc,qcF),'r','linewidth',2); grid
  title('USUAL UMBC (full/first) - FULL ONLY'); ylabel('BTD (K)'); xlabel('wavenumber cm-1')