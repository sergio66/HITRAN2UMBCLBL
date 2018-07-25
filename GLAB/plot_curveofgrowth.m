
addpath /asl/packages/ccast/source
addpath /asl/packages/airs_decon/test

glabRoot = '/home/tilak/glab/CO2_Sep2013/' ;

% Weak line
f0 = 766.4400 ;

% Moderate line
f1 = 751.3375 ;

% Strong line
f2 = 720.2700 ;

% Q branch head near 667 
f3 = 667.9400 ;

fw = 0.0025 ;
hw = 0.5 * fw ;

a1   = load( [ glabRoot 'genlndat-1T' ] ) ;
a5   = load( [ glabRoot 'genlndat-5T' ] ) ;
a10  = load( [ glabRoot 'genlndat-10T' ] ) ;
a20  = load( [ glabRoot 'genlndat-20T' ] ) ;
a30  = load( [ glabRoot 'genlndat-30T' ] ) ;
a40  = load( [ glabRoot 'genlndat-40T' ] ) ;
a50  = load( [ glabRoot 'genlndat-50T' ] ) ;
a100 = load( [ glabRoot 'genlndat-100T' ] ) ;


ind0 = find( a1.fr > f0-hw & a1.fr < f0+hw ) ;
ind1 = find( a1.fr > f1-hw & a1.fr < f1+hw ) ;
ind2 = find( a1.fr > f2-hw & a1.fr < f2+hw ) ;

ind3 = find( a1.fr > f3-hw & a1.fr < f3+hw ) ;


t1   = exp( -a1.absc ) ;
t5   = exp( -a5.absc ) ;
t10  = exp( -a10.absc ) ;
t20  = exp( -a20.absc ) ;
t30  = exp( -a30.absc ) ;
t40  = exp( -a40.absc ) ;
t50  = exp( -a50.absc ) ;
t100 = exp( -a100.absc ) ;

f = a1.fr ;

absCoef = struct ;
absCoef.f    = f ;
absCoef.pres = [ 1, 5, 10, 20, 30, 40, 50, 100 ] ;
absCoef.absc = [ a1.absc,  a5.absc,  a10.absc, a20.absc, ...
                 a30.absc, a40.absc, a50.absc, a100.absc ] ;
save( 'AbsCoef-Pres', 'absCoef' ) ;





NumTicks = 3;

figure() ; clf
h(1) = subplot( 'Position', [ 0.69 0.72 0.26 0.22 ]);
plot( f, [ t1, t5, t10, t20, t30, t40, t50, t100 ]  ) ;
xlim( f0 + fw*10*[ -1 1 ] ) ;
L = get( h(1),'XLim');
set( h(1),'XTick', linspace( L(1), L(2), NumTicks) ) ;
ylabel( 't' ) ;
title( 'Weak Line' ) ;

h(2) = subplot( 'Position', [ 0.69 0.41 0.26 0.22 ]);
plot( f, [ t1, t5, t10, t20, t30, t40, t50, t100 ]  ) ;
xlim( f1 + fw*10*[ -1 1 ] ) ;
L = get( h(2),'XLim');
set( h(2),'XTick', linspace( L(1), L(2), NumTicks) ) ;
ylabel( 't' ) ;
title( 'Moderate Line' ) ;

h(3) = subplot( 'Position', [ 0.69 0.1 0.26 0.22 ]);
plot( f, [ t1, t5, t10, t20, t30, t40, t50, t100 ]  ) ;
xlim( f2 + fw*10*[ -1 1 ] ) ;
L = get( h(3),'XLim');
set( h(3),'XTick', linspace( L(1), L(2), NumTicks) ) ;
ylabel( 't' ) ;
title( 'Strong Line' ) ;

xlabel( '\nu (cm^{-1})' ) ;


cog0 = [ t1(ind0)  t5(ind0)  t10(ind0) t20(ind0) t30(ind0) ... 
        t40(ind0) t50(ind0) t100(ind0) ] ;
cog1 = [ t1(ind1)  t5(ind1)  t10(ind1) t20(ind1) t30(ind1) ... 
        t40(ind1) t50(ind1) t100(ind1) ] ;
cog2 = [ t1(ind2)  t5(ind2)  t10(ind2) t20(ind2) t30(ind2) ... 
        t40(ind2) t50(ind2) t100(ind2) ] ;
cog3 = [ t1(ind3)  t5(ind3)  t10(ind3) t20(ind3) t30(ind3) ... 
        t40(ind3) t50(ind3) t100(ind3) ] ;
p    = [ 1.0      5.0      10       20       30 ...
        40       50       100 ] ;

wlaser = 764.6 ;
[ inst1, user1 ]    = inst_params( 'LW', wlaser ) ;

