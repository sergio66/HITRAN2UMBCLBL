clear all

%% old profs were in
%% /strowdata1/shared/asl/packages/klayersV205/Test_rtpV105
%% pin_feb2002_sea_airsnadir_ip.rtp
%% pin_feb2002_sea_airsnadir_op.rtp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load /home/sergio/HITRAN2UMBCLBL/refprof_usstd2010.mat
iV = 1;   %% given in July 2010
iV = 2;   %% given on 6 Aug 2010, Scott updated gases 41/80
iV = 3;   %% given on 16 Aug 2010, Scott updated gases 30/81,32,79
if iV == 1
  load /asl/packages/klayersV205/Data/refprof_usstd2010.mat
elseif iV == 2
  load /asl/packages/klayersV205/Data/refprof_usstd6Aug2010.mat
elseif iV == 3
  load /asl/packages/klayersV205/Data/refprof_usstd16Aug2010.mat
  end

% p and pp must be in atmospheres;   see /SPECTRA/DOC/lbl.tex
% T        must be in Kelvin
% q        must be in kilomoles/cm2

for ii = 1 : 100
  num   = prof.plevs(ii)-prof.plevs(ii+1);
  denom = log(prof.plevs(ii)/prof.plevs(ii+1));
  mpres(ii) = (num/denom)/1013.25;   %% change from mb to atm
  mtemp(ii)  = prof.ptemp(ii);
  thickness(ii) = abs(prof.palts(ii) - prof.palts(ii+1));   %% in meters
  qall(ii) = mpres(ii)*101325 * thickness(ii)/(8.314674269981136 * mtemp(ii)); 
  %% change from moles/m2 to moles/cm2 to kilomoles/cm2
  qall(ii) = qall(ii)/1e4/1e3;
  end
plev = prof.plevs;

glistall = [[1:42] [51:81]];
for ii = 1 : length(glistall)
  gas = glistall(ii);
  glist(ii) = gas;
  str = ['thegas = prof.gas_' num2str(gas) ';']; eval(str);
  thegas = thegas(1:100);             %% in molecules/cm2
  gamnt(:,ii) = thegas/6.022045e23/1000; %% in kilomoles/cm2
  gpart(:,ii) = gamnt(:,ii)./qall' .* mpres';
  end

glist = glist';
mpres = mpres'; mpres = flipud(mpres);
mtemp = mtemp'; mtemp = flipud(mtemp);
refpro.glist = glist;
refpro.mpres = mpres;
refpro.mtemp = mtemp;
refpro.gamnt = flipud(gamnt);
refpro.gpart = flipud(gpart);
refpro.plev  = flipud(plev);

if iV == 1
  save refprof_usstd2010_lbl.mat refpro
elseif iV == 2
  save refprof_usstd6Aug2010_lbl.mat refpro
elseif iV == 3
  save refprof_usstd16Aug2010_lbl.mat refpro
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
refpro2010 = refpro;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load /home/sergio/HITRAN2UMBCLBL/refpro3.mat    %%this was used 2000-2009

refpro
refpro2010

isee = [[1:31] [51:63]];
%isee = [1:30];

[C,iOld,X] = intersect(refpro.glist,isee);
[C,iNew,X] = intersect(refpro2010.glist,isee);

plot(refpro2010.gamnt(:,iNew)./refpro.gamnt(:,iOld),1:100)
  dahratio = mean(refpro2010.gamnt(:,iNew)./refpro.gamnt(:,iOld));
  title('refpro.gamnt new/old');
  disp('co2 bumped up by 385/370 = 1.0405')
  pause

plot(refpro2010.gpart(:,iNew)./refpro.gpart(:,iOld),1:100)
  title('refpro.gpart new/old');
  disp('co2 bumped up by 385/370 = 1.0405')
  pause

plot(isee,dahratio,'o'); grid
  title('ratio new/old gamnt vs gasid');
  pause

plot(refpro2010.mpres./refpro.mpres);
  title('refpro.mpres new/old');
  pause

plot(refpro2010.mtemp./refpro.mtemp);
  title('refpro.mtemp new/old');
  pause

plot(refpro2010.plev./refpro.plev);
  title('refpro.plev new/old');
  pause


