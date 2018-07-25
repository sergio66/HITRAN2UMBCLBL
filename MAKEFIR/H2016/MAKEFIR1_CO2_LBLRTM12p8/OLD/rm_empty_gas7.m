%% get rid of all empty files in /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm/

clear all

nbox = 5;
pointsPerChunk = 10000;
gid = 7;

freq_boundaries

thedir = dir([dirout '*.mat']);
fprintf(1,'there are %4i files out of expected 11*90 = 990 files in %s \n',length(thedir),dirout);
disp('rming the empty ones ....')
iCnt = 0;
for ii = 1 : length(thedir)
  xyz = thedir(ii).bytes;
  fname = thedir(ii).name;
  if xyz == 0
    iCnt = iCnt + 1;
    rmer = ['!/bin/rm ' dirout '/' fname]; fprintf(1,'%s \n',rmer);
    eval(rmer)
  end
end
fprintf(1,'removed %3i out of %3i files \n',iCnt,length(thedir))

NumChunks = (2830-605)/25+1;
NumChunks = (2830-1305)/25+1;
if iCnt == 0 & length(thedir) == NumChunks*11
  iYes = input('Now that all seems done, Do you want to move the files to TEMP, so that you can separate them out???? (-1/+1) : ');
  if iYes > 0
    dirTEMP = [dirout '/TEMP'];
    ee = exist(dirTEMP);
    if ee == 0
      mker = ['!mkdir ' dirTEMP];
      eval(mker)
    end
    mver = ['!/bin/mv ' dirout '/*.mat ' dirTEMP '/.'];
    eval(mver)

    %% also copy them over to g7.dat/lblrtm/TEMP by making symboic links
    boo = findstr('g7.dat',dirout);
    dir22 = [dirout(1:boo-1) 'g22.dat/lblrtm'];
    ee = exist(dir22);
    if ee == 0
      mker = ['!mkdir ' dir22];
      eval(mker)
    end
    dir22 = [dir22 '/TEMP'];
    lner = ['!ln -s ' dirTEMP ' ' dir22];
    eval(lner)
  end
end
