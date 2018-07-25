addpath /home/sergio/SPECTRA

if ~exist('d','var')
  [w,d] = run8(5,2080,2180,'/home/sergio/SPECTRA/IPFILES/co_gascell1');
end

if ~exist('dnoshift','var')
  topt.tsp_mult = 0;
  [w,dnoshift] = run8(5,2080,2180,'/home/sergio/SPECTRA/IPFILES/co_gascell1',topt);
end

co = load('/home/sergio/SPECTRA/IPFILES/co_gascell1');

p = co(2) * 1013.25;       %% change from atm to mb
a = co(5) * 6.023e26  ;    %% kmol/cm2 --> molecules/cm2
a = co(5) * 6.022045e26;   %% kmol/cm2 --> molecules/cm2

mr = co(3)/co(2);
n2 = a*(1-mr)/mr;
air = a/mr;

fprintf(1,'p = %15.7e mb  T = %15.7e K    co = %15.7e  molecules/cm2    n2 = %15.7e  molecules/cm2 \n',p,co(4),a,n2);
fprintf(1,'p = %15.7e mb  T = %15.7e K    co = %15.7e  molecules/cm2   air = %15.7e  molecules/cm2 \n',p,co(4),a,air);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[vx, OD, v] = lblrtm_tape11_reader_ODint('ODint_001','d');   %% lblrtm compiled with single
whos vx OD
vxx = boxint(vx(1:end-1),5);
ODD = boxint(OD(1:end-1),5);

ODDx = interp1(vxx,ODD,w);

plot(w,d,vxx,ODD,'r')

plot(w,d - ODDx,'r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /home/sergio/HITRAN2UMBCLBL/GLAB
dogenln_onegas_sergio2
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LBLRTM_MASIELLO_H12

L = co(5)*8.31*co(4)/(co(3)*101325)*1000*10000*100;   %% pV = nRT ==> q = pL/RT  and then units

figure(1)
plot(w,d,vxx,ODD,'r',fr,absc*L,'k'); hl=legend('run8','lblrtm','genln'); grid

figure(2)
plot(w,d./d,w,d./ODD,'r',w,d./(absc*L)','k','linewidth',2); 
  hl=legend('run8','lblrtm','genln'); grid
  axis([2080 2180 0.8 1.2])
  axis([2080 2130 0.9 1.1])

figure(3)
plot(w,dnoshift./d,w,dnoshift./ODD,'r',w,dnoshift./(absc*L)','k','linewidth',2); 
  hl=legend('run8','lblrtm','genln'); grid
  axis([2080 2180 0.8 1.2])
  axis([2080 2130 0.9 1.1])