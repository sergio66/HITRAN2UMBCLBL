home = pwd

nbox = 5;
pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('rming incomplete g1')
gid = 1;
freq_boundaries
thedir = dir([dirout 'stdH2O*.mat']);

for ii = 1 : length(thedir)
  lala(ii) = thedir(ii).bytes;
  if thedir(ii).bytes <= eps
    fname = [dirout thedir(ii).name];
    rmer = ['!/bin/rm ' fname];
    fprintf(1,'%s \n',fname);
    eval(rmer);
  end
end

plot(lala);
oo = find(lala <= eps);
fprintf(1,'found %5i bad H2O files out of %5i \n',length(oo),length(thedir))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cder = ['cd ' home]; eval(cder);