dira = '/umbc/xfs3/strow/asl/rta/kcarta/H2020.ieee-le/IR605/hdo.ieee-le/'
dirb = '/umbc/xfs3/strow/asl/rta/kcarta/H2024.ieee-le/IR605/hdo.ieee-le/'

addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat/

%{
load cg5v4250.mat     %% this is for CO
toinky = squeeze(kcomp(:,:,6)); %%pulls out stuff for toffset = 0 ==> US Std
toinky = B * toinky; toinky = toinky.^(4);
toinky(1:10,1)
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[gida,fra,kcompa,Ba]  = for2mat_kcomp_reader([dira '/r1530_g1.dat']);
[gidb,frb,kcompb,Bb]  = for2mat_kcomp_reader([dirb '/r1530_g1.dat']);

whos kcompa kcompb Ba Bb

toimka = squeeze(kcompa(:,:,6,2)); %%pulls out stuff for toffset = 0 ==> US Std,, P = 2 ==> pmult = 1;
toimkb = squeeze(kcompb(:,:,6,2)); %%pulls out stuff for toffset = 0 ==> US Std,, P = 2 ==> pmult = 1;

oda = Ba * toimka;
odb = Bb * toimkb;

semilogy(fra,sum(odb,2), fra, sum(oda,2))
plot(fra,odb./oda);
plot(fra,sum(odb,2)./sum(oda,2))
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ret to continue')

[gida,fra,kcompa,Ba]  = for2mat_kcomp_reader([dira '/r1530_g103.dat']);
[gidb,frb,kcompb,Bb]  = for2mat_kcomp_reader([dirb '/r1530_g103.dat']);

whos kcompa kcompb Ba Bb

toimka = squeeze(kcompa(:,:,6)); %%pulls out stuff for toffset = 0 ==> US Std,, P = 2 ==> pmult = 1;
toimkb = squeeze(kcompb(:,:,6)); %%pulls out stuff for toffset = 0 ==> US Std,, P = 2 ==> pmult = 1;

oda = Ba * toimka;
odb = Bb * toimkb;

semilogy(fra,sum(odb,2), fra, sum(oda,2))
plot(fra,odb./oda);
plot(fra,sum(odb,2)./sum(oda,2))
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
