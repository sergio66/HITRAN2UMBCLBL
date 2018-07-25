
function abstab25(glist, vL, vH, topts);

% function abstab25(glist, vL, vH, topts);
%
% abstab25 -- driver for tabulation of absorptions
%
% abstab25 calls Sergio's "run7", "run7co2", and "run7water"
% to produce files of tabulated absorptions in 25 1/cm chunks.
%
% inputs
%
%   glist - list of HITRAN gas IDs
%   vL    - starting wavenumber
%   vH    - ending wavenumber
%   topts - option to override default parameters
%
% outputs
%
%   absorption data in 25 1/cm chunks, in .mat files named 
%   either g<gid>v<chunk>.mat, for all gasses but water, or
%   g<gid>v<vchunk>p<qind>.mat for water, which is saved as 
%   a set of partial pressures.  These .mat files contain
%   the variables:
%
%     fr        1 x 10000     frequency scale
%     gid       1 x 1         gas ID
%     k     10000 x 100 x 11  tabulated absorptions
%
%   If an output file already exists for a particular gas 
%   chunk, it will not be overwritten
%
% bugs
%   - need to cd to appropriate "spectra" dir before calling

% location of reference profile
refpro = '/home/motteler/abstab/refpro';
eval(['load ', refpro])

% hitran data (to check for lines in or near a chunk)
hitdat = '/asl/data/hitran/h2k.by.gas';

% some assorted "run6" default parameters are set here;
% the rest are just fixed in the calling arg list, for now

% general "run6.m" (not CO2 or H2O) parameters
str_far = 0;	% min line strength for far wing lines
str_near = 0;	% min line strength for near wing lines
LVG = 'V';	% (L)orentz, Voi(G)t, (V)anHuber
CKD = 1;	% leave on, for N2 and O2

% "run6co2.m" parameters
LVF = 'F';	% (L)orentz, (V)oigt/vaan Huber, (F)ull 

% "run6water.m" parameters
LVG1 = 'V';	% (L)orentz, Voi(G)t, (V)anHuber
CKD1 = -1;	% no continuum--leave off for tabulations
local = 0;	% local lineshape w/o chi

% optional data archives
co2dir = '/carrot/s1/motteler/absdat/abs.co2';
h2odir = '/carrot/s1/motteler/absdat/abs.h2o';
mscdir = '/carrot/s1/motteler/absdat/abs.etc';
mvflag = 0;  % set mvflag to 1 to move data to archive

% minimum significant absorption value
abseps = 1e-8;

% distance to check for HITRAN lines in neighboring chunks
vspan = 5;

% temperature offsets
toffset = [-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50];

% partial pressure offsets
qoffset = [0.1, 1.0, 3.3, 6.7, 10.0];
qunitind = 2; % index of 1.0 in qoffset

% option to override defaults with topts fields
if nargin == 4
  optvar = fieldnames(topts);
  for i = 1 : length(optvar)
    eval(sprintf('%s = topts.%s;', optvar{i}, optvar{i}));
  end
end

% space for absorption chunks
k = zeros(10000,100,length(toffset));

% temporary local filename for the "run6" input profile
[dtmp, ftmp] = fileparts(tempname);  
ftmp = ['./', ftmp]; 

% run7 parameters for all constituents
opts.HITRAN = hitdat;
opts.strength_far = str_far;
opts.strength_near = str_near;

