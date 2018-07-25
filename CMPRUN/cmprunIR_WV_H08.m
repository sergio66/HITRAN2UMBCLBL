function cmprun(glist, vlist)

% compression script
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

homedir = pwd;
nbox = 5; pointsPerChunk = 10000;

cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_WV_H08']; eval(cder);
freq_boundaries
cdirALL = [dirout '/kcomp_ALLISO.h2o/']; 
ee = exist(cdirALL,'dir');
fprintf('chunks 605-1105,1705-2405 in %s \n',cdirALL);
if ee == 0
  fprintf(1,'dir %s does not exist \n',cdirALL);
  iYes = input('make dir? (+1 = yes) ');
  if iYes == 1
    mker = ['!mkdir ' cdirALL]; eval(mker)
  else
    error('cannot proceed')
    end
  end
diroutALL = dirout;

cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_WV_H08']; eval(cder);
freq_boundaries_new
cdir_1_103 = [dirout '/kcomp.h2o/']; 
ee = exist(cdir_1_103,'dir');
fprintf('chunks 1105-1605,2405-2805 in %s \n',cdir_1_103);
if ee == 0
  fprintf(1,'dir %s does not exist \n',cdir_1_103);
  iYes = input('make dir? (+1 = yes) ');
  if iYes == 1
    mker = ['!mkdir ' cdir_1_103]; eval(mker)
  else
    error('cannot proceed')
    end
  end
dirout_1_103 = dirout;

disp(' ')
fprintf(1,'save gases 1,103   in %s \n',dirout_1_103);
fprintf(1,'save gases alliso1 in %s \n',diroutALL);

allfreqchunks = 605 : 25 : 2830-25;
hdochunks = [];
for ii = 1 : iNumBands
  wn1 = wn1all(ii);
  wn2 = wn2all(ii);
  xx = wn1 : 25 : wn2;
  hdochunks = [hdochunks xx];
  end
hdochunks = sort(hdochunks);  %% do all chunks beginning with this
%% these frequencies tally up with those in
%% /asl/s1/sergio/xRUN8_NIRDATABASE/IR_2405_3005_WV/fbin/h2o.ieee-le
%% allfreqchunks = setdiff(allfreqchunks,hdochunks); %% NO NEED TO DO THIS

cder = ['cd ' homedir]; eval(cder);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
  vlist = wn1 : dv : wn2; % default to all frequency chunks
end
if nargin < 1
  glist = 1:32;	             % default to all non-xsec gasses
  glist = [[1:32] [51:63]];  % default to all xsec gasses
  glist = [1 103 110];       % default to WV : 
                             %   001 is all isotopes but (4), saved in cdir
                             %     ie [1 2 3   5 6]
                             %  103 is only isotope 4, saved in cdir 
                             %     ie [      4    ]
                             %  110 is all  isotopes, saved in cdirALL
                             %        ie [1 2 3 4 5 6]
  glist = [1 103 110];
  glist = [1 103];
end

abseps = 1e-8;

% load reference profile to check gasses available
% load /home/sergio/abscmp/refproTRUE
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

refpro.glist = [refpro.glist; 103; 110];
refpro.gamnt = [refpro.gamnt refpro.gamnt(:,1) refpro.gamnt(:,1)];
refpro.gpart = [refpro.gpart refpro.gpart(:,1) refpro.gpart(:,1)];
glist = intersect(glist, refpro.glist);
clear refpro

cder = ['cd ' homedir]; eval(cder);
% loop on gas IDs
for gid0 = glist
 
   % set directories, depending on gas ID
   switch gid0
     case 1
       gid = gid0;
       vlist = hdochunks;
       gdir = [dirout_1_103 '/abs.dat/']; 
       cdir = [dirout_1_103 '/kcomp.h2o/']; 
     case 103
       gid = gid0;
       vlist = hdochunks;
       gdir = [dirout_1_103 '/abs.dat/']; 
       cdir = [dirout_1_103 '/kcomp.h2o/']; 
     case 110
       gid = 1;
       vlist = allfreqchunks;
       gdir = [diroutALL '/abs_ALLISO.dat/']; 
       cdir = [diroutALL '/kcomp_ALLISO.h2o/']; 
%     case 2
%       gdir = [dirout '/abs.dat/']; 
%       cdir = [dirout '/kcomp/']; 
%     otherwise
%       gdir = [dirout '/abs.dat/']; 
%       cdir = [dirout '/kcomp/']; 
     otherwise
       gid0
       error('huh???')
     end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

  % loop on chunk start freq's
  vlist
  for vv = 1 : length(vlist)
    vchunk = vlist(vv)

    % get monochromatic and compressed filenames
    if gid == 1 | gid == 103 | gid == 110
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

    %gid
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