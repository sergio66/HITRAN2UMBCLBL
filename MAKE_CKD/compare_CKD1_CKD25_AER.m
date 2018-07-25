addpath /home/sergio/SPECTRA

clear all
fnamex = ['/asl/data/kcarta/KCARTADATA/General/CKDieee_le'];

ix = input('Enter [gasID(101 or 102) CKD] : ');
CKD = ix(2);

if ix(1) == 101
  fnamex  = [fnamex '/CKDSelf' num2str(CKD) '.bin'];
elseif ix(1) == 102
  fnamex  = [fnamex '/CKDFor' num2str(CKD) '.bin'];
end

faer = '/home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/MT_CKD2.5/cntnm/';
%faer = [faer '/src_sergio/CKD2.5_SELF_FORN_COEFFS_290K'];  
faer = [faer '/run_example/WATER.COEF_ckd2.5.dat'];

e1 = exist(fnamex);
e2 = exist(faer);

[kx, freq, temp] = contread2(fnamex);

aer = load(faer);   %% this is for 296K

T = 296;
donkA = find(temp < T); donkA = donkA(length(donkA));
if donkA < length(temp)
  donkB = donkA + 1;
else
  donkA = donkA - 1;
  donkB = donkA + 1;
end

slope = (kx(donkB,:)-kx(donkA,:))/(temp(donkB)-temp(donkA));
y = slope*(T-temp(donkA)) + kx(donkA,:);

if ix(1) == 101
  semilogy(freq,y,'bo',aer(:,1),aer(:,2),'r'); title('SELF b:ckdN r:AER')
  axis([min(freq) max(freq) 0 max(y)*1.1]); grid
  axis([min(freq) max(freq) 1e-27 1e-23]); grid on
else
  semilogy(freq,y,'bo',aer(:,1),aer(:,3),'r'); title('FORN b:ckdN r:AER')
  axis([min(freq) max(freq) 0 max(y)*1.1]); grid
  axis([min(freq) max(freq) 1e-32 1e-23]); grid on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt = 605 : 25 : 2805;
fx0 = '/asl/s1/sergio/RUN8_NIRDATABASE/CKD/';
fx0 = [fx0 num2str(CKD)  '/IR/g' num2str(ix(1)) '.dat/'];
if ix(1) == 102
  fx0 = [fx0 'stdFORN'];
else
  fx0 = [fx0 'stdSELF'];
end

wxn = [];
dataxn = [];
disp('reading database')
for jj = 1 : length(tt)
  index = 1 : 100 : 10000;
  fxn = [fx0 num2str(tt(jj)) '_1_6_CKD_' num2str(CKD) '.mat'];
  dxn = load(fxn);
  wxn = [wxn dxn.w(index)];
  dataxn = [dataxn dxn.d(4,index)];
end

if ix(1) == 101
  semilogy(freq,y,'bo',aer(:,1),aer(:,2),'r',wxn,dataxn,'k'); 
  title('SELF b:ckdN r:AER25 k:databaseN')
  axis([min(freq) max(freq) 0 max(y)*1.1]); grid
  axis([min(freq) max(freq) 1e-27 1e-23]); grid on
else
  semilogy(freq,y,'bo',aer(:,1),aer(:,3),'r',wxn,dataxn,'k'); 
  title('FORN b:ckdN r:AER25 k:databaseN')
  axis([min(freq) max(freq) 0 max(y)*1.1]); grid
  axis([min(freq) max(freq) 1e-32 1e-23]); grid on
end
