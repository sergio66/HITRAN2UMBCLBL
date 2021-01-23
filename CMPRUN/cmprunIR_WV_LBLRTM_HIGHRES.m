function cmprunIR_WV_LBLRTM_HIGHRES(glist, vlist, HITRAN)

%% call with cmprunIR_WV_H12_HIGHRES([1 103],605:5:855);

% compression script
% existing data is not deleted, so if you want to
% update data, the old stuff should be deleted first

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil

homedir = pwd;
nbox = 5; pointsPerChunk = 10000;

if nargin == 0
  glist = 110;
  HITRAN = 2016;
  vlist = 605:5:2830;
elseif nargin == 1
  HITRAN = 2016;
  vlist = 605:5:2830;
elseif nargin == 2
  HITRAN = 2016;
end

gid = glist;

%%%%%%%%%%%%%%%%%%%%%%%%%

if HITRAN == 2012
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_WV_H12']; eval(cder);
  freq_boundaries_g1_LBL
else
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8']; eval(cder);
  iUsualORHigh = -1;    %%% these are high res, using 0.0005 cm-1 output
  freq_boundariesLBL    %%% these are high res, using 0.0005 cm-1 output
end
cdirALL = [dirout '/kcomp.h2o/0.0005/']; 
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
dirout_1 = dirout;

%%%%%%%%%%%%%%%%%%%%%%%%%

if HITRAN == 2012
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_WV_H12']; eval(cder);
  freq_boundaries_g103_LBL
else
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8']; eval(cder);
  iUsualORHigh = -1;    %%% these are high res, using 0.0005 cm-1 output
  freq_boundariesLBL    %%% these are high res, using 0.0005 cm-1 output
end

cdir_1_103 = [dirout '/kcomp.h2o/0.0005/']; 
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
dirout_103 = dirout;

%%%%%%%%%%%%%%%%%%%%%%%%%

if HITRAN == 2012
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_WV_H12']; eval(cder);
  freq_boundaries_g1
  dirout = [dirout(1:end-7) 'g110.dat/'];
  cdir_110 = [dirout '/kcomp.h2o/0.0005/']; 
else
  cder = ['cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8']; eval(cder);
  iUsualORHigh = -1;    %%% these are high res, using 0.0005 cm-1 output
  freq_boundariesLBL    %%% these are high res, using 0.0005 cm-1 output
  dirout = [dirout(1:end-7) 'g110.dat/'];
  dirout = [dirout(1:end-7) '/lblrtm12.8/'];
  dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/';
  cdir_110 = [dirout '/kcomp.h2o/0.0005/']; 
end
ee = exist(cdir_110,'dir');
fprintf('chunks 605-2805 in %s \n',cdir_110);
if ee == 0
  fprintf(1,'dir %s does not exist \n',cdir_110);
  iYes = input('make dir? (+1 = yes) ');
  if iYes == 1
    mker = ['!mkdir -p ' cdir_110]; eval(mker)
  else
    error('cannot proceed')
    end
  end
dirout_110 = dirout;

       %% 2016 was saved in /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005//
       %% so make a symbolic link
       %% cd /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//g1.dat/lblrtm0.0005/
       %% ln -s /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/all/abs.dat0.0005// abs.dat
       %% mkdir kcomp

%ln -s /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/WV/abs.dat0.0005/ /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/lblrtm0.0005//abs.dat/

%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ')
fprintf(1,'save gases 1,103,110    in %s %s %s \n',dirout_1,dirout_103,dirout_110);

allfreqchunks = 605 : 25 : 2830-25;

allfreqchunks = 605 : 5 : 855;

allfreqchunks = vlist;

%hdochunks = [];
%for ii = 1 : iNumBands
%  wn1 = wn1all(ii);
%  wn2 = wn2all(ii);
%  xx = wn1 : 25 : wn2;
%  hdochunks = [hdochunks xx];
%  end
%hdochunks = sort(hdochunks);  %% do all chunks beginning with this
hdochunks = allfreqchunks;

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
  glist = [1 103];
  glist = [1 103 110];
  glist = [110];
end

abseps = 1e-8;

% load reference profile to check gasses available
% load /home/sergio/abscmp/refproTRUE
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

cder = ['cd ' homedir]; eval(cder);
% loop on gas IDs
glist

for gid00 = 1 : length(glist)
   gid0 = glist(gid00);
   % set directories, depending on gas ID
   switch gid0
     case 1
       gid = gid0;
       vlist = hdochunks;
       gdir = [dirout_1 '/abs.dat/']; 
       cdir = [dirout_1 '/kcomp.h2o/0.0005/']; 
       gidx = gid;
     case 103
       gid = gid0;
       vlist = hdochunks;
       gdir = [dirout_103 '/abs.dat/']; 
       cdir = [dirout_103 '/kcomp.h2o/0.0005/']; 
       gidx = gid;
     case 110
       gid = gid0;
       vlist = hdochunks;
       gdir = [dirout_110 '/abs.dat/'];
       gdir = [dirout_110 '/WV/abs.dat0.0005/'];
       cdir = [dirout_110 '/kcomp.h2o/0.0005/'];
       gidx = 1; 
     otherwise
       gid0
       error('huh???')
   end

disp(' ')
fprintf(1,'gid = %2i \n',gid);
fprintf(1,'gdir = %s \n',gdir)
fprintf(1,'cdir = %s \n',cdir)

  % loop on chunk start freq's
  for vv = 1 : length(vlist)
    vchunk = vlist(vv);

    % get monochromatic and compressed filenames
    if gid == 1 | gid == 103 | gid == 110
      %% don't worry about only looking for g1vXYZp3.mat; when absbasis and
      %% abscmp below are called, all 5 pressure offsets are read in 
      %% and compressed
      fmon = sprintf('%s/g%dv%dp3.mat', gdir, gid, vchunk);
      fmon = [gdir '/g' num2str(gidx) 'v' num2str(vchunk) 'p3.mat'];
    else
      fmon = sprintf('%s/g%dv%d.mat', gdir, gid, vchunk);        
      fmon = [gdir '/g' num2str(gidx) 'v' num2str(vchunk) '.mat'];
    end

    fcmp = sprintf('%s/cg%dv%d.mat', cdir, gid, vchunk);
    fcmp = [cdir '/cg' num2str(gidx) 'v' num2str(vchunk) '.mat'];

    if exist(fmon) == 2  % monochromatic data exists
      if exist(fcmp) == 2  % compressed data exists

        % we found compressed data, so just print a message
        fprintf(1, 'cmprun: %s already exists\n', fcmp);
      else

        fprintf(1, 'making  %s \n', fcmp);
        % check for old data with max below abseps
        eval(['load ',fmon]);
        gid = gid; %%% this is new line, as need to replace 1 --> 103
	%%%gid = 103;
	
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
