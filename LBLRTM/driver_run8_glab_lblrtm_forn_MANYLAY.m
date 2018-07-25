function [w,d,dnoshift,dshiftneg1,dglab,dlblrtm] = driver_run8_glab_lblrtm_forn(gid,v1,v2,ipfile)

%% >>>>>>>>> see code in /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_ALL_H12_NOBASEMENT <<<<<<<<<<<<

%% function [w,drun8,dglab,dlblrtm] = driver_run8_glab_lblrtm_forn(gid,v1,v2,ipfile)  assumes N2 broadning
%% assumes 0.0025 cm-1 output resolution
%% input
%%   gid    = gasID
%%   v1,v2  = start/stop wavenumber
%%   ipfile = one layer of profile info [index   p(atm)     pp(atm)    T(K)  q (kmol/cm2)]
%% output
%%   drun8           = ODs from run8
%%   drun8noshift    = ODs from run8 with tsp = 0 (no line center shift)
%%   drun8dshiftneg1 = ODs from run8 with tsp = -1 (main iso line center shift, lblrtm "no pedestal")
%%   dglab           = ODs from GLAB/GENLN2
%%   dlblrtm         = ODs from LBLRTM
%%
%% the 5 column ipfile information is
%%   layer no (integer)      total press (atm)    partial press (atm)      Temp (K)      gas amount (kilomoles/cm2)
%%
%% example [w,drun8,drun8noshift,drun8shiftneg1,dglab,dlblrtm] = driver_run8_glab_lblrtm_forn_MANYLAY(5,2130,2180,'/home/sergio/SPECTRA/IPFILES/co2two');
%%  plot(w,drun8shiftneg1./dlblrtm)                                                                                                                
%%  plot(w,drun8noshift./dglab)                                                                                                                    

if v1 < 600 | v2 > 3000
  error('TAPE5 is set up for dv=0.0005 cm-1 so only use this code for 607-2830 cm-1')
end

%cd /home/sergio/HITRAN2UMBCLBL/GLAB
%[frglab,dglab] = dogenln_onegas_sergio2(gid,v1,v2,ipfile);
%cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/
%plot(frglab,dglab)
%error('ooo')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run8

addpath /home/sergio/SPECTRA
if gid > 2 & gid < 51
  [w,d] = run8(gid,v1,v2,ipfile);
  dnoshift = d;
  dshiftneg1 = d;

%  disp('for speed purposes, not doing dnoshift and dshiftneg1 ... just setting them equal to d!!!')
%  disp('can uncomment lines if you wish them to be computed')

  topt.tsp_mult = 0;
  [w,dnoshift] = run8(gid,v1,v2,ipfile,topt);

  topt.tsp_mult = -1;
  topt.LVG = 'W';
  topt.HITRAN = '/asl/data/hitran/h08.by.gas';
  [w,dshiftneg1] = run8(gid,v1,v2,ipfile,topt);


elseif gid == 2
  [w,d] = run8co2(gid,v1,v2,ipfile);

  %topt.tsp_mult = 0;
  %[w,dnoshift] = run8co2(gid,v1,v2,ipfile,topt);
  dnoshift   = d;
  dshiftneg1 = d;

elseif gid == 1
  [w,d]    = run8water(gid,v1,v2,ipfile);
  topt.CKD = 25;
  [w,dcon] = run8watercontinuum(gid,v1,v2,ipfile,topt);
  d = d + dcon;

  dnoshift = d;
  dshiftneg1 = d;
else
  fprintf(1,'gid = %3i \n',gid);
  error('gid not supported!')
end

