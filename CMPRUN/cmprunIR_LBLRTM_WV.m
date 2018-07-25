function cmprun(glist, vlist)

% compression script
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil

homedir = pwd;
nbox = 5; pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%

HITRANvers = 2012-2000
gdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/WV/abs.dat'];
cdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.2/WV/kcomp.h2o'];

gdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.4/WV/abs.dat'];
cdir = ['/asl/s1/sergio/H20' num2str(HITRANvers,'%02d') '_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.4/WV/kcomp.h2o'];

disp(' ')
fprintf(1,'save gases 1   in %s %s \n',cdir);

allfreqchunks = 605 : 25 : 2830-25;
cder = ['cd ' homedir]; eval(cder);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
  wn1 = 605;
  wn2 = 2805;
  dv = 25;
  vlist = wn1 : dv : wn2; % default to all frequency chunks
end
if nargin < 1
  glist = [1 103 110];
  glist = [1];  
end

abseps = 1e-8;

% load reference profile to check gasses available
% load /home/sergio/abscmp/refproTRUE
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

cder = ['cd ' homedir]; eval(cder);
% loop on gas IDs

for gid = 1

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

  % loop on chunk start freq's
  for vv = 1 : length(vlist)
    vchunk = vlist(vv);

    if gid == 1 | gid == 103 | gid == 110
      % get monochromatic and compressed filenames
      %% don't worry about only looking for g1vXYZp3.mat; when absbasis and
      %% abscmp below are called, all 5 pressure offsets are read in 
      %% and compressed
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
      fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) 'p3.mat'];
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
      fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '.mat'];
    end

    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);
    fcmp = [cdir '/cg' num2str(gid) 'v' num2str(vchunk) '.mat'];

    if exist(fmon) == 2  % monochromatic data exists
      if exist(fcmp) == 2  % compressed data exists

        % we found compressed data, so just print a message
        fprintf(1, 'cmprun: %s already exists\n', fcmp);
      else

        fprintf(1, 'making  %s \n', fcmp);
        % check for old data with max below abseps
        eval(['load ',fmon]);
        %   gid = gid; %%% this is new line, as need to replace 1 --> 103
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
