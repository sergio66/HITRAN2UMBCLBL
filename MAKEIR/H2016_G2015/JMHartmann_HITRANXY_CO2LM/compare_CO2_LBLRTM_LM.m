addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat
addpath /home/sergio/MATLABCODE

 caaAltComprDirsLM = '/asl/data/kcarta/H2016.ieee-le/IR605/HITRAN_LM/etc.ieee-le/Mar2021/fullCO2_400ppmv/';

 caaAltComprDirsLBLRTM = '/asl/data/kcarta/H2012.ieee-le/IR605/lblrtm12.4/etc.ieee-le/CO2_400ppmv/';
 caaAltComprDirsLBLRTM = '/asl/data/kcarta/H2016.ieee-le/IR605/lblrtm12.8/etc.ieee-le/CO2_400ppmv/';

iChunk = input('Enter chunk : ');

filename0 = [caaAltComprDirsLBLRTM '/r' num2str(iChunk) '_g2.dat'];
filename1 = [caaAltComprDirsLM     '/r' num2str(iChunk) '_g2.dat'];
 
[gid,fr,kcomp0,B0] = for2mat_kcomp_reader(filename0);
[gid,fr,kcomp1,B1] = for2mat_kcomp_reader(filename1);

kcomp0 = squeeze(kcomp0(:,:,6));
kcomp1 = squeeze(kcomp1(:,:,6));

K0 = (B0*kcomp0).^4;
K1 = (B1*kcomp1).^4;

figure(1); semilogy(fr,sum(K0,2),'b.-',fr,sum(K1,2),'r')
  hl = legend('LBLRTM','LM','location','best','fontsize',10);
figure(2); plot(fr,exp(-sum(K0,2)),'b.-',fr,exp(-sum(K1,2)),'r')
  hl = legend('LBLRTM','LM','location','best','fontsize',10);
figure(3); plot(fr,sum(K1,2)./sum(K0,2),'r'); title('LM/LBLRTM')
  plotaxis2(0,1);
