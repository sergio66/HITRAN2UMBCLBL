addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat

clear all; 

boo = input('Enter [gid wavechunk] : ');
dir2016 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/abs.dat/'];
dir2020 = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/abs.dat/'];

f2016 = [dir2016 '/g' num2str(boo(1)) 'v' num2str(boo(2)) '.mat'];
f2020 = [dir2020 '/g' num2str(boo(1)) 'v' num2str(boo(2)) '.mat'];

if exist(f2016) & exist(f2020)
  x2016 = load(f2016);
  x2020 = load(f2020);
  
  f = x2016.fr;
  k2016 = squeeze(x2016.k(:,:,6))';
  k2020 = squeeze(x2020.k(:,:,6))';
  
  figure(1); clf; semilogy(f,sum(k2016,1),f,sum(k2020,1)); title([num2str(boo)]); ylabel(['(b) H2016 (r) H2020']);
  figure(2); clf; plot(f,sum(k2020,1)./sum(k2016,1));  ylabel('k2020/k2016'); title([num2str(boo)])
  pause(1)
else
  disp('hmm chunks for this gas may not exist for H2016 or H2020 or both')
end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf;
figure(2); clf;
iaFound2016 = [];
iaFound2020 = [];

ii = 0;
for v = 605 : 25 : 2830
  ii = ii + 1;
  iaChunk(ii) = v;
  iaFound2016(ii) = 0;
  iaFound2020(ii) = 0;

  f2016 = [dir2016 '/g' num2str(boo(1)) 'v' num2str(v) '.mat'];
  f2020 = [dir2020 '/g' num2str(boo(1)) 'v' num2str(v) '.mat'];

  if exist(f2016)
    iaFound2016(ii) = 1;
  end
  if exist(f2020)
    iaFound2020(ii) = 1;
  end

  if exist(f2016) & exist(f2020)
    fprintf(1,'gid %2i %4i cm-1 found both H2016 and H2020 \n',boo(1),v);
    x2016 = load(f2016);
    x2020 = load(f2020);
    
    f = x2016.fr;
    k2016 = squeeze(x2016.k(:,:,6))';
    k2020 = squeeze(x2020.k(:,:,6))';
    
    figure(1); hold on; semilogy(f,sum(k2020,1)); title([num2str(boo(1))]); ylabel(['H2016 and H2020']);
    figure(2); hold on; plot(f,sum(k2020,1)./sum(k2016,1));  ylabel('k2020/k2016'); title([num2str(boo(1))])

  elseif exist(f2016) & ~exist(f2020)
    fprintf(1,'gid %2i %4i cm-1 only found H2016 \n',boo(1),v);
    x2016 = load(f2016);
    
    f = x2016.fr;
    k2016 = squeeze(x2016.k(:,:,6))';
    
    figure(1); hold on; semilogy(f,sum(k2016,1)); title([num2str(boo(1))]); ylabel(['H2016']);
    figure(2); hold on; 

  elseif ~exist(f2016) & exist(f2020)
    fprintf(1,'gid %2i %4i cm-1 only found H2020 \n',boo(1),v);
    x2020 = load(f2020);
    
    f = x2020.fr;
    k2020 = squeeze(x2020.k(:,:,6))';
    
    figure(1); hold on; semilogy(f,sum(k2020,1)); title([num2str(boo(1))]); ylabel(['H2020']);
    figure(2); hold on; 

  end
end  

figure(1); hold off
figure(2); hold off; ylim([0 10])
figure(3); clf; plot(iaChunk,iaFound2016,'o',iaChunk,iaFound2020,'x');
  hl = legend('H2016','H2020','location','best','fontsize',10); xlabel('Chunk cm-1'); ylabel('Found Or Not');
fprintf(1,'gas %2i total chunks found H2016 vs H2020 %2i %2i \n',boo(1),[sum(iaFound2016) sum(iaFound2020)])
