% Run GENLN2 from param files in run directories
%
% reads params.m to get run parameters
%

% cleanup; don't call this from another script
clear all

rlist = { 'GENERIC' } ;

prof.glist = 3;
prof.mpres = 101.325;
prof.gpart = 1.01325;
prof.mtemp = 300.0;
kv1 = 0980;
kv2 = 1080; 

prof.glist = 6;
prof.mpres = 201.325;
prof.gpart = prof.mpres * 1800 * 1e-9;
prof.mtemp = 280.0;
kv1 = 1280;
kv2 = 1330; 

prof.glist = 5;
prof.mpres = 1.0853934e+03 * 760/1013.25;  %% in torr
prof.gpart = prof.mpres * 3.6300e-03;
prof.mtemp = 296.0;
kv1 = 2080;
kv2 = 2180; 

for ri = 1 : length(rlist)

  fprintf(1, 'reading parameters for %s...\n', rlist{ri});

  % get the run params
  % run([rlist{ri},'/params.m']);

  % ----------------------------------------
  %  call GENLN2 to calculate transmittances
  % ----------------------------------------

  mb2torr = 760 / 1013.25;
  rundir = pwd;
  absc = []; fr = [];
  more off
  for vc = kv1:25:kv2-25
    [fr1, absc1] = matglab(vc, vc+25-0.0025, ...
                           prof.glist, ...
                           prof.mpres*mb2torr, ...
                           prof.gpart*mb2torr, ...
                           prof.mtemp);
    absc = [absc; absc1];
    fr = [fr; fr1];
  end
  cd (rundir)

  % adjust for a 100 cm path since matglab uses a 100 cm path
  absc = absc ./ 100  ;  

  % save results
  eval(sprintf('save %s/genlndat fr absc', rlist{ri}));

end

addpath /home/sergio/SPECTRA
% units = [integer real real real real] = [[no units] atm atm K kmoles/cm2]
%
%  press       = input('Enter total pressure (in atm) : ');
%  partpress   = input('Enter gas partial pressure (in atm) : ');
%  temperature = input('Enter temperature (in K) : ');
%  GasAmt      = input('Enter path cell length (in cm) ');
%  %change to kmoles cm-2
%  GasAmt = GasAmt*101325*partpress/1e9/MGC/temperature; %change to kmoles/cm2

MGC = 8.314674269981136  ;
q = 1.0 * 101325 * prof.gpart/1013.25 / (1e9 * MGC * prof.mtemp);  %% assume 1 cm cell
fid = fopen('GENERIC/boo.ip','w');
boo = [prof.glist prof.mpres/1013.25 prof.gpart/1013.25 prof.mtemp q];
fprintf(fid,'%3i %8.6e %8.6e %8.6e %8.6e \n',boo);
fclose(fid);
[fkc,dkc] = run8(prof.glist,kv1,kv2,'GENERIC/boo.ip');

figure(1); clf; plot(fr,absc,fkc,dkc,'r')
figure(2); clf; plot(fr,absc ./ dkc','r')

