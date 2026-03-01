allfreqchunks = 605 : 25 : 2830-25;

gasid = 102;
gasid = 101;

nbox = 5;
pointsPerChunk = 10000;

freq_boundaries_continuum
dirout0 = dirout;

load_ref_profile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iEmpty = 0;
for iido = 1: length(allfreqchunks)
  fmin = allfreqchunks(iido);
  fmax = fmin + dv;

  for tt = -5 : +5

    gg = 1;
    gasid = gasid;  
    fprintf(1,'gas freq = %3i %6i \n',gasid,fmin);

    tprof = refpro.mtemp + tt*10;

    dirout = [dirout0 '/g' num2str(gasid) '.dat/'];

    if gasid == 101
      fout = [dirout '/stdSELF' num2str(fmin)];
    else
      fout = [dirout '/stdFORN' num2str(fmin)];
    end
    fout = [fout '_' num2str(gg) '_' num2str(tt+6) '_CKD_' num2str(CKD) '.mat'];

    if ~exist(fout)
      %% file DNE
      iEmpty = iEmpty + 1;
      infoEmpty(iEmpty,1) = fmin;
      infoEmpty(iEmpty,2) = tt;
      infoEmpty(iEmpty,3) = 0;
      infoEmpty(iEmpty,4) = iido;	          
    elseif exist(fout)
      thexdir = dir(fout);
      if thexdir.bytes  < 100000
        %% file exists but is too small
        iEmpty = iEmpty + 1;
	infoEmpty(iEmpty,1) = fmin;
	infoEmpty(iEmpty,2) = tt;
	infoEmpty(iEmpty,3) = +1;	
        infoEmpty(iEmpty,4) = iido;
      
        fprintf(1,'%s is empty file size %8i \n',fout,thexdir.bytes)
	%iYes = input('remove (-1/+1 default) : ');
	iYes = 1;
	if length(iYes) == 0
	  iYes = +1;
	end
	if iYes > 0
	  rmer = ['!/bin/rm ' fout];
	  eval(rmer)
	end   %% rm empty file
      end     %% this file looks empty
    end       %% the file exists, could be filled, could be empty
  end         %% loop over tt
end           %% loop over freq

if iEmpty > 0
  disp('these are the empty files : raFreq vs Toffset')
  disp(' fmin   tt(-5:+5)    empty/missiing  slumrINDEX')
  disp('--------------------------------------------------')
  infoEmpty
end

fprintf(1,'there are 89 chunks from 605:25:2830, so expect 11 * 89 files = 979 \n');
lser = ['ls -lt ' dirout0 '/g101.dat/*.mat | wc -l'];
  [a,b] = system(lser);
  fprintf(1,'for SELF found %s files \n',b)
lser = ['ls -lt ' dirout0 '/g102.dat/*.mat | wc -l'];  
  [a,b] = system(lser);
  fprintf(1,'for FORN found %s files \n',b)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iEmpty > 0

  all = 1 : 90;
  iaNotFound = unique(infoEmpty(:,4))

  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt  
  
  disp(' ')
  disp(' ')  
  disp('  But much beter to edit/run "jobs_not_done.sc" output from write_out_jobsnotdone_for_cluster')
  if gasid == 101
    disp(' gasid == 101 : SELF : sergio_matlab_chip.sbatchX --> sergio_matlab_chip_makegas1_103.sbatch,   XYZ --> 7')
  elseif gasid == 102
    disp(' gasid == 102 : FORN : sergio_matlab_chip.sbatchX --> sergio_matlab_chip_makegas1_103.sbatch,   XYZ --> 8')
  end
  disp('XYZ should be set to 1')  
  if length(iaNotFound) > 0
    addpath /home/sergio/git/matlabcode
    write_out_jobsnotdone_for_cluster(iaNotFound,1:90);
  end  
end
