function [w,dglab,dlblrtm] = driver_glab_lblrtm_N2_MANYLAY(gid,v1,v2,ipfile,iDoGlab,iTalk)

%% >>>>>>>>> see code in /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_ALL_H12_NOBASEMENT <<<<<<<<<<<<

%% function [w,dglab,dlblrtm] = driver_glab_lblrtm_N2_MANYLAY(gid,v1,v2,ipfile)
%% assumes 0.0025 cm-1 output resolution
%% input
%%   gid    = gasID
%%   v1,v2  = start/stop wavenumber
%%   ipfile = one layer of profile info [index   p(atm)     pp(atm)    T(K)  q (kmol/cm2)]
%%
%% optional input
%%    iDoGlab = -1 for no GLAB, +1 for yes GLAB (default = +1)
%%    iTalk   = +1 for talky during makeTAPE5, -1 for silent (default = +1)
%%
%% output
%%%  w               = wavenumbers
%%   dglab           = ODs from GLAB/GENLN2
%%   dlblrtm         = ODs from LBLRTM
%%
%% the 5 column ipfile information is
%%   layer no (integer)      total press (atm)    partial press (atm)      Temp (K)      gas amount (kilomoles/cm2)
%%
%% example [w,dglab,dlblrtm] = driver_glab_lblrtm_N2_MANYLAY(5,2130,2180,'/home/sergio/SPECTRA/IPFILES/co2two');

if v1 < 600 | v2 > 3000
  error('TAPE5 is set up for dv=0.0005 cm-1 so only use this code for 607-2830 cm-1')
end

if nargin == 4
  iDoGlab = +1;  %% assume user wants glab run
  iTalk   = +1;  %% assume talk during makeTAPE5
end
if nargin == 5
  iTalk   = +1;  %% assume talk during makeTAPE5
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LBLRTM

if gid ~= 22
  error('only for doing g22 (N2)')
end
 
addpath XHUANG
dvx = 0.0025;
dvx = 0.0005;

junk = load(ipfile);
[mm,nn] = size(junk);

addpath /home/sergio/SPECTRA

bwop = (v2-v1+2*eps)/0.0025;
bwop = 1 : bwop;
bwop = bwop - 1;

w = v1 : 0.0025 : v2 - 0.0025;
w = v1 + 0.0025 * bwop;
whos w

if gid ~= 22
  error('need to have gid == 22')
end

for ii = 1 : mm
  fprintf(1,'LBLRTM lay %2i out of %2i \n',ii,mm);
  %makeTAPE5(gid,v1-01,v2+01,ipfile,dvx,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
  %makeTAPE5(gid,v1-10,v2+10,ipfile,dvx,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
  makeTAPE5_N2(gid,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1

  lbler = ['!lblrtm >& ugh']; eval(lbler)
  catter = ['!more ugh'];    eval(catter)

  [vx, OD, v] = lblrtm_tape11_reader_ODint('ODint_001','d');   %% lblrtm compiled with single

  if dvx == 0.0005
    %whos woop vx OD v
    %format long e
    %[v1 v2 min(vx) max(vx)]
    %format
    dvv = v(:,3);
    if (abs(min(dvv)-dvx) > eps*10) | (abs(max(dvv)-dvx) > eps*10)
      fprintf(1,'oops dvs and v(:,3) differ!!! %8.6e %8.6e ... fixing ... \n',min(dvv)-dvx,max(dvv)-dvx)
      rara = floor(length(vx)/5);
      rara = rara*5;
      rara = 1 : rara;
      newvx = vx(1) + (rara-1)*dvx;
      OldVX = vx;
      OldOD = OD;
      OD = interp1(vx,OD,newvx);
      vx = newvx;
    end
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GLAB/GENLN2

if iDoGlab < 0
  dglab = zeros(size(dlblrtm));
  disp('you did not want GLAB run, setting to zeros')
  dlblrtm = dlblrtm';
  dglab = dglab';
  return
end

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
