function makeTAPE5_N2O2fake(gid,v1,v2,ipfile,dvx,iLay,iTalk);

%% same as makeTAPE5_N2O2true except it makes gas amount for gid == 0!!!!
%% so only contribution can reasonably come from O2 or N2

if nargin == 5
  iLay = 1;
  iTalk = +1;
elseif nargin == 6
  iTalk = +1;
elseif nargin < 5
  error('need at least 5 args for makeTAPE5')
end

if gid > 12
  error('been too lazy to code up more than 12 gases!')
end

gas = load(ipfile);
gas = gas(iLay,:);

p  = gas(2) * 1013.25;       %% change from atm to mb
pp = gas(3) * 1013.25;       %% change from atm to mb
T  = gas(4);
q  = gas(5) * 6.022045e26;   %% kmol/cm2 --> molecules/cm2

mr = gas(3)/gas(2);    %% gasN
n2 = q*(1-mr)/mr;      %% N2
air = q/mr;            %% N2 + gasN

q = eps;               %% <<<<<<<<<<<<< set q = 0
q = 0;                 %% <<<<<<<<<<<<< set q = 0

if iTalk > 0
  fprintf(1,'p = %15.7e mb  T = %15.7e K ,mr = %8.6e \n',p,T,mr);
  fprintf(1,'  gas = %15.7e  molecules/cm2    n2 = %15.7e  molecules/cm2 air = %15.7e  molecules/cm2\n',q,n2,air);
end

%% http://shadow.eas.gatech.edu/~vvt/lblrtm/lblrtm_inst.html
fid = fopen('TAPE5','w');

str = '$ Set up KCARTA database ';
  fprintf(fid,'%s \n',str);
str = ' HI=1 F4=1 CN=5 AE=0 EM=0 SC=0 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=1 XS=0    0    0';
  fprintf(fid,'%s \n',str);

str = '  2080.000  2180.000                                                                          0.0005';
if dvx == 0.0005
  str1 = '                                                                        0.0005';
  str1 = '                                            0.00                        0.0005';
elseif dvx == 0.0025
  str1 = '                                                                        0.0025';
  str1 = '                                            0.00                        0.0025';
elseif dvx == 0.0003
  str1 = '                                                                        0.0003';
  str1 = '                                            0.00                        0.0003';
elseif dvx == 0.0015
  str1 = '                                                                        0.0015';
  str1 = '                                            0.00                        0.0015';
else
  dvx
  error('huh unknown dvx')
end
fprintf(fid,' %9.3f %9.3f  %s \n',v1,v2,str1);

%%   IFORMAT, NLAYRS, NMOL, SECNTO,        ZH1=obs alt,       ZH2=end alt,    ZANGLE
%%      2     3-5,   6-10,  11-20,      41-48,     53-60,     66-73
%%    1X,I1    I3,    I5,   F10.2,  20X, F8.2,  4X, F8.2,  5X, F8.3
str = ' 1  1   12       1.0                        2.00        1.00';
  fprintf(fid,'%s \n',str);
 
%           PAVE(L), TAVE(L), SECNTK(L), ITYL(L),  IPATH, ALTZ(L-1), PZ(L-1), TZ(L-1), ATLZ(L), PZ(L), TZ(L)
%              1-10,   11-20,     21-30,   31-33,  34-35,     37-43,   44-51,   52-58,   59-65, 66-73, 74-80
%             F10.4,   F10.4,     F10.4,      A3,     I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2
% IF IFORM=1 from record 2.1, then the following format is used:
%              1-15,   16-25,     26-35,    36-38, 39-40,     42-48,   49-56,   57-63,   64-70, 71-78, 79-85
%             E15.7,   F10.4,     F10.4,       A3,    I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2
  
%% str = '   1.0853934E03  296.0000              1    1.00   1.500 296.00   2.00   0.500 296.00';
  fprintf(fid,'   %9.6e %9.4f              1    1.00 %4.2e %6.2f  1.00 %4.2e %6.2f \n',p,T,p,T,p,T);

for ii = 1 : 12
  molecule(ii) = -1;
end
molecule(gid) = q;
summolecule   = air;
summolecule   = n2;

%%%% gases 1-7 >>>>>>>>>>>>>>>>>>>>>>>>>>
clear str strx
for i=1:7
  str(1:15) = '               ';
  if molecule(i) < 0
      str(3:15) = '0.0000000E+00';
  else 
      str(3:15)=[num2str(abs(molecule(i))/10^floor(log10(abs(molecule(i)))),'%9.7f'),...
                  'E' num2str(floor(log10(abs(molecule(i)))),'%+03i')];
  end
  if molecule(i) < 0
      str(2) = '-';
  end
  strx((i-1)*15+1:i*15) = str;
end

%%%% gas ALL OTHERS >>>>>>>>>>>>>>>>>>>>>>>>>>
i=8;
  if summolecule > 0
    str(1:15) = '               ';
    str(3:15)=[num2str(abs(summolecule)/10^floor(log10(abs(summolecule))),'%9.7f'),...
            'E' num2str(floor(log10(abs(summolecule))),'%+03i')];
    strx((i-1)*15+1:i*15) = str;
  else
    clear str
    str = ' -0.0000000E+00';
    strx((i-1)*15+1:i*15) = str;
  end
fprintf(fid,'%s \n',strx);

%%%% gases 8-12 >>>>>>>>>>>>>>>>>>>>>>>>>>
clear str strx
for i=1:5
  str(1:15) = '               ';
  if molecule(i+7) < 0
      str(3:15) = '0.0000000E+00';
  else 
      str(3:15)=[num2str(abs(molecule(i+7))/10^floor(log10(abs(molecule(i+7)))),'%9.7f'),...
                  'E' num2str(floor(log10(abs(molecule(i+7)))),'%+03i')];
  end
  if molecule(i+7) < 0
      str(2) = '-';
  end
  strx((i-1)*15+1:i*15) = str;
end
fprintf(fid,'%s \n',strx);

%%% ----------------- mark the end of file -----------------------
%%% ----------------- mark the end of file -----------------------
%%% ----------------- mark the end of file -----------------------
str = '-1';
  fprintf(fid,'%s \n',str);
str = '%';
  fprintf(fid,'%s \n',str);

fclose(fid);
