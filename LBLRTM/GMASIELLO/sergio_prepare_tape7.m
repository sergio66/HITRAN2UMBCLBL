%% link in all necessary LBLRTM files
if ~exist('lblrtm','file')
  disp('linking lblrtm and lnfl')
  lner = '!lner.sc';
  eval(lner);
end

clear all

altitude = load('/home/sergio/MATLABCODE/airsheights.dat')/1000.0;

%% prepare TAPE5
title = 'Set up KCARTA database';

vbound = [655 680];
tbound = 288.0;
pbound = load('/home/sergio/MATLABCODE/airslevels.dat');

for ii = 1 : 7
  stdprof = load('/home/sergio/SPECTRA/IPFILES/std_co2');
  if ii == 1
    fx = ['/home/sergio/SPECTRA/IPFILES/std_gx' num2str(ii) '_6_1'];
  else
    fx = ['/home/sergio/SPECTRA/IPFILES/std_gx' num2str(ii) '_6'];
  end
  stdprof = load(fx);
  pressure = stdprof(:,2)*1013.25;
  temperature = stdprof(:,4);
  wmol(:,ii)     = stdprof(:,3) ./stdprof(:,2) *1e6;
end

%% now need to extend to bdry
a1 = interp1(log(pressure),altitude,log(1100),[],'extrap');
a2 = interp1(log(pressure),altitude,log(0.005),[],'extrap');
altitude = [a1; altitude; a2];

t1 = interp1(log(pressure),temperature,log(1100),[],'extrap');
t2 = interp1(log(pressure),temperature,log(0.005),[],'extrap');
temperature = [t1; temperature; t2];
for ii = 1 : 7
  boo = wmol(:,ii);
  b1 = interp1(log(pressure),boo,log(1100),[],'extrap');
  b2 = interp1(log(pressure),boo,log(0.005),[],'extrap');
  woo(:,ii) = [b1; boo; b2];
end
wmol = woo;
pressure = [1100; pressure; 0.005];

nmolinp = 7;                       % 7 molecules
idmolinp = [1 2 3 4 5 6 7 ];       % gasIDs
unitinp  = 'AAAAAAA';              % ppmv

CN       = 1;       % continuum
cnt_mul  = [1 1 1]; % continuum mult
aflag = 1;

altitude = altitude - altitude(1);
surfaceHgt = altitude(1); 
obsHgt     = +max(altitude);
viewangle  = 180.0;
  hbound = [surfaceHgt+0.000001   obsHgt-0.000001  viewangle];
  hbound = [1 80  viewangle];
  %hbound = [1100.0       0.005   viewangle];

wt5_new(title,hbound,vbound,tbound,pbound,altitude,pressure,temperature,nmolinp,idmolinp,unitinp,wmol,...
        aflag,CN,cnt_mul);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
clear try2
try2.v1 = vbound(1); 
try2.v2 = vbound(2);
try2.observer_angle = viewangle;
try2.pz_obs  = min(pbound);
try2.pz_surf = max(pbound);
try2.t_surf  = interp1(log(pressure),temperature,log(max(pbound)),[],'extrap');
try2.pz_levs = temperature;
try2.model   = 0;
  try2.full_atm(:,1) = altitude- altitude(1);
  try2.full_atm(:,2) = pressure;
  try2.full_atm(:,3) = temperature;
  try2.species_vec = ones(1,32);
  try2.full_atm(:,4:35) = zeros(100,32);
  try2.full_atm(:,4:10) = wmol;
try2.ILS = 0;
try2.Flag_Vec.P_or_Z = 1;
try2.Flag_Vec.Rad_or_Trans = 1;
try2.Flag_List(1,:) = 'P_or_Z      ';
try2.Flag_List(2,:) = 'Rad_or_Trans';
try2.Flag_Vec = [0 0 0 0 0 0 0];
try2.Flag_List = ...
    str2mat('Aerosol_Flag','LNFL_Flag','P_or_Z', ...
        'Rad_or_Trans','RH_Flag','Solar_Flag','Temp_Flag');
try2.Directory_List = str2mat('LBLRTM','LNFL','RADSUM','CHARTS');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Edit these variables to point towards your installation directory for LBLRTM, LNFL,RADSUM, and CHARTS 
try2.Directory_Mat = ...
    str2mat('/home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_MASIELLO_H12/', ... %location of lblrtm executable
             '/home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_MASIELLO_H12/', ...   %location of lnfl executable
	     '/home/hermes_rd1/drf/lblrtm/radsum/',...  %location of radsum executable
	     '/home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_MASIELLO_H12/');           %location of charts executable
try2.Directory_List = str2mat('LBLRTM','LNFL','RADSUM','CHARTS');
try2.executable_names = str2mat('lblrtm_v11.1_pgi_linux_pgf90_dbl', 'lnfl_v2.1_pgf90_pgi_linux_sgl',...
          				     'radsum_v2.4_linux_pgi_f90_dbl',    'charts_lblv8.sgl');
write_charts_tape5(try2);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% now run LBLRTM
lbler = ['!lblrtm'];
eval(lbler)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read TAPE7
[t7] = tape7_read('TAPE7');
[data] = tape7_read('TAPE7');

%% save off equivalent atmos_data3.mat
data.pave = pressure;
data.tave = temperature;
save atmos_data3.mat data

%% re-prepare TAPE5 with actual params
wt5l(2,0,-1,655,680);

%% reead in ODs
odread()

