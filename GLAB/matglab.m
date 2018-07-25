function [fgas, kgas]=matglab(fmin, fmax, gasid, ptot, ppart, temp);
%
% function [fgas, kgas]=matglab(fmin, fmax, gasid, ptot, ppart, temp);
%
% Matlab routine to run GENLN2/GLAB ("lite" version) and return
% optical depth.  Requires GENLN2 & GLAB programs.  This program
% only runs in the "Glab" dir.
%
% Input:
%    fmin = real (1 x 1) = minimum freq (cm-1)
%    fmax = real (1 x 1) = maximum freq (cm-1)
%    gasid = integer (1 x 1) = HITRAN gas ID (1=H2O, 2=CO2, 4=N2O, 5=CO, 6=CH4)
%    ptot = real (1 x 1) = total pressure (torr)
%    ppart = real (1 x 1) = partial pressure (torr)
%    temp = real (1 x 1) = temperature (K)
%
% Output:
%    fgas = real (nmono x 1) = freq point = fmin: 0.0025: fmax-0.0025
%    kgas = real (nmono x 1) = optical depth (per meter)
%

% Created by Scott Hannon, 29 March 1999

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%
% Check that input makes at least a little bit of sense

if (fmax <= fmin )
   fmin
   fmax
   error('max freq must be larger than min freq')
end

if (fmin < 600)
   fmin
   error('min freq must be >= 600')
end

if (fmax > 3000)
   fmax
   error('max freq must be <= 3000')
end

junk=abs( gasid - round(gasid) );
if (junk > 1E-6)
   gasid
   error('gas ID must be an integer')
end

if (gasid < 1 | gasid > 32)
   gasid
   error('gasid must be between 1 and 32')
end

if (ppart > ptot)
   ptot
   ppart
   error('total pressure must be >= partial pressure')
end

if (ppart < 1E-6)
   ppart
   disp('WARNING partial presure is too small')
end

%if (ptot > 770)
%   ptot
%   error('total pressure is too large')
%end

if (temp < 150 | temp > 350)
   temp
   warning('temperature should be between 150 and 350')
end


%%%%%%%%
% Create variable with input info and write to ASCII file
glab_info=[fmin fmax gasid ptot ppart temp]';
save glab_in glab_info -ascii


%%%%%
% Run glab script
! rm lite.ip > junk_out1 2>&1
%! ./newglab_lite < glab_in > junk_out1
! ./sergio_newglab_lite < glab_in > junk_out1

%%%%%
% Run GENLN2
disp('running genln2...')
%%! ./run_avg lite > junk_out2 2>&1
! ./run_avg lite > junk_out2

%%%%%%
% Read in spectra
load lite.tau
fgas=lite(:,1);
kgas=lite(:,2);
disp('...done')

%%%%%%%%%%%%%%%%%%%%%%%%% end of routine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
