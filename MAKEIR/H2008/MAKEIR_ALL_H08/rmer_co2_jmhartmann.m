cd  /asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/g2.dat
lser = dir('*.txt');
for ii = 1 : length(lser)
  name0 = lser(ii).name;
  name1 = [name0(1:length(name0)-4) '.mat'];
  lsnew = ['!ls -lt ' name1];
  eval(lsnew);
  lsxer = dir(name1);
  lnfile(ii) = lsxer.bytes;
  if (lnfile(ii) == 0)
    rmer = ['!/bin/rm ' name0 ' ' name1];
    eval(rmer);
    end
  end

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08
