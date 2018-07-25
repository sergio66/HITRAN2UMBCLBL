
% Run GENLN2 from param files in run directories
%
% reads params.m to get run parameters
%

% cleanup; don't call this from another script
clear all

% get our run directory
% rdir = input('run directory > ', 's');
% rlist = {rdir};

% rlist = { ...
%   'CO2run1', 'CO2run2', 'CO2run3', ...
%   'CH4run1', 'CH4run2', 'CH4run3', 'CH4run4', ...
%   'HBrrun1', 'HBrrun2'};


% Exlis has proposed to measure gas cell spectra using gas 
% mixtures appropriate for Bands 1, 2, and 3. 
rlist = { ... 
    'CO2_Jan14_LW', 'NH3_Jan14_LW' ...
    'CH4_Jan14_MW', 'NH3_Jan14_MW' ...
    'CO2_Jan14_SW', 'CO_Jan14_SW' ...
        } ;

for ri = 1 : length(rlist)

  fprintf(1, 'reading parameters for %s...\n', rlist{ri});

  % get the run params
  run([rlist{ri},'/params.m']);

  % ----------------------------------------
  %  call GENLN2 to calculate transmittances
  % ----------------------------------------

  mb2torr = 760 / 1013.25;
  rundir = pwd;
%      cd /home/motteler/glab
  absc = []; fr = [];
  more off
  for vc = kv1:25:kv2
    [fr1, absc1] = matglab(vc, vc+25-.0025, ...
                           prof.glist, ...
                           prof.mpres*mb2torr, ...
                           prof.gpart*mb2torr, ...
                           prof.mtemp);
    absc = [absc; absc1];
    fr = [fr; fr1];
  end
  cd (rundir)

  % adjust for a 10 cm path
  % absc = absc ./ 10;  

  % Adjust for a 12.6 cm path
  absc = absc * ( 12.6 / 100 ) ;

  % save results
  eval(sprintf('save %s/genlndat fr absc', rlist{ri}));

end

