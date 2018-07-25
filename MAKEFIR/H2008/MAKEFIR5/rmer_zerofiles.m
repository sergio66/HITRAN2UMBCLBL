nbox = 5;
pointsPerChunk = 10000;
freq_boundaries

homedir = pwd;

cder = ['cd ' dirout]; eval(cder);

iCnt = 0;
thedir = dir('*.mat');
for ix = 1 : length(thedir)
  thesize(ix) = thedir(ix).bytes;
  if thesize(ix) < 2e5
    iCnt = iCnt + 1;
    rmer = ['!/bin/rm ' thedir(ix).name]; fprintf(1,'%s \n',rmer);
    eval(rmer)
  end
end
[iCnt length(thedir)]
plot(1:length(thedir),thesize)

cder = ['cd ' homedir]; eval(cder);

