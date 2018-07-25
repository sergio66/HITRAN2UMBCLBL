
% 

addpath /asl/matlib/aslutil/
addpath /asl/matlib/plotutils

glabRoot = '/home/tilak/glab/CO2_Sep2013/' ;
a1  = load( [ glabRoot 'genlndat-20T-303K' ] ) ; 
a2  = load( [ glabRoot 'genlndat-20T-303K-40T' ] ) ; 

t1 = exp( -a1.absc ) ;
t2 = exp( -a2.absc ) ;

f0 = a1.fr ;

addpath /asl/packages/ccast/source
addpath /asl/packages/airs_decon/test

wlaser = 771.6049 ; 764.6 ;
[ inst1, user1 ]    = inst_params( 'LW', wlaser ) ;

[ xt1, xf, opt ]   = kc2cris( inst1, user1, t1, f0 ) ;
[ xt2, xf, opt ]   = kc2cris( inst1, user1, t2, f0 ) ;


p_part   = 20.0 / 760.0 ; % Convert Torr to atm
p_tot    = 20.0 / 760.0 ;
cell_len = 10.0 ; % cm
temp     = 273.15 + 30.45  ; % Convert C to K
L_RT     = cell_len / ( 82.057 * temp ) * 1.0d-3 ; % kilomoles/cm2
gasAmt   =  p_part * L_RT ;

run8File = '/home/tilak/glab/co2_cell' ;
fid = fopen( run8File, 'w' ) ;
fprintf( fid, '%i %f  %f  %f %d\n', ...
         [1, p_tot, p_part, temp, gasAmt ] ) ;
fclose( fid) ; 

% UMBC line mixing
topts.hartmann_linemix = -1 ; 
[ f, tau ] = run8co2(  2, 650, 700, ...
                       run8File, topts ) ;

df   =  median( f(:) - circshift(f(:),1) ) ;
vec1 = (1:(round((min(f)-df-inst1.vdfc)/df)))*df + inst1.vdfc ;
vec2 = (1:(round( ( inst1.vdfc+inst1.awidth-max(f)+df)/df)))*df + max(f) ;

f0   = [ vec1, f, vec2 ] ;
t0   = [ ones( 1,length(vec1) ), exp(-tau), ones( 1,length(vec2) ) ] ;
[zt,zf,opt] = kc2cris( inst1, user1, t0, f0 ) ;


figure ; clf
plot( xf, xt1, 'b', zf, zt, 'r', xf, xt2, 'g' ) 
hold on
xlim( [ 660 680 ] );
%plot([660 680], [1 1], 'k')
legend( 'Pure CO_{2} 20T (Glab)', ...
        'Pure CO_{2} 20T (run8)', ... 
        'CO_{2} 20T + 20T Air (Glab)', ...
        'Location', 'SouthEast' ) ;
xlabel( '\nu (cm^{-1})' ) ;
ylabel( 'Transmittance' ) ;
title( 'GENLN2 simulation of cell pressures of 20T & 40T' ) ;
aslprint( 'GENLN-Run8-Co2-Pure-Mix.png' ) ;



%topts.hartmann_linemix = -1 ; 
%[ f1, tau1 ] = run8co2(  2, 650, 700, run8File, topts ) ;


