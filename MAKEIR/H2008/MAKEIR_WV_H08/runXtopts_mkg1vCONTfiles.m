%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

figure(1); clf
figure(2); clf

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

freq_boundaries_continuum

iWV_Type = +0;      %% this is the special WV : all isotopes but 162
allfreqchunks = wn1 : 25 : wn2-25;

diroutX = dirout;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirIN = diroutX;
dirIN  = [dirout '/g101.dat/'];
fmin = wn1; 

for iido = 1 : length(allfreqchunks)
  fmin = allfreqchunks(iido);
  fmax = fmin + dv;
  gg = 101;   %%gasID = 1
  gid = gg;  

  iSave = -1;
  fr = [];
  k = zeros(10000,100,11);
  fout = [dirout '/abs.dat/g101v' num2str(fmin) '.mat'];
  ee = exist(fout);
  if ee > 0
    fprintf(1,'%s already exists!!! \n',fout);
  elseif ee == 0
    for pp = -5 : +5
      fin = [dirIN 'stdSELF' num2str(fmin) '_1_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
      lser = dir(fin);
      if lser.bytes > 500000
        iSave = +1;
        fprintf(1,'gas freq pp = %3i %6f %3i \n',gg,fmin,pp);

        loader = ['load ' fin ];
        eval(loader);

        fr = w;
        k(:,:,pp+6) = d';
        if pp == 0
          figure(1); hold on
          plot(fr,d(1,:));   % disp('ret to continue');   
          pause(0.1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        fout = [dirout '/abs.dat/g101v' num2str(fmin) '_CKD_' num2str(CKD) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
      else
        fprintf(1,'file small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
        end  %% if
      end
  end                   %% loop over freq

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirIN = diroutX;
dirIN  = [dirout '/g102.dat/'];
fmin = wn1; 

for iido = 1 : length(allfreqchunks)
  fmin = allfreqchunks(iido);
  fmax = fmin + dv;
  gg = 102;   %%gasID = 1
  gid = gg;  

  iSave = -1;
  fr = [];
  k = zeros(10000,100,11);
  fout = [dirout '/abs.dat/g102v' num2str(fmin) '.mat'];
  ee = exist(fout);
  if ee > 0
    fprintf(1,'%s already exists!!! \n',fout);
  elseif ee == 0
    for pp = -5 : +5
      fin = [dirIN 'stdFORN' num2str(fmin) '_1_' num2str(pp+6) '_CKD_' num2str(CKD) '.mat'];
      lser = dir(fin);
      if lser.bytes > 500000
        iSave = +1;
        fprintf(1,'gas freq pp = %3i %6f %3i \n',gg,fmin,pp);

        loader = ['load ' fin ];
        eval(loader);

        fr = w;
        k(:,:,pp+6) = d';
        if pp == 0
          figure(2); hold on
          plot(fr,d(1,:));   % disp('ret to continue');   
          pause(0.1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        fout = [dirout '/abs.dat/g102v' num2str(fmin) '_CKD_' num2str(CKD) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
      else
        fprintf(1,'file small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
        end  %% if
      end
  end                   %% loop over freq

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); title('SELF'); hold off
figure(2); title('FORN'); hold off