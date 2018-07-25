addpath /home/sergio/SPECTRA

ix = input('Enter [gasID(101 or 102) chunk(605:25:2830) toffset(1:1:11) CKD] : ');

fnamex = ['/asl/data/kcarta/KCARTADATA/General/CKDieee_le'];

CKD = ix(4);
dcomp   = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(CKD) '/IR/kcomp.CKD/'];
duncomp = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(CKD) '/IR/g'];

if CKD > 0
  mult = 1.0e23;
  ckdstr = ['_CKD_' num2str(CKD)];
else
  mult = 1.0;
  ckdstr = ' ';
end

tstr = num2str(ix(3));

fcomp   = [dcomp   '/cg' num2str(ix(1)) 'v' num2str(ix(2)) ckdstr '.mat'];
if ix(1) == 101
  funcomp = [duncomp num2str(ix(1)) '.dat/stdSELF' num2str(ix(2)) '_1_' tstr ckdstr '.mat'];
  fnamex  = [fnamex '/CKDSelf' num2str(CKD) '.bin'];
elseif ix(1) == 102
  funcomp = [duncomp num2str(ix(1)) '.dat/stdFORN' num2str(ix(2)) '_1_' tstr ckdstr '.mat'];
  fnamex  = [fnamex '/CKDFor' num2str(CKD) '.bin'];
end

[kx, freq, temp] = contread2(fnamex);

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

  figure(5)
    plot(a2.w,new(1:20:100,:),freq,kx(21,:)*mult,'o-')
    axis([min(a2.w) max(a2.w) 0 max(new(:))*1.25])
else
  fprintf(1,'%s DNE \n',fcomp)
  fprintf(1,'%s DNE \n',funcomp)
end
