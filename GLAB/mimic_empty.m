
% mimic_empty

load  GasCell_Stage2

% Frequency correction
f_corr = -1.8 ;
freq = freq + f_corr ;

% Estimate continuum using below frequencies.
fx  = ( [ 660.4 661.6 663.5 665.4 676.8 678.8 679.9 ] + f_corr )' ;

% Estimate deepest part of spectrum
f_abs  = [ 669.7 ] + f_corr ;

addpath /asl/matlib/aslutil/
addpath /asl/matlib/plotutils



% Assume blackbody temperature (K) values for the cell measurements
% These were selected to produce the desired 1.61 ratio
T1 = 320.0 ;  % 320.0 ;
T2 = 376.0 ;  % 368.0 ;

r1 = bt2rad( 670.0, T1 ) ; 
r2 = bt2rad( 670.0, T2 ) ; 

sf = r2 / r1 ;

figure ; clf
plot( freq, real(cellHot.s0p(:,5,100)), 'r' )
hold on
plot( freq, real(cellCold.s0p(:,5,100)), 'b' )
plot( freq, real(cellCold.s0p(:,5,100))*sf, 'b--' )
xlim([660 680]); 
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Counts' ) ;
title( 'Empty cell spectra' ) ;
text( 662, 5.d4, 'Hot cell & Scaled Cold cell' ) ;
text( 662, 4.d4, 'Cold cell' ) ;
aslprint( 'Fig/EmptyCellSpectraHotCold.png' ) ;

ind = find( freq >= 660 & freq <= 680  ) ;

f  = freq( ind ) ;
s1 = mean( squeeze( cellCold.s0p(ind,5,100:200) ), 2 ) ;
s2 = mean( squeeze( cellHot.s0p(ind,5,100:200) ), 2 ) ;

% Establish baseline for cell cold
%p1 = polyfit( [f(1:14)', f(18:32)'], [s1(1:14)',s1(18:32)'], 1 ) ;
%r1 = polyval( p1, f ) ;

% Establish baseline for cell hot
%p2 = polyfit( [f(1:14)', f(18:32)'], [s2(1:14)',s2(18:32)'], 1 ) ;
%r2 = polyval( p2, f ) ;

% Establish basline for hot,cold subtracted 
s = squeeze( s2 - s1 ) ;
p = polyfit( [f(1:14)', f(18:32)'], [s(1:14)',s(18:32)'], 1 ) ;
r = polyval( p, f ) ;



% Establish the continuum using the points representative of the baseline
rx  = interp1( f, s, fx ) ;

% Extend this grid to observational range. Now we can compare 
% the spectroscopy in variable 's' with continuum in variable 'ry' 
% with frequency vector in variable 'f'. 
ry  = interp1( fx, rx, f ) ;

% An approximate transmittance 
trans = s ./ ry ;

% Interpolate to frequency positions corresponding to Q-branch 
% and find the transmittance at the Q-branch strongest point. 
r_cont = interp1( fx, rx, f_abs ) ;
r_abs  = interp1( f, s, f_abs ) ;

trans0 = r_abs / r_cont ;


figure ; clf
plot( f, s )
hold on
plot( fx, rx, 'r' )
xlim([660 680]); 
plot( f_abs, r_abs, 'bo' )
plot( f_abs, r_cont, 'ro' )

xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Counts' ) ;
title( ' (Hot-Cold) Empty cell spectra' ) ;

aslprint( 'Fig/EmptyCellSpectraDiff.png' ) ;



rx1 = interp1( freq, cellCold.s0p(:,5,100), fx ) ;
rx2 = interp1( freq, cellHot.s0p(:,5,100), fx ) ;

% Interpolate to frequency positions corresponding to Q-branch 
f_abs  = [ 669.7 ] ;
r_cont1 = interp1( fx, rx1, f_abs ) ;
r_abs1  = interp1( freq, cellCold.s0p(:,5,100), f_abs ) ;

r_cont2 = interp1( fx, rx2, f_abs ) ;
r_abs2  = interp1( freq, cellHot.s0p(:,5,100), f_abs ) ;



