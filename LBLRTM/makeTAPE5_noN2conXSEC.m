function qfactor = makeTAPE5_yesN2conXSEC(gid,v1,v2,ipfile,dvx,iLay,iTalk);

%% see http://web.gps.caltech.edu/~drf/misc/lblrtm/lblrtm_instructions.html

%% bdry is a optional structure that contains the [z,p,T] info for the two boundaries;
%% if they do not exit then p1 = p2 = p; T1 = T2 = T; z1 = 0, z2 = 2 km
%% can either do one gas (gid > 0) or 7 gases plus N2 (gid = -1)

%%% test with eg
%%% clc; gid=51; makeTAPE5_noN2conXSEC(gid,0605,0630,'ipfileTest',0.0025,2,1); disp(' '); disp(' '); eval(['!more TAPE5'])
%%%%%%%%%%%%%%%%%%%%%%%%%

kAvog = 6.022045e26;

if gid < 51 | gid > 63
  error('only gid 51-63 for LBLRTM XSEC')
elseif gid == 0
  error('huh NO gases???')
end

gas_profile = load(ipfile);
gas_profile = gas_profile(iLay,:);

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
  q  = gas_profile(5) * kAvog;   %% kmol/cm2 --> molecules/cm2

  mr = gas_profile(3)/gas_profile(2);    %% gasN partial pressure/total pressiure
  n2 = q*(1-mr)/mr;      %% N2 = rest of gases   --- this is what we do with UMBC LBL for broadening!
  air = q/mr;            %% N2 + gasN = total
else
  n2 = gas_profile(19) * kAvog;
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

str = '$ one layer only, ONE gas + everything else in N2 like UMBC-LBL  ';
  fprintf(fid,'%s \n',str);

%% Rayleigh extinction not calculated, all other continua calculated
%  str = ' HI=1 F4=1 CN=5 AE=0 EM=0 SC=0 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=1 XS=0    0    0';   
%  fprintf(fid,'%s \n',str);
%% Individual continuum scale factors input (Requires Record 1.2a)
  str = ' HI=1 F4=1 CN=6 AE=0 EM=0 SC=0 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=1 XS=1    0    0';
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
  str = ' 1.0 1.0 1.0 1.0 0.0 0.0 0.0';  %% ORIG
  if gid == 1
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% only want lines, and N2/O2 continuum
    str = ' 0.0 0.0 0.0 0.0 0.0 0.0 0.0';  %% only want lines    
  elseif gid == 2
    str = ' 0.0 0.0 1.0 0.0 1.0 1.0 0.0';  %% co2, and N2/O2 continuum
    str = ' 0.0 0.0 1.0 0.0 0.0 0.0 0.0';  %% co2    
  elseif gid == 3
    str = ' 0.0 0.0 0.0 1.0 1.0 1.0 0.0';  %% o3, and N2/O2 continuum
    str = ' 0.0 0.0 0.0 1.0 0.0 0.0 0.0';  %% o3    
  elseif gid == 7 | gid == 22
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% o2/n2
  else
    str = ' 0.0 0.0 0.0 0.0 1.0 1.0 0.0';  %% and N2/O2 continuum
    str = ' 0.0 0.0 0.0 0.0 0.0 0.0 0.0';  %% no cont    
  end
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
elseif dvx == 0.0015
  str1 = '                                                                        0.0015';
  str1 = '                                            0.00                        0.0015';
elseif dvx == 0.0001
  str1 = '                                                                        0.0001';
  str1 = '                                            0.00                        0.0001';
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

str = ' 1  1    7       1.0                        2.00        1.00';    %% for 7 gases+broad
i8or12 = 7;

fprintf(fid,'%s \n',str);
 
%           PAVE(L), TAVE(L), SECNTK(L), ITYL(L),  IPATH, ALTZ(L-1), PZ(L-1), TZ(L-1), ATLZ(L), PZ(L), TZ(L)
%              1-10,   11-20,     21-30,   31-33,  34-35,     37-43,   44-51,   52-58,   59-65, 66-73, 74-80
%             F10.4,   F10.4,     F10.4,      A3,     I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2
% IF IFORM=1 from record 2.1, then the following format is used:
%              1-15,   16-25,     26-35,    36-38, 39-40,     42-48,   49-56,   57-63,   64-70, 71-78, 79-85
%             E15.7,   F10.4,     F10.4,       A3,    I2,   1X,F7.2,    F8.3,    F7.2,    F7.2,  F8.3,  F7.2