% loop on requested gasses
for gind = 1:length(glist)

  gid = glist(gind);

  % data tabulation directory 
  if gid == 1
    absdir = h2odir;
  elseif gid == 2
    absdir = co2dir;
  else
    absdir = mscdir;
  end

  % only H2O is tabulated at more than one partial pressure
  if gid == 1
    qindlist = 1:length(qoffset); 
  else
    qindlist = qunitind;
  end

  % check that the requested gas is in the reference profile
  refgind = find(refpro.glist == gid);
  if ~isempty(refgind)

    % build an ascii format profile for "run6"
    prof = zeros(100,5);
    prof(:, 1) = (1:100)';			  % layer number
    prof(:, 2) = refpro.mpres;			  % pressure
    prof(:, 3) = refpro.gpart(:, refgind);	  % partial pressure
    prof(:, 4) = refpro.mtemp;			  % temperature
    prof(:, 5) = refpro.gamnt(:, refgind);	  % gas amount
    tref = prof(:, 4);
    qref = prof(:, 3);
  
    % loop on 25 1/cm chunk starting wavenumber
    for v1 = vL : 25 : vH
      v2 = v1 + 25;

      % check this interval for any action in or near this chunk,
      % with special cases added for N2 and O2 continuum
      s = read_hitran(v1-vspan, v2+vspan, 0, gid, hitdat);
      if length(s.igas) > 0 ...
		| (gid == 7 & 1330 <= v1 & v2 <= 1855) ...
		| (gid == 22 & 2080 <= v1 & v2 <= 2680)
  
        % loop on partial pressure offsets
        for qind = qindlist;

	  % get output filename
          if gid == 1
	    fout = sprintf('g%dv%dp%d.mat', gid, v1, qind);
	  else
	    fout = sprintf('g%dv%d.mat', gid, v1);
          end

	  % check if output file already exists
	  if  (~mvflag & exist(fout) == 2) ...
	        | (mvflag & exist([absdir,'/',fout]) )

	    fprintf(1, 'abstab25: %s already exists\n', fout);

	  else

            % loop on temperature offsets
            for tind = 1:length(toffset);

	      fprintf(2, 'abstab25: gid %d, v1 %d, tind %d\n', gid, v1, tind);

	      % create shifted profile for "run6"
              prof(:,4) = tref + toffset(tind);  % shift temperature
              prof(:,3) = qref * qoffset(qind);  % shift part. press.

	      % write input profile for "run6"
              eval(sprintf('save %s prof -ascii', ftmp)); 

	      if gid == 1
              
	        % H2O absorption
		opts.LVG = LVG1;
		opts.CKD = CKD1;
                [fr, k1] = run7water(gid, v1, v2, ftmp, opts);

                % [fr, k1] = run6water(gid, v1, v2, 0.0005, 0.1, 0.5, ...
                %                     1, 1, 2, 25, 5, str_far, str_near, ...
                %                     LVG1, CKD1, 1, 1, 1, local, ftmp);

              elseif gid == 2

	        % CO2 absorption
		opts.LVF = LVF;
                [fr, k1] = run7co2(gid, v1, v2, ftmp, opts);

                % [fr, k1] = run6co2(gid, v1, v2, 0.0005, 0.1, 0.5, ...
                %                    1, 1, 2, 250, 5, str_far, str_near, ...
		%		     LVF, '1', 'b', ftmp);
  
              else 

	        % all other gasses
		opts.LVG = LVG;
		opts.CKD = CKD;
                [fr, k1] = run7(gid, v1, v2, ftmp, opts);

                % [fr, k1] = run6(gid, v1, v2, 0.0005, 0.1, 0.5, ...
                %                1, 1, 2, 25, 5, str_far, str_near, ...
		%                LVG, CKD, ftmp);
              end

              k(:, :, tind) = k1';  % save absorptions for this offset
  
            end % temperature offset loop
  
	    % give a warning for negative values
	    kmin = min(min(min(k)));
	    if kmin < 0
	      fprintf(2, 'abstab25: WARNING negative absorptions, %g\n', kmin);
	    end

	    % check that there is something to save
	    if max(max(max(k))) > abseps
              % save the completed chunk
              eval(sprintf('save %s fr k gid', fout)); 

	      % if mvflag is set, move the output file to archive
	      if mvflag
		eval(sprintf('! mv %s %s', fout, absdir));
	      end

	    end % test for something to save

	  end % output file existance check

        end % partial pressure offset loop

      end % HITRAN active line test

    end % 25 1/cm chunk loop

  end % gas ID in ref prof test

end % gass ID loop

% clean up
if exist(ftmp) == 2
  delete(ftmp);
end

