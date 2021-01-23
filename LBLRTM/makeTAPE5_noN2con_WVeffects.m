function qfactor = makeTAPE5_noN2con_WVeffects(gidIN,v1,v2,ipfile,ipfilewv,dvx,iLay,iTalk);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% see lnfl/src/lnfl.F, line 4312
%%               ADDDATA(1,IND) = HW_CO2_H2O(IW)
%%               ADDDATA(2,IND) = TEMP_CO2_H2O(IW)
%%               ADDDATA(3,IND) = SHFT_CO2_H2O(IW)
%%
%% see lblrtm/src/oprop.f90 line 804, it reads in all the broadeners
%%   which includes WV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% if ipfilewv == [] it assumes layering is SAME as US Std Water, so it can include those effects

%% bdry is a optional structure that contains the [z,p,T] info for the two boundaries;
%% if they do not exit then p1 = p2 = p; T1 = T2 = T; z1 = 0, z2 = 2 km
%% can either do one gas (gid > 0) or 7 gases plus N2 (gid = -1)

%%% test with eg
%%% clc; gid=1; makeTAPE5_noN2con(gid,0605,0630,'ipfileTest',0.0025,2,1); disp(' '); disp(' '); eval(['!more TAPE5'])
%%%%%%%%%%%%%%%%%%%%%%%%%

kAvog = 6.022045e26;

if gidIN == 101 | gidIN == 102 | gidIN == 103
  gid = 1;
else
  gid = gidIN;
end

if gid > 47
  error('been too lazy to code up more than 47 gases!')
elseif gid == 0
  error('huh NO gases???')
end

%ipfileUSStdWV = load('/home/sergio/SPECTRA/IPFILES/std_water');
if length(ipfilewv) == 0
  disp('ooops need to use US std for WV profile in makeTAPE5_noN2con_WVeffects.m')
  wv_profile = load('std_water');
else
  wv_profile = load(ipfilewv);
end
disp(' ')
disp(' >>>>>>> .... loaded in WV profile for WV-GID broadening ....... <<<<<<<<<<')
disp(' ')

wv_profile = wv_profile(iLay,:);

gas_profile = load(ipfile);
gas_profile = gas_profile(iLay,:);

if length(iLay) == 1
  fprintf(1,'US Std WV   for layer %3i : p,pp,T,q = %8.5f %8.5f %8.5f %8.6e \n',iLay,wv_profile(2:5));
  fprintf(1,'Gas Profile for layer %3i : p,pp,T,q = %8.5f %8.5f %8.5f %8.6e \n',iLay,gas_profile(2:5));
end

[mm,nn] = size(gas_profile);
if nn == 5
  disp('have iI <P> <PP> <T> q')
elseif nn == 11
  disp('have iI <P> <PP> <T> q   AND   z1 p1 T1 z2 p2 T2')
  bdry.z1 = gas_profile(6);  %% km
  bdry.p1 = gas_profile(7);  %% atm
  bdry.T1 = gas_profile(8);  %% K
  
  bdry.z2 = gas_profile(9);
  bdry.p2 = gas_profile(10);  
  bdry.T2 = gas_profile(11);  
elseif nn == 19
  disp('have iI <P> <PP> <T> q   AND   z1 p1 T1 z2 p2 T2')
  bdry.z1 = gas_profile(6);  %% km
  bdry.p1 = gas_profile(7);  %% atm
  bdry.T1 = gas_profile(8);  %% K
  
  bdry.z2 = gas_profile(9);
  bdry.p2 = gas_profile(10);  
  bdry.T2 = gas_profile(11);  
else
  [mm nn]
  error('need either 5 columns (one gas, only <lay> info) or 11 columns (one gas, also bdry info) or 19 columns (7+1 gases, also bdry info)')
end

p  = gas_profile(2) * 1013.25;       %% change from atm to mb
pp = gas_profile(3) * 1013.25;       %% change from atm to mb
T  = gas_profile(4);

if nn <= 11
  %% lblatm.f90 says in lower atm, that O2,N2 mix ratios are 20.9 and 78.1 respectively
  %% lblatm.f90 says in lower atm, that O2,N2 mix ratios are 20.9 and 78.1 respectively
  %% lblatm.f90 says in lower atm, that O2,N2 mix ratios are 20.9 and 78.1 respectively

  q   = gas_profile(5) * kAvog;   %% kmol/cm2 --> molecules/cm2
  qwv = wv_profile(5) * kAvog;    %% kmol/cm2 --> molecules/cm2

  mr   = gas_profile(3)/gas_profile(2);    %% gasN  partial pressure/total pressure
  mrwv = wv_profile(3)/gas_profile(2);     %% gasWV partial pressure/total pressure

  n2 = (q+qwv)*(1-mr-mrwv)/(mr+mrwv);      %% N2 = rest of gases   --- this is what we do with UMBC LBL for broadening!
  air = (q+qwv)/(mr+mrwv);                 %% N2 + gasN = total
