function cmprun(glist, vlist)

% function cmprun(glist, vlist)
%
% compression script
%
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if nargin < 2
  vlist = 605:25:2805;    % default to all frequency chunks
  vlist = 2805:25:3580; % default to all frequency chunks
end
if nargin < 1
  glist = [1 103 110];
end

abseps = 1e-8;

% load reference profile to check gasses available
%load /home/sergio/abscmp/refproTRUE
%load /home/sergio/abscmp/refpro
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

if length(glist) == 2
  %% this is if we are only doing 1, 103
  refpro.glist = [refpro.glist; 103; ];
  refpro.gamnt = [refpro.gamnt refpro.gamnt(:,1)];
  refpro.gpart = [refpro.gpart refpro.gpart(:,1)];
  glist = intersect(glist, refpro.glist);
  clear refpro
elseif length(glist) == 3
  %% this is if we are only doing 1, 103, 110
  refpro.glist = [refpro.glist; 103; 110];
  refpro.gamnt = [refpro.gamnt refpro.gamnt(:,1) refpro.gamnt(:,1)];
  refpro.gpart = [refpro.gpart refpro.gpart(:,1) refpro.gpart(:,1)];
  glist = intersect(glist, refpro.glist);
  clear refpro
end

nbox = 5;
pointsPerChunk = 10000;

addpath /home/sergio/HITRAN2UMBCLBL/CMPRUN

% loop on gas IDs
for gid00 = 1 : length(glist)
   gid = glist(gid00)
   cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKENIR/H2012/MAKENIR1/WV/'];
   eval(cder);
   if gid == 1
     freq_boundaries_g1
     gdir = [dirout  '/abs.dat/'];
     cdir = [dirout '/kcomp.h2o/'];
     gidx = 1;
   elseif gid == 103
     freq_boundaries_g103
     gdir = [dirout '/abs.dat/'];
     cdir = [dirout '/kcomp.h2o/'];
     gidx = 103;
   elseif gid == 110
     freq_boundaries_g1
     dirout = [dirout(1:end-7) 'g110.dat/'];
     gdir = [dirout  '/abs.dat/'];
     cdir = [dirout '/kcomp.h2o/'];
     gidx = 1;
   end

  disp('files eventually have to be in kWaterIsotopePath (kcarta.param)')

%{
>> pwd
  /asl/data/kcarta/H2012.ieee-le/NIR2830_3580
>> cp -a hdo.ieee-le/s*.dat /asl/data/kcarta/H2012.ieee-le/IR605/hdo.ieee-le/.
%}

  fprintf(1,'gdir = %s \n',gdir);
  fprintf(1,'cdir = %s \n',cdir);

  ee = exist(gdir);
  if ee == 0
    error('gdir DNE!!!')
  end

  ee = exist(cdir);
  if ee == 0
    disp('gdir exists, making cdir')
    mker = ['!mkdir ' cdir];
    eval(mker);
  end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

  % loop on chunk start freq's
  for vchunk = vlist

    % get monochromatic and compressed filenames
    if gid == 1 | gid == 103 | gid == 110
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
      fmon = [gdir '/g' num2str(gidx) 'v' num2str(vchunk) 'p3.mat'];

      fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);
      fcmp = [cdir '/cg' num2str(gidx) 'v' num2str(vchunk) '.mat'];
    end
    if exist(fmon) == 2  % monochromatic data exists
      if exist(fcmp) == 2  % compressed data exists

        % we found compressed data, so just print a message
        fprintf(1, 'cmprun: fcmp %s already exists\n', fcmp);
      else

        fprintf(1,'fmon = %s \n',fmon);
        fprintf(1,'fcmp = %s \n',fcmp);

        % check for old data with max below abseps
        eval(['load ',fmon]);
        if max(max(max(k))) <= abseps
	  fprintf(1, 'cmprun: WARNING gas %d chunk %d max k <= abseps\n', ...
		  gid, vchunk);
	end
	clear k
		  
        % we have monochromatic absorption data to work on and
	% there's no current compressed data, so do the compression
        B = absbasis(gid, gdir, vchunk);
        absbcmp(gid, gdir, cdir, vchunk, B);
      end

    end
  end % vchunk loop
end % gid loop

disp('Now go to the "fortran" directory and make the ieee-le files ...')

