%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

addpath /home/sergio/SPECTRA

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB  = 1

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

freq_boundaries_g103

fmin = wn1; 
fchunks = 605 : 25 : 2805;
fmin = fchunks(JOB);

fout = [dirout '/abs.dat'];
ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  if iAns == 1
    mker = ['!mkdir ' fout];
    eval(mker);
  else
    error('cannot proceed');
  end
end

%while fmin <= wn2
  fmin;
  fmax = fmin + dv;
  gg = 1;   %%gasID = 1
  gid = gg;  

  fr = [];
  k = zeros(10000,100,11);
  for mm = 1 : 5
    iSave = 0;  
    for pp = -5 : +5
      fin = [dirout '/stdHDO' num2str(fmin)];
      fin = [fin '_1_' num2str(pp+6) '_' num2str(mm) '.mat'];
      lser = dir(fin);
      if lser.bytes > 500000
        iSave = iSave + 1;
        fprintf(1,'gas freq pp mm = %3i %6f %3i %3i \n',gg,fmin,pp,mm);

        loader = ['load ' fin ];
        eval(loader);

        fr = w;
        k(:,:,pp+6) = d';
        if pp == 0
          plot(fr,exp(-d(1,:)));   % disp('ret to continue');   
          title(num2str(mm));      pause(0.1)
        end
      else
        fprintf(1,'%s size %8i \n',fin,lser.bytes)
      end               %% loop over filezize > 500000
    end                 %% loop over temperature
    if iSave == 11
      fout = [dirout '/abs.dat/g103v' num2str(fmin) 'p' num2str(mm) '.mat'];
      saver = ['save ' fout ' fr gid k ' ];
      fprintf(1,'saving gas %3i : freq %5i partial pressure %2i \n ---->>>>  %s \n',gg,fmin,mm,fout);
      eval(saver);
    else
      fprintf(1,'file(s) too small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
    end  %% if
  end                 %% loop over pressure
  fmin = fmin + dv;
%end                   %% loop over freq

