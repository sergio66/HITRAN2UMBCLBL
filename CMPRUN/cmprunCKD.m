function cmprunCKD(glist, vlist)

homedir = pwd;
nbox = 5; pointsPerChunk = 10000;

iNew_or_Orig = -1  %% made by /home/sergio/HITRAN2UMBCLBL/MAKE_CKD/;
iNew_or_Orig = +1  %% made by /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/;

if iNew_or_Orig < 0
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKE_CKD'];
else  
  cder = ['cd ~/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/'];
end

eval(cder);
freq_boundaries_continuum

if nargin < 2
  vlist = wn1 : dv : wn2; % default to all frequency chunks
end
if nargin < 1
  glist = 101:102;
end

if length(setdiff(glist,[101 102])) > 0
  error('can only have glist = 101 oe 102 or both')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compression script
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

if iNew_or_Orig < 0
  cdir = [dirout '/' num2str(CKD) '/' bandID '/kcomp.CKD/'];
else
  cdir = [dirout '//kcomp.CKD/'];
  cdir = [diroutCompressed '/'];  
end

ee = exist(cdir,'dir');
if ee == 0
  fprintf(1,'dir %s does not exist \n',cdir);
  iYes = input('make dir? (+1 = yes) ');
  if iYes == 1
    mker = ['!mkdir ' cdir]; eval(mker)
  else
    error('cannot proceed')
  end
end

abseps = 1e-8;

cder = ['cd ' homedir]; eval(cder);

load_ref_profile

%load /home/sergio/abscmp/refpro
%glist = intersect(glist, refpro.glist);
%clear refpro

glist
vlist

% loop on gas IDs
for gid = glist
  %% orig code
  if iNew_or_Orig < 0
    gdir = [dirout '/' num2str(CKD) '/' bandID '/abs.dat/'];
    cdir = [dirout '/' num2str(CKD) '/' bandID '/kcomp.CKD/'];
  else
    gdir = [diroutABC '//abs.dat/'];
    cdir = cdir;
  end    
  
  disp(' ')
  fprintf(1,'gid = %2i \n',gid);
  fprintf(1,'gdir = %s \n',gdir)
  fprintf(1,'cdir = %s \n',cdir)
  disp('ret to continue'); pause

  % loop on chunk start freq's
  for vchunk = vlist

    % get monochromatic and compressed filenames
    if gid == 101 | gid == 102
      if iNew_or_Orig < 0      
        fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
        fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD) '.mat'];
      else
        fmon = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD) '.mat'];
      end
    end

    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);
    fcmp = [cdir '/cg' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD) '.mat'];

    %vchunk
    %fmon
    %fcmp
    %pause

    if ~exist(fmon)
      fprintf(1,'monochromatic %s DNE \n',fmon)      
    elseif exist(fmon) == 2  % monochromatic data exists

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
        B = absbasisCKD(gid, gdir, vchunk, CKD);
        absbcmpCKD(gid, gdir, cdir, vchunk, B, CKD);
      end

    end
  end % vchunk loop
end % gid loop

disp('Now go to the "fortran" directory and make the ieee-le files ...')
