
% function fit_gas() 

addpath /asl/packages/ccast/source
addpath /asl/packages/airs_decon/test


global pres freq absc pStore iCount user1 inst1


load( 'AbsCoef-Pres' ) ;

freq = (absCoef.f)' ;
absc = absCoef.absc ;
pres = absCoef.pres ;




tran0 = interp2( freq, pres, absc', freq, 25.0 ) ;

wlaser = 764.6 ;
[ inst1, user1 ]    = inst_params( 'LW', wlaser ) ;

data = fit_gas_funct( [605.,0.0025,31.0], xdata ) ;

df     = median( freq - circshift( freq, [0,1] ) ) * 1.05 ;
pvals0 = [ min(freq)+0.5, df, 31.0 ] ; 
pvals_lo = [ min(freq)-0.5, 0.002, 5.0 ] ;
pvals_up = [ min(freq)+0.5, 0.003, 100.0 ] ;

pStore   = zeros( 3, 300 ) ;
iCount   = 0 ;

m = length( freq ) ;
xdata = 1:m ; 

options = optimoptions( 'lsqcurvefit', ...
                        'Display', 'iter-detailed', ...
                        'TypicalX', [605.0,0.0025,25.0], ... 
                        'FinDiffRelStep', [0.00001,0.0001,0.5] ) ;


[ pvals, resnorm, residuals, exitflag, output ] = ...
    lsqcurvefit( @fit_gas_funct, pvals0, xdata, data, ...
                 pvals_lo, pvals_up, options ) ; 
%, 'LargeScale', 'on'; 

yFit  = fit_gas_funct( pvals, xdata ) ; 


