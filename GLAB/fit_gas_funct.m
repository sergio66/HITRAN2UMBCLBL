
function yFit = fit_gas_funct( pvals, xdata ) ;

global pres freq absc pStore iCount user1 inst1


f0   = pvals(1) ;
df   = pvals(2) ;
p0   = pvals(3) ;

fval = ( xdata - 1 ) * df + f0 ;

thisCoef = interp2( freq, pres, absc', fval, p0, ...
                    'linear', 0.0 ) ;
trans    = exp( -thisCoef ) ;

[ xt1, xf1, opt ]   = kc2cris( inst1, user1, tran, fval ) ;

ind  = find( xf1 >= user1.v1 & xf1 <= user1.v2 ) ;
yFit = xt1( ind ) ;

iCount = iCount + 1 ;
pStore(:,iCount) = pvals ;
