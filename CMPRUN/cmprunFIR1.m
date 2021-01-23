function cmprun(glist, vlist)

% function cmprun(glist, vlist)
%
% compression script
%
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if nargin < 2
  vlist = 500:15:605; % default to all frequency chunks
  vlist = 500:05:805; % default to all frequency chunks, yay the high res 15 um stuff Oct 2019
  vlist = 500:05:880; % default to all frequency chunks, yay the high res 15 um stuff Oct 2019, nice overlap
end
if nargin < 1
  glist = 1:32;	                                                % default to all non-xsec gasses
  glist = [[1:32] [51:63]];                                     % default to all xsec gasses

  %% Oct 2019 onwards
  glist = [[1:42] [51:81]];       glist = setdiff(glist,[2 6]); % default to all gases
  %glist = [2 6];
  %glist = [1 103];
end

abseps = 1e-8;

% load reference profile to check gasses available
%load /home/sergio/abscmp/refproTRUE
%load /home/sergio/abscmp/refpro
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

glist0 = glist;

glist = intersect(glist, refpro.glist);
clear refpro

if intersect(glist0,103)
  glist = [glist 103];
end
if intersect(glist0,110)
  glist = [glist 110];
end

vlist
glist

% loop on gas IDs
for gid00 = 1 : length(glist)
  gid = glist(gid00);
  fprintf(1,'going to compress gas # %3i in glist, which is GID %3i \n',gid00,gid)
 
  % set directories, depending on gas ID
  switch gid
    case 1
      gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g1.dat/abs.dat/';
      cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g1.dat/kcomp/';
    case 103
      gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat/abs.dat/';
      cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat/kcomp/';
    case 2
      gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005/';
      cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/kcomp/';
    case 6
      gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005/';
      cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/kcomp/';
    otherwise
      gdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/abs.dat/';
      cdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/kcomp/';
  end

  disp(' ')
  fprintf(1,'gid = %2i \n',gid);
  fprintf(1,'gdir = %s \n',gdir);
  fprintf(1,'cdir = %s \n',cdir);

  % loop on chunk start freq's
  for vchunk = vlist
    % get monochromatic and compressed filenames
    if gid == 1 | gid == 103 | gid == 110
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
    end
    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);

    if exist(fmon) == 2  % monochromatic data exists
      if exist(fcmp) == 2  % compressed data exists
        % we found compressed data, so just print a message
        fprintf(1, 'cmprun: %s already exists\n', fcmp);
      else
        fprintf(1,' all data is in : %s \n',fmon)
        fprintf(1,' making         : %s \n', fcmp);

        gidxxx = gid;
        % check for old data with max below abseps
        eval(['load ',fmon]);
        if max(max(max(k))) <= abseps
	  fprintf(1, 'cmprun: WARNING gas %d chunk %d max k <= abseps\n',gid, vchunk);
	end
        if (gid ~= gidxxx)
          fprintf(1,'WARNING loading in %s changed gid fro %3i to %3i \n',fmon,gidxxx,gid);
          disp('changing back')
          gid = gidxxx;
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