fprintf(fid,'%15.7e%10.4f             %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f \n',p,T,1.0,z1,p1,T1,z2,p2,T2);
  
for ii = 1 : 63
  molecule(ii) = -1;
end

%% '8' is ALWAYS ALWAYS ALWAYS  gasID 8, not "other" and is on line 2;;;;; rememmber IATM = 0 not 1
if gid > 0
  molecule(gid) = q;
  if gid <= 7
    % molecule(8)  = n2;  %% broadening due to n2+o2   --- no need for this
  elseif gid == 22
    molecule(7)  = o2;
  else
    molecule(22) = n2;  %% put all broadening due to n2+o2  
  end
else
  !!! have sent in gas amounts for 7 molecules
  molecule(1:7) = gas_profile(12:18) * kAvog;
  % molecule(8)   = n2;  %% broadening due to n2+o2  -- no need for this
end

%summolecule   = air;
summolecule   = n2;

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
%%% these are XSEC depending on gid, all we want is ONE of them
%% these examples are IATM = 1
%%   /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/run_examples/run_example_nonlte/TAPE5) or
%%   /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/run_examples/run_example_user_defined_upwelling/TAPE5
%%
%% we need record 2.2 as IATM = 0

str = '    1    0    0';    %% just one gas!!! ;;;;; rememmber IATM = 0 not 1
fprintf(fid,'%s \n',str);

%% see ~/KCARTA/DOC/gasids_H2012 and TABLE II of http://web.gps.caltech.edu/~drf/misc/lblrtm/lblrtm_instructions.html
gname = gid_to_gname(gid);
fprintf(fid,'%s \n',gname);

% RECORD 2.2.2
%          IFRMX, NLAYXS, IXMOL, SECNTX, HEDXS
%            2      3-5,   6-10,  11-20, 21-80
%          1X,I1    I5,     I5,   F10.2,  15A4
str = ' 1  1    1             Cross-section Values'; %% just one layer, no  pressure deconv
%if gid <= 57
%  str = ' 1  1    7             Cross-section Values'; %% just one layer, yes pressure deconv
%else
%  str = ' 1  1   13             Cross-section Values'; %% just one layer, yes pressure deconv
%end
fprintf(fid,'%s \n',str);

%          PAVX,  TAVX,  SECKXS,  ITYX(L),  IPATX,  ALTX(L-1),  PX(L-1),  TX(L-1),  ATLX(L),  PX(L),  TX(L)
%          1-10, 11-20,   21-30,    31-33,  34-35,      37-43,    44-51,    52-58,    59-65,  66-73,  74-80
%         F10.4,  F10.4,    F10.4,     A3,     I2,    1X,F7.2,      F8.3,    F7.2,     F7.2,   F8.3,   F7.2
% so same as for MOLGAS
fprintf(fid,'%15.7e%10.4f             %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f \n',p,T,1.0,z1,p1,T1,z2,p2,T2);

%%%% gases 1-7 >>>>>>>>>>>>>>>>>>>>>>>>>>
clear str strx
strx = [];
for i = 51
  str = [' ' num2str(max(0,molecule(gid)),'%14.8e')];
  strx = [strx str];
end
fprintf(fid,'%s \n',strx);

%{
%%%% gas ALL OTHERS >>>>>>>>>>>>>>>>>>>>>>>>>> EIGHT on first row is ALWAYS broadeners
str = [' ' num2str(max(0,summolecule),'%14.8e')];
strx = [strx str];

if gid > 57
  %%%% gases 58-63 >>>>>>>>>>>>>>>>>>>>>>>>>>
  clear str strx
  strx = [];
  for i = (58 : 63)
    str = [' ' num2str(max(0,molecule(i)),'%14.8e')];
    strx = [strx str];
  end
  fprintf(fid,'%s \n',strx);
end
%}

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
