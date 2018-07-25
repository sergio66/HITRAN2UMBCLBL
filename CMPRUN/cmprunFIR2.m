function cmprun(glist, vlist)

% function cmprun(glist, vlist)
%
% compression script
%
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if nargin < 2
  vlist = 300:10:510; % default to all frequency chunks
end
if nargin < 1
  glist = 1:32;	             % default to all non-xsec gasses
  glist = [[1:32] [51:63]];  % default to all xsec gasses
  glist = [[1:42] [51:82]];  % default to all xsec gasses
end

abseps = 1e-8;

% load reference profile to check gasses available
%load /home/sergio/abscmp/refproTRUE
%load /home/sergio/abscmp/refpro
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat
glist = intersect(glist, refpro.glist);
clear refpro

glist
vlist

% loop on gas IDs
for gid00 = 1 : length(glist)
   gid = glist(gid00)
 
   % set directories, depending on gas ID
   switch gid
     case 1
       gdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/abs.dat'; 
       cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/kcomp.h2o'; 
       gdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/g1.dat/abs.dat';
       cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/g1.dat/kcomp';
     case 2
       gdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/abs.dat'; 
       cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/kcomp';
       gdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/abs.dat';
       cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/kcomp';
     otherwise
       gdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/abs.dat'; 
       cdir = '/spinach/s6/sergio/RUN8_NIRDATABASE/FIR300_510/kcomp';
       gdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/abs.dat';
       cdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/FIR300_510/kcomp';
     end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

  % loop on chunk start freq's
  for vchunk = vlist

    % get monochromatic and compressed filenames
    if gid == 1
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
    end
    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);

    %fmon
    %fcmp

    if exist(fmon) == 2  % monochromatic data exists

      if exist(fcmp) == 2  % compressed data exists

        % we found compressed data, so just print a message
        fprintf(1, 'cmprun: %s already exists\n', fcmp);
      else

        fprintf(1, 'making  %s \n', fcmp);
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