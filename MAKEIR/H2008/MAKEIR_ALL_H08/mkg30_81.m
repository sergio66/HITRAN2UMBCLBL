cd /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/
homedir = pwd;
cd /asl/data/kcarta/KCARTADATA/RefProf_July2010.For.v115up_CO2ppmv385

%% need to take the old prof and multiply everything by scale factor, as
%% old prof had toooooo much gas!

old30 = load('OLD2/g30');
new30 = load('g30');

old81 = load('OLD2/g81');
new81 = load('g81');

for ii = 2 : 5
  fprintf(1,'plotting column # %3i \n',ii);
  plot(old30(:,ii)./new30(:,ii)); title('old30/new30'); pause(0.5)
  plot(old81(:,ii)./new81(:,ii)); title('old81/new81'); pause(0.5)
  plot(old30(:,ii)./old81(:,ii)); title('old30/old81'); pause(0.5)
  plot(new30(:,ii)./new81(:,ii)); title('new30/new81'); pause(0.5)
  disp('ret to continue'); pause
  end

ii=5;  plot(old30(:,ii)./new30(:,ii)); title('gamnt old30/new30'); pause(0.5)
ii=5;
profmult = new30(:,ii)./old30(:,ii);
plot(profmult); title('profmult = new/old')
profmult = profmult * ones(1,10000);

%% do gas30
cder = ['cd ' homedir]; eval(cder);
cd g30.dat
for ff = 605 : 25 : 2815
  for tt = 1 : 11
    f1 = ['../g30_oldprof.dat/std' num2str(ff) '_30_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g30.dat/std' num2str(ff) '_30_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

%% do gas81
cder = ['cd ' homedir]; eval(cder);
cd g81.dat
for ff = 605 : 25 : 2815
  for tt = 1 : 11
    f1 = ['../g81_oldprof.dat/std' num2str(ff) '_81_' num2str(tt) '.mat'];
    e1 = exist(f1);
    if e1 > 0 
      loader = ['load ' f1] 
      eval(loader);
      d = d.*profmult;
      f2 = ['../g81.dat/std' num2str(ff) '_81_' num2str(tt) '.mat'];
      saver = ['save ' f2 ' w d']; eval(saver);
      end
    end
  end

cder = ['cd ' homedir]; eval(cder);
cd g30.dat; 
cd ../g30.dat;         load std930_30_6; d30new = d;
cd ../g30_oldprof.dat; load std930_30_6; d30old = d;
cd ../g81.dat;         load std930_81_6; d81new = d;
cd ../g81_oldprof.dat; load std930_81_6; d81old = d;

pmult = profmult(:,1);
semilogy(1:100,pmult,'o',1:100,d30new(:,1)./d30old(:,1),'r')
semilogy(1:100,pmult,'o',1:100,d81new(:,1)./d81old(:,1),'r')

semilogy(w,d30new(4,:),w,d81new(4,:),'r')