%figure ; clf
%plot( freq, real(cellCold.s0p(:,5,100)) )
%hold on
%plot( fx, rx1, 'b--' )
%xlim([660 680]); 
%plot( f_abs, r_abs1, 'bx' )
%plot( f_abs, r_cont1, 'bx' )
%plot( freq, real(cellHot.s0p(:,5,100)) )
%hold on
%plot( fx, rx2, 'r--' )
%xlim([660 680]); 
%plot( f_abs, r_abs2, 'rx' )
%plot( f_abs, r_cont2, 'rx' )
%xlabel( '\nu (cm^{-1})' ) ;
%ylabel( 'Counts' ) ;
%title( 'Empty cell spectra' ) ;

%trans1 = r_abs1 / r_cont1 ;
%trans2 = r_abs2 / r_cont2 ;


glabRoot = '/home/tilak/glab/CO2_Sep2013/' ;
a1  = load( [ glabRoot 'genlndat-1T' ] ) ; 
a5  = load( [ glabRoot 'genlndat-5T' ] ) ;
a10 = load( [ glabRoot 'genlndat-10T' ] ) ;
a20 = load( [ glabRoot 'genlndat-20T' ] ) ;
a0  = load( [ glabRoot 'genlndat-StdAtmCO2' ] ) ;

t1  = exp( -a1.absc ) ;
t5  = exp( -a5.absc ) ;
t10 = exp( -a10.absc ) ;
t20 = exp( -a20.absc ) ;
t0  = exp( -a0.absc ) ;
f0   = a1.fr ;

addpath /asl/packages/ccast/source
addpath /asl/packages/airs_decon/test

wlaser = 771.6049 ; 764.6 ;
[ inst1, user1 ]    = inst_params( 'LW', wlaser ) ;

[ xt1, xf,  opt ]  = kc2cris( inst1, user1, t1,  f0 ) ;
[ xt5, xf,  opt ]  = kc2cris( inst1, user1, t5,  f0 ) ;
[ xt10, xf, opt ]  = kc2cris( inst1, user1, t10, f0 ) ;
[ xt20, xf, opt ]  = kc2cris( inst1, user1, t20, f0 ) ;
[ xt0, xf,  opt ]  = kc2cris( inst1, user1, t0,  f0 ) ;

figure ; clf
plot( xf, xt1, xf, xt5, xf, xt10, xf, xt20 ) 
hold on
xlim( [ 660 680 ] );
plot([660 680], [1 1], 'k')
legend( '1T', '5T', '10T', '20T', 'Location', 'Best' ) ;
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Transmittance' ) ;
title( 'GENLN2 calculated transmittance' ) ;

aslprint( 'Fig/GENLN2-simulations.png' ) ;




% The GENLN2 runs for 10 cm path length
f_sel = 668.1 ;
c_ind = find( xf >= f_sel-0.1 & xf <= f_sel+0.1 ) ;
c_cog = [ xt1(c_ind)  xt5(c_ind)  xt10(c_ind) xt20(c_ind) ] ;
pres_cm  = [ 1.0, 5.0, 10.0, 20.0 ] * 10 ;

% What is in the total path of the cold cell
pres_cm0 = interp1( c_cog, pres_cm, trans0 ) ;

figure ; clf
plot( pres_cm, c_cog )
hold on
plot( pres_cm0, trans0, 'ro' )
xlabel( 'Length x Pressure (cm-Torr)' ) ;
ylabel( 'Transmittance' ) ;
title( 'Dependence on Optical Path' ) ;
text( round(pres_cm0)+10, trans0, ... 
      [num2str(round(pres_cm0)) ' cm-T, ' num2str(trans0)  ] ) ;
hold off

p1 = pres_cm0 / 10.0 ;
l1 = pres_cm0 / ( 760*400.0d-6 ) ;

text( 10, 0.2, [ '10-cm CO_{2} cell with ' num2str(p1) ' Torr' ] ) ;
text( 10, 0.1, [ '760T/400ppm CO_{2} along ' num2str(l1) ' cm' ] ) ;