[ xt1, xf1, opt ]   = kc2cris( inst1, user1, t1, f ) ;
[ xt5, xf1, opt ]   = kc2cris( inst1, user1, t5, f ) ;
[ xt10, xf1, opt ]  = kc2cris( inst1, user1, t10, f ) ;
[ xt20, xf1, opt ]  = kc2cris( inst1, user1, t20, f ) ;
[ xt30, xf1, opt ]  = kc2cris( inst1, user1, t30, f ) ;
[ xt40, xf1, opt ]  = kc2cris( inst1, user1, t40, f ) ;
[ xt50, xf1, opt ]  = kc2cris( inst1, user1, t50, f ) ;
[ xt100, xf1, opt ] = kc2cris( inst1, user1, t100, f ) ;

% c_ind0 = find( xf1 > 720.25 & xf1 < 720.35 ) ;



c_ind0 = find( xf1 > f0-0.4 & xf1 < f0+0.4 ) ;
c_cog0 = [ xt1(c_ind0)  xt5(c_ind0)  xt10(c_ind0) xt20(c_ind0) ... 
          xt30(c_ind0) xt40(c_ind0)  xt50(c_ind0) xt100(c_ind0) ] ;
c_ind1 = find( xf1 > f1-0.4 & xf1 < f1+0.4 ) ;
c_cog1 = [ xt1(c_ind1)  xt5(c_ind1)  xt10(c_ind1) xt20(c_ind1) ... 
          xt30(c_ind1) xt40(c_ind1)  xt50(c_ind1) xt100(c_ind1) ] ;
c_ind2 = find( xf1 > f2-0.4 & xf1 < f2+0.4 ) ;
c_cog2 = [ xt1(c_ind2)  xt5(c_ind2)  xt10(c_ind2) xt20(c_ind2) ... 
          xt30(c_ind2) xt40(c_ind2)  xt50(c_ind2) xt100(c_ind2) ] ;

c_ind3 = find( xf1 > f3-0.4 & xf1 < f3+0.4 ) ;
c_cog3 = [ xt1(c_ind3)  xt5(c_ind3)  xt10(c_ind3) xt20(c_ind3) ... 
          xt30(c_ind3) xt40(c_ind3)  xt50(c_ind3) xt100(c_ind3) ] ;



h(4) = subplot( 'Position', [ 0.1 0.75 0.5 0.2 ]);
plot( p, cog0 )
hold on
plot( p, cog1, 'r' )
plot( p, cog2, 'g' )
plot( p, c_cog0, 'b--' )
plot( p, c_cog1, 'r--' )
plot( p, c_cog2', 'g--' )
hold off
ylim( [ 0.9 1.01 ] ) ;
set( h(4), 'xticklabel', [] ) ;
ylabel( 't' ) ;
ylim( [ 0.9 1.01 ] ) ;

h(5) = subplot( 'Position', [ 0.1 0.1 0.5 0.6 ]);
plot( p, cog0 )
hold on
plot( p, cog1, 'r' )
plot( p, cog2, 'g' )
plot( p, c_cog0, 'b--' )
plot( p, c_cog1, 'r--' )
plot( p, c_cog2, 'g--' )
plot( [15,23], 0.4*[1 1], 'k--' )
text( 26, 0.4, 'CrIS resolution', 'Color', 'b');
plot( [15,23], 0.3*[1 1], 'k-' )
text( 26, 0.3, 'LBL peak abs', 'Color', 'b');

plot( p, c_cog3, 'm-.' )
text( 10, 0.15, '668 cm^{-1}', 'Color', 'm');

hold off
ylabel( 't' ) ;
ylim( [ 0 1.05 ] ) ;
xlabel( 'p (Torr) ' ) ;
ylabel( 't' ) ;
text( 80, 0.9, 'Weak', 'Color', 'b');
text( 80, 0.6, 'Moderate', 'Color', 'r');
text( 80, 0.35, 'Strong', 'Color', 'g');

% saveas( gcf, 'GrowthCurve-Press', 'pdf' ) ;








% Simulate a cell length difference by a factor
sc = 2.0 ;
at1   = exp( -a1.absc*sc ) ;
at5   = exp( -a5.absc*sc ) ;
at10  = exp( -a10.absc*sc ) ;
at20  = exp( -a20.absc*sc ) ;
at30  = exp( -a30.absc*sc ) ;
at40  = exp( -a40.absc*sc ) ;
at50  = exp( -a50.absc*sc ) ;
at100 = exp( -a100.absc*sc ) ;
cog0a = [ at1(ind0)  at5(ind0)  at10(ind0) at20(ind0) at30(ind0) ... 
        at40(ind0) at50(ind0) at100(ind0) ] ;
cog1a = [ at1(ind1)  at5(ind1)  at10(ind1) at20(ind1) at30(ind1) ... 
        at40(ind1) at50(ind1) at100(ind1) ] ;
cog2a = [ at1(ind2)  at5(ind2)  at10(ind2) at20(ind2) at30(ind2) ... 
        at40(ind2) at50(ind2) at100(ind2) ] ;


