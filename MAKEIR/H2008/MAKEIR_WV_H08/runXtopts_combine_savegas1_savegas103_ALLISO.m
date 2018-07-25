%% this makes ONE directory which has all isotopes for water, 
%% so that you could have a KCARTA compressed database which
%% is like the original one from 1996-2009

%% first mv all the abs.dat/g1v2380p*.mat into abs_ALLISO.dat/g1v2380p*.mat 
%% then combine the g1 and g103 files to put into abs_ALLISO.dat/g1v*p*.mat 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% first mv all the abs.dat/g1v2380p*.mat into abs_ALLISO.dat/g1v2380p*.mat 

cd /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/
homedir = pwd;
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_WV_H08

nbox = 5;
pointsPerChunk = 10000;
freq_boundaries_new

iWV_Type = +1;      %% this all WV isotopes
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
allfreqchunks = setdiff(allfreqchunks,hdochunks);

cd /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/
for iido = 1 : length(allfreqchunks)
  fmin = allfreqchunks(iido);
  fnames2 = ['abs_ALLISO.dat/g1v' num2str(allfreqchunks(iido)) 'p*.mat'];
  fnames2a = ['abs_ALLISO.dat/.'];
  fnames1 = ['abs.dat/g1v' num2str(allfreqchunks(iido)) 'p*.mat'];
  lser = ['theres = dir(fnames1);'];
  eval(lser);
  if length(theres) > 0
    mver = ['!/bin/mv ' fnames1 ' '  fnames2a ];
    eval(mver);
    end
  end

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_WV_H08
disp('pause : ret to continue  : ')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% then combine the g1 and g103 files to put into abs_ALLISO.dat/g1v*p*.mat 
nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

freq_boundaries_new

fmin = wn1; 

fout = [dirout '/abs_ALLISO.dat'];
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

hdochunks = hdochunks(length(hdochunks)-1:length(hdochunks));
for iido = 1 : length(hdochunks)
  fmin = hdochunks(iido);
  f1A   = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/g1.dat/stdH2O';
  f103A = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV/g103.dat/stdHDO';
  for mm = 1 : 5
    for pp = -5 : 5
      clear f1 f103 d1 d103
      pt = [num2str(fmin) '_1_' num2str(pp+6) '_' num2str(mm) '.mat'];
      f1   = [f1A pt];   eval(['load ' f1]);   d1 = d;
      f103 = [f103A pt]; eval(['load ' f103]); d103 = d;
      d = d1 + d103;

      fr = w;
      k(:,:,pp+6) = d';
      if pp == 0
        plot(fr,exp(-d(1,:)));   % disp('ret to continue');   
        title(num2str(mm));      pause(0.1)
        end

      end

    gid = 1;
    fout = [dirout '/abs_ALLISO.dat/g1v' num2str(fmin) 'p' num2str(mm) '.mat'];
    fprintf(1,'%s \n',fout);
    saver = ['save ' fout ' fr gid k ' ];
    eval(saver);
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now go to /home/sergio/HITRANUMBCLBL and compress this database