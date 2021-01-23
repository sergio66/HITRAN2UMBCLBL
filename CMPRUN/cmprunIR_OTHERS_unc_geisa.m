function cmprunIR_OTHERS(glist, vlist, HITRAN)

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
end

if nargin < 1
  glist = 1:42;	             % default to all non-xsec gases

  glist = [[1:42] [51:81]];  % default to all          gases
  glist = [31:42];
  glist = 51:81;             % default to all xsec     gases

  glist = 51:81;             % default to all xsec     gases
  glist = 3:42;              % default to all mol     gases
  glist = 2;                 % CO2
  glist = 51:81;             % default to all xsec     gases
  
  glist = [3 4 5 6 9 12];    %% doing the HIRTRAN UNC perturbations
  glist = [3 4 5 6 9];       %% doing the HIRTRAN UNC perturbations

  glist = [3:42];            % all gases
  glist = 2;

  glist = [7 22];            % latest MT CKD3.2

  glist = 3;
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
     case 1
       error('not for gas 1')
       gdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '_WV/abs.dat']; 
       cdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '_WV/kcomp.h2o'];

%{
[sergio@taki-usr2 MAKEIR]$ grep -in 'LM5ptbox' */*/*.m
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:9:file0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/abs.dat/full/g2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:10:file1 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/abs.dat/full/g2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:11:file2 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/abs.dat/full/g2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:12:file3 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/abs.dat/full/g2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:40:file0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/kcomp/full/cg2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:41:file1 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/kcomp/full/cg2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:42:file2 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/kcomp/full/cg2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/check_what_I_made.m:43:file3 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/kcomp/full/cg2v730.mat';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/compare_voigt_LM_run8.m:31:  lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox/';              %% 385 ppm
H2016_G2015/JMHartmann_HITRANXY_CO2LM/compare_voigt_LM_run8.m:33:  lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_noWVbroad/';    %% 385 ppm
H2016_G2015/JMHartmann_HITRANXY_CO2LM/compare_voigt_LM_run8.m:35:  lmdir   =  '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18/';
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:4:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_noWVbroad/';   %% no Birn, no WV broad, 0.0005 cm-1 res boxcar integrate to 0.0025, this is GARBAGE
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:5:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox/';             %% no Birn, 0.0005 cm-1 res boxcar integrate to 0.0025
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:30:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_385ppm/';         %% first cut, forgot to do the adjustment to 400 ppm
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:31:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/';         %% first cut,           do the adjustment to 400 ppm
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:32:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/';  %% first fix cut, redid Qtips, voigt/lorentz rdmult=1e6, xfar=500
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:33:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/';  %% second fix cut,redid Qtips, voigt/lorentz rdmult=1e3, xfar=500
H2016_G2015/JMHartmann_HITRANXY_CO2LM/outputdir.m:34:output_dir5 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/';  %% third fix cut,redid Qtips, voigt/lorentz rdmult=1e3, xfar=500, revert to orig
%}       
     case 2
       gdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '_CO2/abs.dat']; 
       cdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '_CO2/kcomp'];

       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcomp/'];

       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat/hartmann/kcomp/'];
       
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_385ppm//abs.dat/full/'];
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_385ppm//kcomp/full/'];
       
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm//abs.dat/full/'];
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm//kcomp/full/'];
       
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1//abs.dat/full/'];
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1//kcomp/full/'];

       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2//abs.dat/full/'];
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2//kcomp/full/'];

       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3//abs.dat/full/'];
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3//kcomp/full/']; 

       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
       disp('WARNING!!!! NANs may show up in the abs.dat, which show up in the kcomp files')
       disp('so go back to eg /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2012/MAKEIR_CO2_LINEMIXUMBC_H12')
       disp('and run find_nan_put_zeros.m')
       disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')

     otherwise
       %GEISA 2015
       gdir = ['/asl/s1/sergio/G' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/abs.dat/']; 
       cdir = ['/asl/s1/sergio/G' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/kcomp/'];
     
       %% H XY
       gdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '/abs.dat']; 
       cdir = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H' num2str(HITRANvers,'%02d') '/kcomp'];

       %% H 16
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830/kcomp/'];

       %HITRAN UNC
       gdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830_unc/abs.dat/']; 
       cdir = ['/asl/s1/sergio/H' num2str(HITRAN,'%04d') '_RUN8_NIRDATABASE/IR_605_2830_unc/kcomp/'];

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
