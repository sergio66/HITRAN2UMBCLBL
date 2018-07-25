ia = input('Enter gasID  Chunk : ');

%%/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/abs.dat/g3v605.mat

fname = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/abs.dat/g';
fname = [fname num2str(ia(1)) 'v' num2str(ia(2)) '.mat'];
ee = exist(fname);
if ee > 0
  loader = ['load ' fname]; eval(loader);
  figure(1); kgnd = squeeze(k(:,1,6)); semilogy(fr,kgnd);
  zmax = localmaxmin(kgnd,'max');
  zmin = localmaxmin(kgnd,'min');

  kplotMax = squeeze(k(1,:,:));
  figure(2); semilogy(-50:10:+50,kplot(1:10:100,:),'b')
else
  fprintf(1,'%s does not exist! \n',fname);
  end