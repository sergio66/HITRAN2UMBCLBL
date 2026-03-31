function bad = driver_check_negative_od(gid)

%% bad = 89 x 11

nbox = 5;
pointsPerChunk = 10000;
iUsualORHigh = -1;    %%% these are high res, using 0.0005 cm-1 output

set_the_freq_boundaries  %%% make sure you do this!!!!!

home = pwd;

slash = findstr(dirout,'/');
if dirout(end) == '/'
  diroutXN = dirout(1:slash(end-1)-1);
else
  diroutXN = dirout(1:slash(end)-1);
end

%%% diroutXN = [dirout '/'];
%%% fout = [diroutXN '/abs.dat']

%% want to stop two slashes before
slash = findstr(dirout,'/');
dirlbl = 'lblrtm12.8';
dirlbl = 'lblrtm12.17';

if iUsualORHigh > 0
  diroutXN = [dirout(1:slash(6)) '/' dirlbl '/all/abs.dat'];
  diroutXN = [dirout(1:slash(6)) '/' dirlbl '/all/abs.dat'];  
elseif iUsualORHigh == -1
  diroutXN = [dirout(1:slash(6)) '/' dirlbl '/all/abs.dat0.0005/'];
elseif iUsualORHigh == -2
  diroutXN = [dirout(1:slash(6)) '/' dirlbl '/all/abs.dat0.0001/'];
elseif iUsualORHigh == -3
  diroutXN = [dirout(1:slash(6)) '/' dirlbl '/all/abs.dat0.0002/'];
else
  error('unknown option iUsualORHigh')
end

ee = exist(diroutXN,'dir');
if ee == 0
  diroutXN
  error('dir DNE')
end

iCnt = 0;
for ff = 605 : 25 : 2830
  iCnt = iCnt + 1;
  if mod(iCnt,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  bad(iCnt,1:11) = 0;  %% all good
  
  fout = [diroutXN '/g' num2str(gid) 'v' num2str(ff) '.mat'];
  loader = ['a = load(''' fout ''');'];
  eval(loader)
  for tt = 1 : 11
    d = squeeze(a.k(:,:,tt));
    moo = find(d <= 0);
    if length(moo) > 0
      bad(iCnt,tt) = 1;
    end
  end
end

fprintf(1,'\n');
boo = sum(bad(:));
fprintf(1,'found %5i bad ff/Toff combos \n',boo)