aslprint( 'Fig/Source-EmptyCellGas.png' ) ;


figure ; clf
plot( f, s, f, ry ) 
xlim( [ 660 680 ] );
legend( 'Empty Cell', 'Baseline', 'Location', 'SouthEast' ) ;
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Counts' ) ;
title( '660 cm^{-1} Q-branch region' ) ;
text( 660.5, 23000, ['I_{\nu}(T_C)=(1-t_{\nu})t_{\nu,in}B_{\nu}(T_g)+' ...
                    't_{\nu}t_{\nu,in}B_{\nu}(T_C) + BG' ] );
text( 660.5, 21500, ['I_{\nu}(T_H)=(1-t_{\nu})t_{\nu,in}B_{\nu}(T_{g*})+' ...
                    't_{\nu}t_{\nu,in}B_{\nu}(T_H) + BG' ] ); 
text( 660.5, 20000, ['Baseline:  C_{\nu}=t_{\nu}[B_{\nu,in}(T_H)-B_{\nu}(T_C)]'] ) ;
text( 660.5, 18500, ['t_{\nu} = [I_{\nu}(T_H)-I_{\' ...
                    'nu}(T_C)]/C_{\nu}; for T_g=T_{g*} '] ) ; 
aslprint( 'Fig/EmptyCell-Baseline.png' ) ;


% Scale the 1 Torr 10-cm absorption to some partial pressure for a
% 12.6-cm cell to match the observed. We need a factor of 1.8;
% i.e., 1.8*1 Torr and 12.6 cm path length. 
t2  = exp( -1.8*a1.absc*(12.6/10) ) ;
[ xt2, xf,  opt ]  = kc2cris( inst1, user1, t2,  f0 ) ;

% Scale the 10-cm length with 760 Torr air and 400 ppm of CO2 to 
% a 100-cm length with some partial pressure; i.e., 40 ppm in a 100
% cm path length broadened by 760 Torr total pressure. 
t0  = exp( -0.09*a0.absc*(100/10) ) ;
[ xt0, xf,  opt ]  = kc2cris( inst1, user1, t0,  f0 ) ;

figure ; clf
plot( xf, xt2, 'b',  f, trans, 'r', xf, xt0, 'g' ) ;
hold on
xlim( [ 660 680 ] );
legend( 'GENLN2 12.6cm with 1.8 Torr',  ...
        'Empty Cell (Hot-Cold)/Basline', ... 
        'GENLN2 100cm with 760Torr 0.09x400ppm', ... 
        'Location', 'SouthEast' ) ;
plot([660 680], [1 1], 'k')
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Transmittance' ) ;
title( 'CrIS Empty Cell & Calculated (CrIS res) transmittance' ) ;
hold off
aslprint( 'Fig/EmptyCell-CrIS-Res-760T400ppm.png' ) ;



figure ; clf
plot( f0, t2, 'g', f, trans, 'r', f0, t0, 'b' ) ;
xlim( [ 660 680 ] );
ylim( [ 0 1.1 ] ) ;
legend( '12.6cm with 1.8 Torr',  ...
        'Empty Cell (Hot-Cold)/Basline', ... 
        '100cm with 760Torr 0.09x400ppm', ... 
        'Location', 'SouthWest' ) ;
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Transmittance' ) ;
title( 'CrIS Empty Cell & Monochromatic calculated transmittance' ) ;
aslprint( 'Fig/EmptyCell-MonoChrom-760T400ppm.png' ) ;


p0 = load ('CO2_Sep2013/genlndat-22T-303K') ;
p1 = load ('CO2_Sep2013/genlndat-StdAtmCO2') ;
p2 = load ('LW_H2O/genlndat') ;
z0 = exp( -p0.absc ) ;
z1 = exp( -p0.absc + p1.absc + p2.absc*10 ) ; 
[ xz0, xf, opt] = kc2cris( inst1, user1, z0, p0.fr ) ;
[ xz1, xf, opt] = kc2cris( inst1, user1, z1, p0.fr ) ;


