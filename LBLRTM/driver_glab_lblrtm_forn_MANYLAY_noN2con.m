function [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY_noN2con(gid,v1,v2,ipfile,iDoGlab,iTalk,iALLorONElays,rRes)

%% >>>>>>>>> see code in /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_ALL_H12_NOBASEMENT <<<<<<<<<<<<<<<<<
%% >>>>>>>>> see code in /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_O3_N2O_CO_CH4_LBLRTM_H12 <<<<<<<
%% same as driver_glab_lblrtm_forn_MANYLAY.m except we turn O2,N2 continuum off so can do OD in one swoop

%% function [w,dglab,dlblrtm] = driver_glab_lblrtm_forn(gid,v1,v2,ipfile)  assumes N2 broadning, does NOT run "run8"
%% does not include N2 continuum and so can get individual gas OD in one swoop
%% assumes 0.0025 cm-1 output resolution
%% input
%%   gid    = gasID
%%   v1,v2  = start/stop wavenumber
%%   ipfile = one layer of profile info [index   p(atm)     pp(atm)    T(K)  q (kmol/cm2)]
%%   
%% optional input
%%    iDoGlab        = -1 for no GLAB, yes LBLRTM
%%                   = +1 for yes GLAB, yes LBLRTM (default = +1)
%%                   = -2 for yes GLAB, NO LBLRTM
%%    iTalk          = +1 for talky during makeTAPE5, -1 for silent (default = +1)
%%    iALLorONElays  = +N for only one layer, -1 for all layers (default = -1)
%%    rRes           = resolution, default 0.0025 cm-1 for w > 605 cm1
%% output
%%%  w               = wavenumbers
%%   dglab           = ODs from GLAB/GENLN2
%%   dlblrtm         = ODs from LBLRTM
%%
%% the 5 column ipfile information is
%%   layer no (integer)      total press (atm)    partial press (atm)      Temp (K)      gas amount (kilomoles/cm2)
%% the 5+4 column ipfile information is
%%   layer no (integer)      total press (atm)    partial press (atm)      Temp (K)      gas amount (kilomoles/cm2)
%%   and P1,T1   p2,T2   boundary info for each layer
%%
%% example [w,dglab,dlblrtm] = driver_glab_lblrtm_forn_MANYLAY(5,2130,2180,'/home/sergio/SPECTRA/IPFILES/co2two');

if (v1 < 500 | v2 > 3500) & (gid < 100)
  error('TAPE5 is set up for dv=0.0005 cm-1 and dv=0.0003 cm-1 so only use this code for 500-3000 cm-1')
end

if nargin == 4
  iDoGlab = +1;       %% assume user wants glab run
  iTalk   = +1;       %% assume talk during makeTAPE5
  iALLorONElays = -1; %% assume do all layers
  %rRes = 0.0025;  
end
if nargin == 5
  iTalk   = +1;  %% assume talk during makeTAPE5
  iALLorONElays = -1; %% assume do all layers
  %rRes = 0.0025;    
end
if nargin == 6
  iALLorONElays = -1; %% assume do all layers
  %rRes = 0.0025;    
end

w       = [];
dglab   = [];
dlblrtm = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LBLRTM

addpath /home/sergio/HITRAN2UMBCLBL/LBLRTM/XHUANG

junk = load(ipfile);
[mm,nn] = size(junk);

addpath /home/sergio/SPECTRA

iType = -1;
if (gid == 111 | gid == 101 | gid == 102)
  iType = 605;
  disp('  ----->>>>>>>> WATER CONTINUUM : dv = 0.0025')

  dvx = 0.0025;
  dvx = 0.0005;

  dvx = 1/5;  %% so you output at 1 cm-1 resolution

  if exist('rRes')
    dvx = rRes;
  else
    dvx = 1/5;
  end
  
  bwop = (v2-v1+2*eps)/(5*dvx);
  bwop = 1 : bwop;
  bwop = bwop - 1;

  w = v1 : dvx*5 : v2 - dvx*5;
  w = v1 + dvx*5 * bwop;

elseif v1 >= 604.999 & v2 <= 3500
  iType = 605;
  disp('  ----->>>>>>>> v1 >= 605 & v2 <= 3500 : dv = 0.0025')

  dvx = 0.0025;
  dvx = 0.0005;

  if exist('rRes')
    dvx = rRes;
  else
    dvx = 0.0005;
  end
  
  bwop = (v2-v1+2*eps)/(5*dvx);
  bwop = 1 : bwop;
  bwop = bwop - 1;

  w = v1 : dvx*5 : v2 - dvx*5;
  w = v1 + dvx*5 * bwop;
  
elseif v1 >= 499.999 & v2 <= 655
  !! hm could be problems making the last 605-620 cm-1 chunk!!!
  iType = 500;
  disp('  ----->>>>>>>> v1 >= 500 & v2 <= 650 : dv = 0.0015')

  dvx = 0.0015;
  dvx = 0.0003;

  if exist('rRes')
    dvx = rRes;
  else
    dvx = 0.0003;
  end

  bwop = (v2-v1+2*eps)/(5*dvx);
  bwop = 1 : bwop;
  bwop = bwop - 1;

  w = v1 : 5*dvx : v2 - 5*dvx;
  w = v1 + 5*dvx * bwop;

else
  error('huh cannot figure out spacing!!!')
end

if iALLorONElays < 0
  iiStart = 1;
  iiEnd   = mm;
else
  iiStart = iALLorONElays;
  iiEnd   = iALLorONElays;
end

if iDoGlab > -2
  for ii = iiStart : iiEnd
    fprintf(1,'LBLRTM lay %2i out of %2i GID = %2i v1,v2 = %8.6f %8.6f \n',ii,(iiEnd-iiStart)+1,gid,v1,v2);
    %makeTAPE5(gid,v1-01,v2+01,ipfile,dvx,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
    %makeTAPE5(gid,v1-10,v2+10,ipfile,dvx,iTalk); %% Mlawer suggested larger bracket than 1 cm-1

    %%%%%%%%makeTAPE5(gid,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
    if gid <= 47 
      if iType == 605
        qfactor = makeTAPE5_noN2con(gid,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      elseif iType == 500
        qfactor = makeTAPE5_noN2con(gid,v1-15,v2+15,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      end
    elseif gid == 101 | gid == 102 
      if iType == 605
        qfactor = makeTAPE5_noN2con(gid,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      elseif iType == 500
        qfactor = makeTAPE5_noN2con(gid,v1-15,v2+15,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      end
    elseif gid == 111
      if iType == 605
        qfactor = makeTAPE5_noN2con(1,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      elseif iType == 500
        qfactor = makeTAPE5_noN2con(1,v1-15,v2+15,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
      end
    elseif gid >= 51 & gid <= 63
      qfactor = makeTAPE5_noN2conXSEC(gid,v1-25,v2+25,ipfile,dvx,ii,iTalk); %% Mlawer suggested larger bracket than 1 cm-1
    else
      gid
      error('huh gid in driver_glab_lblrtm_forn_MANYLAY_noN2con.m')
    end

    disp('  running !lblrtm >& ugh ....')
      %lbler = ['!lblrtm >& ugh']; eval(lbler)
      command = ['lblrtm >& ugh'];
      command = ['lblrtm']      
      [status,cmdout] = system(command,'-echo');
    %disp('  catting ugh ....')
    %catter = ['!more ugh'];    eval(catter)

%pwd
%!more TAPE5
%pause

    disp('  reading ODint_001 ...')
    [vx, OD, v] = lblrtm_tape11_reader_ODint('ODint_001','d');   %% lblrtm compiled with double
    fprintf(1,'     read ODint_001 ... vx(1),vx(end),mean(diff(vx)) = %8.6f %8.6f %8.6f \n',vx(1),vx(end),mean(diff(vx)));
    if abs(qfactor-1) > eps
      OD = OD * qfactor;
      fprintf(1,'looks like gas amount in molecules/cm2 was < 1 ... qfactor = %8.6e \n',qfactor);
    end
    
    if dvx == 0.0005 & iType == 605
      %% DEFAULT 0.0005 cm-1 ---> 0.0025 cm-1 after boxcar
      %whos woop vx OD v
      %format long e
      %[v1 v2 min(vx) max(vx)]
      %format
      dvv = v(:,3);
      if (abs(min(dvv)-dvx) > eps*10) | (abs(max(dvv)-dvx) > eps*10)
        fprintf(1,'oops dvx and v(:,3) differ!!! %8.6e %8.6e ... fixing ... \n',min(dvv)-dvx,max(dvv)-dvx)
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
      
    elseif dvx == 0.0001 & iType == 605
      %% LBLRTM for heating rate 0.0001 cm-1 ---> 0.0005 cm-1 after boxcar    
      %whos woop vx OD v
      %format long e
      %[v1 v2 min(vx) max(vx)]
      %format
      dvv = v(:,3);
      if (abs(min(dvv)-dvx) > eps*10) | (abs(max(dvv)-dvx) > eps*10)
        fprintf(1,'oops dvx and v(:,3) differ!!! %8.6e %8.6e ... fixing ... \n',min(dvv)-dvx,max(dvv)-dvx)
        rara = floor(length(vx)/5);
        rara = rara*5;
        rara = 1 : rara;
        newvx = vx(1) + (rara-1)*dvx;
        OldVX = vx;
        OldOD = OD;
        OD = interp1(vx,OD,newvx);
        vx = newvx;
      end
      woop = find(vx >= v1 - 2.001*0.0001 & vx <= v2 - 0.0005 + 2.001*0.0001); 
      vxx = boxint(vx(woop),5);
      ODD = boxint(OD(woop),5);
      
    elseif dvx == 0.0025 & iType == 605
      woop = find(vx >= v1 - 0.001 & vx <= v2 - 0.0025 + 0.001);
      vxx = vx(woop)';
      ODD = OD(woop)';

    elseif dvx == 0.0003 & iType == 500
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
      woop = find(vx >= v1 - 2.001*0.0003 & vx <= v2 - 0.0015 + 2.001*0.0003); 
      % keyboard
      % whos woop vx OD v
      % format long e
      % [v1 v2 min(vx) max(vx)]
      % format
      vxx = boxint(vx(woop),5);
      ODD = boxint(OD(woop),5);
    elseif dvx == 0.0015 & iType == 500
      woop = find(vx >= v1 - 0.001 & vx <= v2 - 0.0015 + 0.001);
      vxx = vx(woop)';
      ODD = OD(woop)';
    elseif dvx == 0.0001 & iType == 605
      woop = find(vx >= v1 - 2.001*0.0001 & vx <= v2 - 0.0005 + 2.001*0.0001); 
      vxx = boxint(vx(woop),5);
      ODD = boxint(OD(woop),5);
    elseif dvx == 0.0003 & iType == 605
      woop = find(vx >= v1 - 2.001*0.0003*1.5 & vx <= v2 - 0.0015 + 2.001*0.0003);
      vxx = boxint(vx(woop),5);
      ODD = boxint(OD(woop),5);
    elseif dvx == 1/5 & iType == 605
%      whos vx
%      [vx(1:3) vx(end-2:end)]
%%keyboard      
      woop = find(vx >= v1 - 2.001*1/5*0.9855 & vx <= v2 - 1/5 + 2.001*1/5);
      woop = find(vx >= v1 - 2*1/5 & vx <= v2 - 1 + 2*1/5);        
      vxx = boxint(vx(woop),5);
      ODD = boxint(OD(woop),5);
    else
      error('huh??')
    end

    if length(vxx) ~= length(w)
      [vxx(1:3) vxx(end-2:end) w(1:3) w(end-2:end)]      
      [length(vxx)  length(w)]
      error('length(vxx) ~= length(w)')
    end

   if sum(abs(vxx-w))/length(w) > 0.0001
     keyboard
     error('hmm size of arrays matches, but vxx, w seem different')
    end

    %%dlblrtm = interp1(vxx,ODD,w);
    dlblrtm(ii,:) = ODD;
  end
else
  dlblrtm = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GLAB/GENLN2

if iDoGlab == -1
  dglab = zeros(size(dlblrtm));
  disp('you did not want GLAB run, setting to zeros')
  dlblrtm = dlblrtm';
  dglab = dglab';
  if iALLorONElays > 0
    dglab   = dglab(:,iALLorONElays);
    dlblrtm = dlblrtm(:,iALLorONElays);
  end
  return
end

disp('WARNING driver_glab_lblrtm_forn_MANYLAY.m >>>> not adding on any OD due to N2!!!!')
disp('WARNING driver_glab_lblrtm_forn_MANYLAY.m >>>> not adding on any OD due to N2!!!!')
disp('WARNING driver_glab_lblrtm_forn_MANYLAY.m >>>> not adding on any OD due to N2!!!!')
cd /home/sergio/HITRAN2UMBCLBL/GLAB
for ii = 1 : mm
  [frglab,dglab(ii,:)]   = dogenln_onegas_sergio2(gid,v1,v2,ipfile,ii);
  %% [frglab,dglabN2(ii,:)] = dogenln_onegas_sergio2(22,v1,v2,'../LBLRTM/ipfileN2',ii);
end

cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/

gas = load(ipfile);
L = gas(:,5)*8.31446218.*gas(:,4)./(gas(:,3)*101325)*1000*10000*100;   %% pV = nRT ==> q = pL/RT  and then units
fprintf(1,'path cell length = %8.6f cm \n',L)
for ii = 1 : mm
  %%% dglab(ii,:) = (dglab(ii,:) + dglabN2(ii,:)) * L(ii);
  dglab(ii,:) = dglab(ii,:) * L(ii);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlblrtm = dlblrtm';
dglab = dglab';

if iALLorONElays > 0
  dglab   = dglab(:,iALLorONElays);
  dlblrtm = dlblrtm(:,iALLorONElays);
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
