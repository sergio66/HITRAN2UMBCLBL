nbox = 5;
pointsPerChunk = 10000;
freq_boundaries

homedir = pwd;

allthedir = 0;
iCnt = 0;
for gg = 1 : 42
  cder = ['cd ' dirout '/g' num2str(gg)]; eval(cder);
  thedir = dir('*.mat');
  allthedir = allthedir + length(thedir);
  for ix = 1 : length(thedir)
    thesize(ix) = thedir(ix).bytes;
    if thesize(ix) < 2e5
      iCnt = iCnt + 1;
      rmer = ['!/bin/rm ' thedir(ix).name]; fprintf(1,'%s \n',rmer);
      eval(rmer)
    end
  end
end

[iCnt allthedir]
%%plot(1:length(thedir),thesize)

cder = ['cd ' homedir]; eval(cder);

