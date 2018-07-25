%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

freq_boundaries_g1
  h2odir = dirout;

h2oalldir = [h2odir(1:end-7) 'g110.dat/'];

dirout = h2oalldir;

fmin = wn1; 

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

while fmin <= wn2
  fmin
  fmax = fmin + dv;
  gg = 1;   %%gasID = 1
  gid = gg;  

  iSave = -1;

  fr = [];
  k = zeros(10000,100,11);
  for mm = 1 : 5
    fout = [dirout '/abs.dat/g1v' num2str(fmin) 'p' num2str(mm) '.mat'];  %% really should have done g110v oh well
    if exist(fout) == 0
      for pp = -5 : +5
        fin = [dirout 'stdH2O' num2str(fmin)];
        fin = [fin '_1_' num2str(pp+6) '_' num2str(mm) '.mat'];
        lser = dir(fin);
        if lser.bytes > 500000
          iSave = +1;
          fprintf(1,'gas freq pp mm = %3i %6f %3i %3i \n',gg,fmin,pp,mm);

          loader = ['load ' fin ];
          eval(loader);

          fr = w;
          k(:,:,pp+6) = d';
          if pp == 0
            plot(fr,exp(-d(1,:)));   % disp('ret to continue');   
            title(num2str(mm));      pause(0.1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
      else
        fprintf(1,'file too small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
      end    %% if iSave > 0
    else
      fprintf(1,'fout = %s already exists \n',fout);
    end      %% if exist
  end        %% loop over m
  fmin = fmin + dv;
end          %% loop over freq

