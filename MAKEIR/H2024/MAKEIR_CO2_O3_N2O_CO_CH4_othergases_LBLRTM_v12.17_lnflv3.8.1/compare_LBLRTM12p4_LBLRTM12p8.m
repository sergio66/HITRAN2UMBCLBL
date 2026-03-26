function compare_LBLRTM12p4_LBLRTM12p8(gid,chunk,toffset)

dirout1 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm2/'];
dirout2 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm/'];
dirout3 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat_LM/'];

dir1 = dir([dirout1 '/std*.mat']);
dir2 = dir([dirout2 '/std*.mat']);
dir3 = dir([dirout3 '/std*.mat']);
fprintf(1,'for dirout1 there were %4i files \n',length(dir1));
fprintf(1,'for dirout2 there were %4i files \n',length(dir2));
fprintf(1,'for dirout3 there were %4i files \n',length(dir3));

fout = ['/std' num2str(chunk) '_' num2str(gid) '_' num2str(toffset) '.mat'];
dir1 = dir([dirout1 fout]);
dir2 = dir([dirout2 fout]);
dir3 = dir([dirout3 fout]);

if length(dir1) == 1
  fprintf(1,' yes dir1 has file %s \n',fout);
end  
if length(dir2) == 1
  fprintf(1,' yes dir2 has file %s \n',fout);
end
if length(dir3) == 1
  fprintf(1,' yes dir3 has file %s \n',fout);
end
if length(dir1) == 1 & length(dir2) == 1 & length(dir3) == 0
  loader = ['a1 = load(''' [dirout1 fout] ''');']; eval(loader)
  loader = ['a2 = load(''' [dirout2 fout] ''');']; eval(loader)
  figure(1); subplot(211); semilogy(a1.w,a1.d(:,1),'b.-',a1.w,a2.d(:,1),'r')
  figure(1); subplot(212); plot(a1.w,a1.d(:,1)./a2.d(:,1))  
  figure(2); subplot(211); semilogy(a1.w,sum(a1.d'),a1.w,sum(a2.d'))
  figure(2); subplot(212); plot(a1.w,sum(a1.d')./sum(a2.d'))  
elseif length(dir1) == 1 & length(dir2) == 1 & length(dir3) == 1
  loader = ['a1 = load(''' [dirout1 fout] ''');']; eval(loader)
  loader = ['a2 = load(''' [dirout2 fout] ''');']; eval(loader)
  loader = ['a3 = load(''' [dirout3 fout] ''');']; eval(loader)
  a3.d = a3.d';
  a1
  a2
  a3
  figure(1); subplot(211); semilogy(a1.w,a1.d(:,1),'b.-',a1.w,a2.d(:,1),'r',a1.w,a3.d(:,1),'k'); grid
  figure(1); subplot(212); plot(a1.w,a2.d(:,1)./a1.d(:,1),'r',a1.w,a3.d(:,1)./a1.d(:,1),'k'); grid  
  figure(2); subplot(211); semilogy(a1.w,sum(a1.d'),a1.w,sum(a2.d'),'r',a1.w,sum(a3.d'),'k'); grid
  figure(2); subplot(212); plot(a1.w,sum(a2.d')./sum(a1.d'),'r',a1.w,sum(a3.d')./sum(a1.d'),'k'); grid  
end  
