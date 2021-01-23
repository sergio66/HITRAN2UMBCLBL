function cmprunIR_LBLRTM_HIGHRES(glist, vlist, HITRAN)

%% call with cmprunIR_LBLRTM_HIGHRES([2 3],605:5:855,2012);
%% call with cmprunIR_LBLRTM_HIGHRES([2  ],605:5:1200,2016);

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
  HITRAN = 2016;
end

if nargin < 2
  vlist = 605:25:2830; % default to all frequency chunks
  vlist = 605:05:2830; % default to all frequency chunks
end
if nargin < 1
  glist = [2 3 5 6 7 22];	     % default to some molgas
  glist = [2     6     ];	     % default to some molgas
  glist = [2 3   6     ];	     % default to some molgas
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

whos glist

% loop on gas IDs
for gid00 = 1 : length(glist)
   gid = glist(gid00)
   if gid == 1
     error('use cmprunIR_WV')
     end
   % set directories, depending on gas ID
   switch gid
     case 2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/kcomp/'];

       %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, should be fine
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm2/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0005/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0005/kcomp/'];

       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
       disp('WARNING!!!! NANs may show up in the abs.dat, which show up in the kcomp files')
       disp('so go back to eg /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LINEMIXUMBC_H12')
       disp('and run find_nan_put_zeros.m')
       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       %% 2016 was saved in /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005//
       %% so make a symbolic link
       %% cd /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//g2.dat/lblrtm0.0005/
       %% ln -s /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005// abs.dat
       %% mkdir kcomp
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0005/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0005/kcomp/'];

     case 3
       %%% >>>>>>>>>>>>> done with UMBC-LBL NOBASEMENT
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/WOBASEMENT/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/WOBASEMENT/kcomp/'];

       %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, should be fine
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm2/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm0.0005/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm0.0005/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       %% 2016 was saved in /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005//
       %% so make a symbolic link
       %% cd /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//g3.dat/lblrtm0.0005/
       %% ln -s /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005// abs.dat
       %% mkdir kcomp
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm0.0005/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm0.0005/kcomp/'];

     case 5
       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2, whould be fine
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g5.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g5.dat/lblrtm2/kcomp/'];

     case 6
       %%% >>>>>>>>>>>>> done with MY way of getting rid of N2/O2, whould be fine
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of getting rid of N2/O2
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g6.dat/lblrtm2/kcomp/'];

     case 7
       %%% >>>>>>>>>>>>> done with MY way of doing things, WRONG SHOULD NOT TRUST
       error('O2 using LBLRTM is messed up')
       xgdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm/abs.dat/']; 
       xcdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm/kcomp/'];

     case 22
       %%% >>>>>>>>>>>>> done with MY way of doing things, WRONG SHOULD NOT TRUST AS ONLY PUTS continuum
       xgdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/abs.dat/']; 
       xcdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/kcomp/'];

       %%% >>>>>>>>>>>>> done with AER way of doing things, PUTS continuum AND lines
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm2/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm2/kcomp/'];

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
disp(' run loop_mat2forIR_LBLRTM_HIGHRES.m')
