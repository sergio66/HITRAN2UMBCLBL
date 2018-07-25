function cmprun(glist, vlist, HITRAN)

addpath /asl/matlib/science
addpath /asl/matlib/aslutil

% function cmprun(glist, vlist)
%
% compression script
%
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if nargin < 3
  HITRAN = 2012;
end

if nargin < 2
  vlist = 500:15:605; % default to all frequency chunks
end
if nargin < 1
  glist = [2];	     % default to some molgas
end

%% assume we are only dealing with H2000 onwards here
HITRANvers = HITRAN - 2000;

abseps = 1e-8;

% load reference profile to check gasses available
% load /home/sergio/abscmp/refproTRUE
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

%load /home/sergio/abscmp/refpro
glist = intersect(glist, refpro.glist);
clear refpro

glist
%vlist

% loop on gas IDs
for gid00 = 1 : length(glist)
   gid = glist(gid00)
   if gid == 1
     error('use cmprunIR_WV')
     end
   % set directories, depending on gas ID
   switch gid
     case 2
       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/FIR500_605/g2.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/FIR500_605/g2.dat/lblrtm2/kcomp/'];

     case 3
     otherwise
       error('huh????')
       gdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '/abs.dat']; 
       cdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '/kcomp'];

       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/kcomp/'];
     end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

 
  % loop on chunk start freq's
  for vchunk = vlist

    % get monochromatic and compressed filenames
    if gid == 1
      %% don't worry about only looking for g1vXYZp3.mat; when absbasis and
      %% abscmp below are called, all 5 pressure offsets are read in and compressed
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
      fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) 'p3.mat'];
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
      fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '.mat'];
    end
    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);
    fcmp = [cdir '/cg' num2str(gid) 'v' num2str(vchunk) '.mat'];

    %vchunk
    %fmon
    %fcmp
    %pause
    
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
        if gid == 9
          %%scott wants to make sure we can handle huge volcanic puffs of SO2
          %B = absbasis_gid9(gid, gdir, vchunk);
          B = absbasis(gid, gdir, vchunk);
        else
          B = absbasis(gid, gdir, vchunk);
          end
        absbcmp(gid, gdir, cdir, vchunk, B);
      end

    end
  end % vchunk loop
end % gid loop

disp('Now go to the "fortran" directory and make the ieee-le files ...')