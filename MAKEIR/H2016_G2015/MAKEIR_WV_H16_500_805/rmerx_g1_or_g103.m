iWhich = input ('Enter 1, 103 or 110 (default) : ');
if length(iWhich) == 0
 iWhich = 110;
end

if iWhich == 103
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/';
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g103.dat/';
  thedir = dir([dir0 'stdHDO*.mat']);
elseif iWhich == 1
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/';
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g1.dat/';
  thedir = dir([dir0 'stdH2O*.mat']);
elseif iWhich == 110
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/';
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g110.dat/';
  dir0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g110.dat/';
  thedir = dir([dir0 'stdH2OALL*.mat']);
end

fprintf(1,'number of files in %s = %5i \n',dir0,length(thedir))

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