else
  n2 = gas_profile(19) * kAvog;
  qwv = wv_profile(5) * kAvog;    %% kmol/cm2 --> molecules/cm2
end

q0 = q;
qfactor = 1.0;
if q < 1
 q = 1.0e5;
 qfactor = q0/q;
end

if gid == 22
  o2 = n2;
else
  o2 = 0.0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 5
  iLay = 1;
  iTalk = +1;
elseif nargin == 6
  iTalk = +1;
elseif nargin < 5
  error('need at least 5 args for makeTAPE5')
end

if ~exist('bdry')
  p1 = p;
  p2 = p;
  T1 = T;
  T2 = T;
  z1 = 0.0;
  z2 = 2.0;
else
  p1 = bdry.p1 * 1013.25;
  p2 = bdry.p2 * 1013.25;
  T1 = bdry.T1;
  T2 = bdry.T2;  
  z1 = bdry.z1;
  z2 = bdry.z2;
end

if iTalk > 0 & nn <= 11
  fprintf(1,'p = %15.7e mb  T = %15.7e K ,mr = %8.6e \n',p,T,mr);
  fprintf(1,'  gas = %15.7e  molecules/cm2    n2 = %15.7e  molecules/cm2 air = %15.7e  molecules/cm2\n',q,n2,air);
else
  fprintf(1,'p = %15.7e mb  T = %15.7e K   q = %15.7e \n',p,T,q);
end

%% http://shadow.eas.gatech.edu/~vvt/lblrtm/lblrtm_inst.html
fid = fopen('TAPE5','w');

%% RECORD 1.1
str = '$ one layer only, ONE gas + everything else in N2 like UMBC-LBL  ';
  fprintf(fid,'%s \n',str);

%% RECORD 1.2
%% Rayleigh extinction not calculated, all other continua calculated
%  str = ' HI=1 F4=1 CN=5 AE=0 EM=0 SC=0 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=1 XS=0    0    0';   
%  fprintf(fid,'%s \n',str);

%% Individual continuum scale factors input (Requires Record 1.2a)
  str = ' HI=1 F4=1 CN=6 AE=0 EM=0 SC=0 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=1 XS=0    0    0';
  fprintf(fid,'%s \n',str);
  %%          XSELF, XFRGN, XCO2C, XO3CN, XO2CN, XN2CN, XRAYL
  %%          free format
  %%           XSELF  H2O self broadened continuum absorption multiplicative factor
  %%           XFRGN  H2O foreign broadened continuum absorption multiplicative factor
  %%           XCO2C  CO2 continuum absorption multiplicative factor
  %%           XO3CN  O3 continuum absorption multiplicative factor
  %%           XO2CN  O2 continuum absorption multiplicative factor
  %%           XN2CN  N2 continuum absorption multiplicative factor
  %%             XRAYL  Rayleigh extinction multiplicative factor

%% RECORD 1.2a
  str = ' 1.0 1.0 1.0 1.0 0.0 0.0 0.0';  %% ORIG
  if gidIN == 1
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% only want lines, and N2/O2 continuum
    str = ' 0.0 0.0 0.0 0.0 0.0 0.0 0.0';  %% only want lines    
  elseif gidIN == 2
    str = ' 0.0 0.0 1.0 0.0 1.0 1.0 0.0';  %% co2, and N2/O2 continuum
    str = ' 0.0 0.0 1.0 0.0 0.0 0.0 0.0';  %% co2    
  elseif gidIN == 3
    str = ' 0.0 0.0 0.0 1.0 1.0 1.0 0.0';  %% o3, and N2/O2 continuum
    str = ' 0.0 0.0 0.0 1.0 0.0 0.0 0.0';  %% o3    
  elseif gidIN == 7 | gidIN == 22
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% o2/n2
  elseif gidIN == 101
    str = ' 1.0 0.0 0.0 0.0 0.0 0.0 0.0';  %% self cont, need to subtract gid == 1 run from this
  elseif gidIN == 102
    str = ' 0.0 1.0 0.0 0.0 0.0 0.0 0.0';  %% forn cont, need to subtract gid == 1 run from this    
  else
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% N2/O2 continuum
    str = ' 0.0 0.0 0.0 0.0 0.0 0.0 0.0';  %% no cont    
  end
  fprintf(fid,'%s \n',str);

