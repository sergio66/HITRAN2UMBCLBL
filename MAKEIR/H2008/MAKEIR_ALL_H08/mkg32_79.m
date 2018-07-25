cd /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/
homedir = pwd;
cd /asl/data/kcarta/KCARTADATA/RefProf_July2010.For.v115up_CO2ppmv385

%% need to take the old prof and multiply everything by scale factor, as
%% old prof had toooooo much gas!

old32 = load('OLD2/g32');
new32 = load('g32');

old79 = load('OLD2/g79');
new79 = load('g79');

for ii = 2 : 5
  fprintf(1,'plotting column # %3i \n',ii);
  plot(old32(:,ii)./new32(:,ii)); title('old32/new32'); pause(0.5)
  plot(old79(:,ii)./new79(:,ii)); title('old79/new79'); pause(0.5)
  disp('ret to continue'); pause
  end

ii=5;  plot(old32(:,ii)./new32(:,ii)); title('gamnt old32/new32'); pause(0.5)
ii=5;
profmult = new32(:,ii)./old32(:,ii);
plot(profmult); title('profmult = new/old')
profmult = profmult * ones(1,10000);

%% do gas32
cder = ['cd ' homedir]; eval(cder);
cd g32.dat
for ff = 605 : 25 : 2830
  for tt = 1 : 11
    f1 = ['../g32_oldprof.dat/std' num2str(ff) '_32_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g32.dat/std' num2str(ff) '_32_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ii=5;  plot(old79(:,ii)./new79(:,ii)); title('gamnt old79/new79'); pause(0.5)
ii=5;
profmult = new79(:,ii)./old79(:,ii);
plot(profmult); title('profmult = new/old')
profmult = profmult * ones(1,10000);

%% do gas79
cder = ['cd ' homedir]; eval(cder);
cd g79.dat
for ff = 605 : 25 : 2830
  for tt = 1 : 11
    f1 = ['../g79_oldprof.dat/std' num2str(ff) '_79_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g79.dat/std' num2str(ff) '_79_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

cder = ['cd ' homedir]; eval(cder);
cd g32.dat; 
cd ../g32.dat;         load std930_32_6; d32new = d;
cd ../g32_oldprof.dat; load std930_32_6; d32old = d;
cd ../g79.dat;         load std930_79_6; d79new = d;
cd ../g79_oldprof.dat; load std930_79_6; d79old = d;

% pointless since these are "different" gases
%pmult = profmult(:,1);
%semilogy(1:100,pmult,'o',1:100,d32new(:,1)./d32old(:,1),'r')
%semilogy(1:100,pmult,'o',1:100,d79new(:,1)./d79old(:,1),'r')
%semilogy(w,d32new(4,:),w,d79new(4,:),'r')