%% now add N2
  gas = load(ipfile);

  L = gas(:,5)*8.31446218.*gas(:,4)./(gas(:,3)*101325)*1000*10000*100;   %% pV = nRT ==> q = pL/RT  and then units

  mr = gas(:,3)./gas(:,2);
  n2 = gas(:,5).*(1-mr)./mr;

  gas(:,3) = gas(:,2) - gas(:,3);
  gas(:,5) = n2;
  fid = fopen('ipfileN2','w');
  fprintf(fid,'%3i %8.6e %8.6e %8.6f %8.6e \n',gas');
  fclose(fid);
  [w,dN2] = run8(22,v1,v2,'../LBLRTM/ipfileN2');

d          = d          + dN2;
dnoshift   = dnoshift   + dN2;
dshiftneg1 = dshiftneg1 + dN2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LBLRTM

addpath XHUANG
dvx = 0.0025;
dvx = 0.0005;

junk = load(ipfile);
[mm,nn] = size(junk);

for ii = 1 : mm
  fprintf(1,'LBLRTM lay %2i out of %2i \n',ii,mm);
  %makeTAPE5(gid,v1-01,v2+01,ipfile,dvx); %% Mlawer suggested larger bracket than 1 cm-1
  %makeTAPE5(gid,v1-10,v2+10,ipfile,dvx); %% Mlawer suggested larger bracket than 1 cm-1
  makeTAPE5(gid,v1-25,v2+25,ipfile,dvx,ii); %% Mlawer suggested larger bracket than 1 cm-1

  lbler = ['!lblrtm >& ugh']; eval(lbler)
  catter = ['!more ugh'];    eval(catter)

  [vx, OD, v] = lblrtm_tape11_reader_ODint('ODint_001','d');   %% lblrtm compiled with single

  if dvx == 0.0005
    woop = find(vx >= v1 - 2.001*0.0005 & vx <= v2 - 0.0025 + 2.001*0.0005);
    vxx = boxint(vx(woop),5);
    ODD = boxint(OD(woop),5);
  elseif dvx == 0.0025
    woop = find(vx >= v1 - 0.001 & vx <= v2 - 0.0025 + 0.001);
    vxx = vx(woop)';
    ODD = OD(woop)';
  end

  if length(vxx) ~= length(w)
    [length(vxx)  length(w)]
    error('length(vxx) ~= length(w)')
  end

 if sum(abs(vxx-w))/length(w) > 0.0001
    error('hmm size of arrays matches, but vxx, w seem different')
  end

  %%dlblrtm = interp1(vxx,ODD,w);
  dlblrtm(ii,:) = ODD;
end

plot(w,d,vxx,ODD,'r')
plot(w,d - dlblrtm,'r')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GLAB/GENLN2

cd /home/sergio/HITRAN2UMBCLBL/GLAB
for ii = 1 : mm
  [frglab,dglab(ii,:)]   = dogenln_onegas_sergio2(gid,v1,v2,ipfile,ii);
  [frglab,dglabN2(ii,:)] = dogenln_onegas_sergio2(22,v1,v2,'../LBLRTM/ipfileN2',ii);
end

cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/

gas = load(ipfile);
L = gas(:,5)*8.31446218.*gas(:,4)./(gas(:,3)*101325)*1000*10000*100;   %% pV = nRT ==> q = pL/RT  and then units
fprintf(1,'path cell length = %8.6f cm \n',L)
for ii = 1 : mm
  dglab(ii,:) = (dglab(ii,:) + dglabN2(ii,:)) * L(ii);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlblrtm = dlblrtm';
dglab = dglab';

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Results

%figure(1); semilogy(w,dshiftneg1,w,dlblrtm,'g',w,dglab,'r',vx,OD,'m','linewidth',2); grid
%  ax = axis; axis([v1 v2 ax(3) ax(4)]);
%  hl=legend('dshiftneg1','dlblrtm','dglab','ODlblrtm high res');
%  set(hl,'fontsize',10)
figure(1); semilogy(w,dshiftneg1,w,dlblrtm,'g',w,dglab,'r',w,d,'m','linewidth',2); grid
  ax = axis; axis([v1 v2 ax(3) ax(4)]);
  hl=legend('dshiftneg1','dlblrtm','dglab','d');
  set(hl,'fontsize',10)

figure(2); plot(w,dnoshift./dglab,'k',w,d./dlblrtm,'g.-',w,dshiftneg1./dlblrtm,'r','linewidth',2); grid
  ax = axis; axis([v1 v2 ax(3) ax(4)]);
  hl=legend('dnoshift/dglab','d/dlblrtm','dnew/dlblrtm');
  set(hl,'fontsize',10)

figure(3); plot(w,dnoshift-dglab,'k',w,d-dlblrtm,'g.-',w,dshiftneg1-dlblrtm,'r','linewidth',2); grid
  ax = axis; axis([v1 v2 ax(3) ax(4)]);
  hl=legend('dnoshift-dglab','d-dlblrtm','dnew-dlblrtm');
  set(hl,'fontsize',10)

%{
fid = fopen('aer.txt','w');
data = [w; d; dnoshift; dshiftneg1; dglab; dlblrtm];
fprintf(fid,'%10.8e %10.8e %10.8e %10.8e %10.8e %10.8e\n',data);
fclose(fid);
%}

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keyboard

figure(1); clf
plot(w,d,vxx,ODD,'r',frglab,dglab,'k'); hl=legend('run8','lblrtm','genln'); grid

figure(2); clf
plot(w,d./d,w,d./ODD,'r',w,d./dglab,'k','linewidth',2); 
  hl=legend('run8','lblrtm','genln'); grid
  axis([v1 v2 0.8 1.2])
  axis([v1 v2 0.9 1.1])
title('dCorrect/other')

figure(3); clf
plot(w,dnoshift./d,w,dnoshift./ODD,'r',w,dnoshift./dglab,'k','linewidth',2); 
  hl=legend('run8','lblrtm','genln'); grid
  axis([v1 v2 0.8 1.2])
  axis([v1 v2 0.9 1.1])
title('dNoPshift/other')