%% RECORD 1.3
%%             V1,     V2,   SAMPLE,   DVSET,  ALFAL0,   AVMASS,   DPTMIN,   DPTFAC,   ILNFLG,     DVOUT,   NMOL_SCAL
%%           1-10,  11-20,    21-30,   31-40,   41-50,    51-60,    61-70,    71-80,     85,      90-100,         105
%%          E10.3,  E10.3,    E10.3,   E10.3,   E10.3,    E10.3,    E10.3,    E10.3,    4X,I1,  5X,E10.3,       3x,I2 
%% dvx = input/out res for LBLRTM .. this is BEFORE the final boxcar integration over 5 points

%%%    0        1         2         3         4         5         6         7         8         9
%%%    1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
str = '  2080.000  2180.000                                                                          0.0005';

%% but fprintf(fid,' %9.3f %9.3f  %s \n',v1,v2,str1); means we are pre-loading with two f10.3 so that is already starting at 21
%%%       2        3         4         5         6         7         8         9         10         11
%%%       1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
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
elseif dvx == 0.0015
  str1 = '                                                                        0.0015';
  str1 = '                                            0.00                        0.0015';
elseif dvx == 0.0001
  str1 = '                                                                        0.0001';
  str1 = '                                            0.00                        0.0001';
elseif dvx == 0.0002/5
  str1 = '                                                                       0.00004';
  str1 = '                                            0.00                       0.00004';
elseif dvx == 0.0001/5
  str1 = '                                                                       0.00002';
  str1 = '                                            0.00                       0.00002';
elseif dvx == 1/5   %% for continuum
  str1 = '                                                                        0.2000';
  str1 = '                                            0.00                        0.2000';
else
  dvx
  error('huh unknown dvx')
end
fprintf(fid,' %9.3f %9.3f  %s \n',v1,v2,str1);

%%   IFORMAT, NLAYRS, NMOL, SECNTO,        ZH1=obs alt,       ZH2=end alt,    ZANGLE
%%   12345678901234567789012345678901234567890123456789012345678901234567890123456778901234567890
%%      2     3-5,   6-10,  11-20,      41-48,     53-60,     66-73
%%    1X,I1    I3,    I5,   F10.2,  20X, F8.2,  4X, F8.2,  5X, F8.3
%%     12345678901234567789012345678901234567890123456789012345678901234567890123456778901234567890

i8or12 = -1;
if gid <= 7
  str = ' 1  1    7       1.0                        2.00        1.00';    %% for 7 gases+broad
  i8or12 = 7;
elseif gid < 22
  str = ' 1  1   23       1.0                        2.00        1.00';    %% for 23 gases, excluding N2
  i8or12 = 23;    
elseif gid <= 23
  str = ' 1  1   23       1.0                        2.00        1.00';    %% for 23 gases, excluding N2
  i8or12 = 23;    
elseif gid <= 31
  str = ' 1  1   31       1.0                        2.00        1.00';    %% for 31 gases, excluding N2
  i8or12 = 31;    
elseif gid <= 39
  str = ' 1  1   39       1.0                        2.00        1.00';    %% for 39 gases, excluding N2
  i8or12 = 39;    
elseif gid <= 47
  str = ' 1  1   47       1.0                        2.00        1.00';    %% for 39 gases, excluding N2
  i8or12 = 47;    
else
  gid
  error('gid???')
end
fprintf(fid,'%s \n',str);
 
%           PAVE(L), TAVE(L), SECNTK(L), ITYL(L),  IPATH, ALTZ(L-1), PZ(L-1), TZ(L-1), ATLZ(L), PZ(L), TZ(L)
%              1-10,   11-20,     21-30,   31-33,  34-35,     37-43,   44-51,   52-58,   59-65, 66-73, 74-80
%             F10.4,   F10.4,     F10.4,      A3,     I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2
% IF IFORM=1 from record 2.1, then the following format is used:
%              1-15,   16-25,     26-35,    36-38, 39-40,     42-48,   49-56,   57-63,   64-70, 71-78, 79-85
%             E15.7,   F10.4,     F10.4,       A3,    I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2
  
