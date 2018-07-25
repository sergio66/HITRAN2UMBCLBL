cd /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/
homedir = pwd;
cd /asl/data/kcarta/KCARTADATA/RefProf_July2010.For.v115up_CO2ppmv385

%% need to take the old prof and multiply everything by scale factor, as
%% old prof had toooooo much gas!

old41 = load('OLD/g41');
new41 = load('g41');

old80 = load('OLD/g80');
new80 = load('g80');

for ii = 2 : 5
  fprintf(1,'plotting column # %3i \n',ii);
  plot(old41(:,ii)./new41(:,ii)); title('old41/new41'); pause(0.5)
  plot(old80(:,ii)./new80(:,ii)); title('old80/new80'); pause(0.5)
  plot(old41(:,ii)./old80(:,ii)); title('old41/old80'); pause(0.5)
  plot(new41(:,ii)./new80(:,ii)); title('new41/new80'); pause(0.5)
  disp('ret to continue'); pause
  end

ii=5;  plot(old41(:,ii)./new41(:,ii)); title('gamnt old41/new41'); pause(0.5)
ii=5;
profmult = new41(:,ii)./old41(:,ii);
plot(profmult); title('profmult = new/old')
profmult = profmult * ones(1,10000);

%% do gas41
cder = ['cd ' homedir]; eval(cder);
cd g41.dat
for ff = 605 : 25 : 2805
  for tt = 1 : 11
    f1 = ['../g41_oldprof.dat/std' num2str(ff) '_41_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g41.dat/std' num2str(ff) '_41_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

%% do gas80
cder = ['cd ' homedir]; eval(cder);
cd g80.dat
for ff = 605 : 25 : 2805
  for tt = 1 : 11
    f1 = ['../g80_oldprof.dat/std' num2str(ff) '_80_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g80.dat/std' num2str(ff) '_80_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

cder = ['cd ' homedir]; eval(cder);
cd g41.dat; 
cd ../g41.dat;         load std930_41_6; d41new = d;
cd ../g41_oldprof.dat; load std930_41_6; d41old = d;
cd ../g80.dat;         load std930_80_6; d80new = d;
cd ../g80_oldprof.dat; load std930_80_6; d80old = d;

pmult = profmult(:,1);
semilogy(1:100,pmult,'o',1:100,d41new(:,1)./d41old(:,1),'r')
semilogy(1:100,pmult,'o',1:100,d80new(:,1)./d80old(:,1),'r')

semilogy(w,d41new(4,:),w,d80new(4,:),'r')