function cmprunIR_LBLRTM(glist, vlist, HITRAN)

addpath /asl/matlib/science
addpath /asl/matlib/aslutil

% function cmprun(glist, vlist)
%
% compression script for weak background CO2 od data from
%%   /home/sergio/KCARTA/NONLTE/M_Files_for_kcarta_NLTE_LBL_runs/USUALLAYERS
%%   /home/sergio/KCARTA/NONLTE/M_Files_for_kcarta_NLTE_LBL_runs/UA

% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if nargin < 3
  HITRAN = 2004;  
  HITRAN = 2016;
end

if nargin < 2
  vlist = 2205:25:2505; % default to all frequency chunks
end

if nargin < 1
  glist = [-2 +2];	     % default to some molgas, 2 is for lower atm, -2 is for upper atm
end

%% assume we are only dealing with H2000 onwards here
HITRANvers = HITRAN - 2000;

abseps = 1e-8;

% load reference profile to check gasses available
% load /home/sergio/abscmp/refproTRUE
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

%load /home/sergio/abscmp/refpro
%glist = intersect(glist, refpro.glist);
clear refpro

glist

HITRAN_last2 = HITRAN-2000;

% loop on gas IDs
for gid00 = 1 : length(glist)
   gid = glist(gid00);
   gidx = abs(gid);
   if gid == 1
     error('use cmprunIR_WV')
     end
   % set directories, depending on gas ID
   switch gid
     case -2
       gdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_UPPER_400ppm_H' num2str(HITRAN_last2,'%02d') '/abs.dat/']; 
       cdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_UPPER_400ppm_H' num2str(HITRAN_last2,'%02d') '/kcomp/']; 

     case +2
       gdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_400ppm_H' num2str(HITRAN_last2,'%02d') '/abs.dat/']; 
       cdir = ['/asl/s1/sergio/AIRSCO2/BACKGND_COUSIN_400ppm_H' num2str(HITRAN_last2,'%02d') '/kcomp/']; 
   end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)
 
  % loop on chunk start freq's
  for vchunk = vlist

    % get monochromatic and compressed filenames
    if gidx == 1
      %% don't worry about only looking for g1vXYZp3.mat; when absbasis and
      %% abscmp below are called, all 5 pressure offsets are read in and compressed
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gidx, vchunk);
      fmon = [gdir '/g' num2str(gidx) 'v' num2str(vchunk) 'p3.mat'];
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gidx, vchunk);        
      fmon = [gdir '/g' num2str(gidx) 'v' num2str(vchunk) '.mat'];
    end
    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gidx, vchunk);
    fcmp = [cdir '/cg' num2str(gidx) 'v' num2str(vchunk) '.mat'];

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
		  gidx, vchunk);
	end
	clear k
		  
        % we have monochromatic absorption data to work on and
	% there's no current compressed data, so do the compression
        if gidx == 9
          %%scott wants to make sure we can handle huge volcanic puffs of SO2
          %B = absbasis_gid9(gidx, gdir, vchunk);
          B = absbasis(gidx, gdir, vchunk);
        else
          B = absbasis(gidx, gdir, vchunk);
          end
        absbcmp(gidx, gdir, cdir, vchunk, B);
      end

    end
  end % vchunk loop
end % gid loop

disp('Now go to the "fortran" directory and make the ieee-le files ...')