iDebug = +1;
iDebug = -1;
if iDebug > 0
  strx = '   1.0853934E03  296.0000              1    1.00   1.500 296.00   2.00   0.500 296.00';
  junk = ' 9.8387588e+02  288.9900    1.0000        0.00 983.876 288.99   2.00 983.876 288.99';
  strx = '         1          2         3         4         5         6         7          8         9';
  fprintf(1,'%s \n',strx);
  strx = '12345678901234567789012345678901234567890123456789012345678901234567890123456778901234567890';
  fprintf(1,'%s \n',strx);
  fprintf(1,'   %9.6e %9.4f              1    1.00 %4.2e %6.2f  1.00 %4.2e %6.2f \n',p,T,p,T,p,T);
  fprintf(1,'   %9.6e %9.4f              1  %6.2f %4.2e %6.2f%6.2f %4.2e %6.2f \n',p,T,z1,p1,T1,z2,p2,T2);
  fprintf(1,'%15.7e%10.4f             %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f \n',p,T,1.0,z1,p1,T1,z2,p2,T2);
  strx = '12345678901234567789012345678901234567890123456789012345678901234567890123456778901234567890';
  fprintf(1,'%s \n',strx);
  error('kl;lk')
else
  %  fprintf(fid,'   %9.6e %9.4f              1    1.00 %4.2e %6.2f  1.00 %4.2e %6.2f \n',p,T,p,T,p,T);
  %  fprintf(fid,'   %9.6e %9.4f              1    %6.2f %4.2e %6.2f %6.2f %4.2e %6.2f \n',p,T,z1,p1,T1,z2,p2,T2);
  fprintf(fid,'%15.7e%10.4f             %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f \n',p,T,1.0,z1,p1,T1,z2,p2,T2);
end

for ii = 1 : 48
  molecule(ii) = -1;
end

%% '8' is ALWAYS ALWAYS ALWAYS  gasID 8, not "other" and is on line 2 ;;;;; rememmber IATM = 0 not 1
if gid > 0
  molecule(1)   = qwv; %% %OOPS IF YOU TURN THIS ON THEN WV line pops up
  molecule(gid) = q;
  if gid <= 7
    % molecule(8)  = n2;  %% broadening due to n2+o2   --- no need for this
  elseif gid == 22
%    molecule(7)  = o2;  %% put all broadening due to n2+o2 NO NEED  
%  else
%    molecule(22) = n2;  %% put all broadening due to n2+o2 NO NEED  
  end
else
  !!! have sent in gas amounts for 7 molecules
  molecule(1:7) = gas_profile(12:18) * kAvog;
  % molecule(8)   = n2;  %% broadening due to n2+o2  -- no need for this
end

%summolecule   = air;
if gid ~= 22
  %% pre Sept 2016
  summolecule   = n2;
elseif gid == 22
  %% post Sept 2016
  disp('gid == 22 ==> interested in N2 ==> set summolecule == 0!!!!')
  summolecule   = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% these are MANDATORY

%%%% gases 1-7 >>>>>>>>>>>>>>>>>>>>>>>>>>
clear str strx
strx = [];
for i = 1 : 7
  str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
  strx = [strx str];
end

%%%% gas ALL OTHERS >>>>>>>>>>>>>>>>>>>>>>>>>> EIGHT on first row is ALWAYS broadeners
str = [' ' num2str(max(0,summolecule),'%14.8e')];
strx = [strx str];
fprintf(fid,'%s \n',strx);

%else
%  i = 8;
%  str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
%  strx = [strx str];
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% these are OPTIONAL depending on gid

if i8or12 >= 23
  %%%% gases 9-16 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];
  for i = (9 : 16)-1
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);

  %%%% gases 17-24 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];  
  for i = (17 : 24)-1
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);
end

if i8or12 >= 31
  %%%% gases 25-31 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];  
  for i = (25 : 32)-1
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);
end

if i8or12 >= 39
  %%%% gases 32-39 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];  
  for i = (33 : 40)-1
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);
end

if i8or12 >= 47
  %%%% gases 40-47 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];  
  for i = (41 : 48)-1
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);
end

%%% ----------------- mark the end of file -----------------------
%%% ----------------- mark the end of file -----------------------
%%% ----------------- mark the end of file -----------------------
str = '-1';
  fprintf(fid,'%s \n',str);
str = '%';
  fprintf(fid,'%s \n',str);

fclose(fid);

%gid
%error('opened/closed tape5')

% thisdir = pwd;
% fprintf(1,'pwd = %s \n',thisdir)
