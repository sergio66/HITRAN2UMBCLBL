function [fr,absc] = dogenln_onegas_sergio2(gid,kv1,kv2,ipfile,iLay);

% Run GENLN2 from param files in run directories
%
% reads params.m to get run parameters
%

if nargin < 4
  error('need 4 input params')
elseif nargin == 4
  iLay = 1;
end

% cleanup; don't call this from another script

rlist = { 'GENERIC' } ;

gas = load(ipfile);
gas = gas(iLay,:);

p  = gas(2) * 1013.25;       %% change from atm to mb
pp = gas(3) * 1013.25;       %% change from atm to mb
a  = gas(5) * 6.022045e26;   %% kmol/cm2 --> molecules/cm2
prof.glist = gid;
prof.mpres = p;
prof.gpart = pp;
prof.mtemp = gas(4);

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

