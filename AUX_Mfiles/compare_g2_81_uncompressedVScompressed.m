ix = input('Enter [gasID(101 or 102) chunk(605:25:2830) toffset(1:1:11)] : ');

mult = 1;

gid = ix(1);
if gid < 2 | gid > 81
  error('need gid between 2 and 81')
end

dcomp   = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/kcomp/'];
duncomp = ['/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/g' num2str(gid) '.dat/'];

tstr = num2str(ix(3));

fcomp   = [dcomp   '/cg'  num2str(ix(1)) 'v' num2str(ix(2)) '.mat'];
funcomp = [duncomp '/std' num2str(ix(2)) '_' num2str(ix(1)) '_' tstr '.mat'];

e1 = exist(fcomp);
e2 = exist(funcomp);

clear a1 a2
if e1 > 0 & e2 > 0
  loader = ['a1 = load(''' fcomp ''');'];
  eval(loader);
  loader = ['a2 = load(''' funcomp ''');'];
  eval(loader);

  fprintf(1,'number of basis vectors = %3i \n',a1.d)
  donk = squeeze(a1.kcomp(:,:,ix(3)));
  new = (a1.B * donk)'; new = new.^(4);
  old = a2.d * mult; 
  figure(1); imagesc(a2.w,1:100,new);       colorbar; title('compressed reconstruct');
  figure(2); imagesc(a2.w,1:100,old);       colorbar; title('orig');
  figure(3); 
    imagesc(a2.w,1:100,(new-old)./old * 100);     colorbar; title('100*(new-old)/old')

  figure(4)
    plot(a2.w,new(1:10:100,:)./old(1:10:100,:))
end
