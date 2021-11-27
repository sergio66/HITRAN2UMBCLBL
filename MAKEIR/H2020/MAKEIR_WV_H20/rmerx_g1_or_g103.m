dir0 = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/';
thedir = dir([dir0 'stdHDO*.mat']);

dir0 = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/';
thedir = dir([dir0 'stdH2O*.mat']);

dir0 = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/';
dir0 = '/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g110.dat/';
thedir = dir([dir0 'stdH2OALL*.mat']);

for ii = 1 : length(thedir)
  lala(ii) = thedir(ii).bytes;
  if thedir(ii).bytes <= eps
    fname = [dir0 thedir(ii).name];
    rmer = ['!/bin/rm ' fname];
    fprintf(1,'%s \n',fname);
    eval(rmer);
  end
end

plot(lala);
oo = find(lala <= eps);
fprintf(1,'found %5i bad files out of %5i \n',length(oo),length(thedir))
