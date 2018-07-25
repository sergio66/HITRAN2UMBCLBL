clear all

ix = input('Enter [gasID(101 or 102) chunk(605:25:2830) toffset(1:1:11) CKD] : ');

tstr = num2str(ix(3));
fnamex = ['/asl/data/kcarta/KCARTADATA/General/CKDieee_le'];

CKD = ix(4);
d1comp = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(1)   '/IR/kcomp.CKD/'];
dNcomp = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(CKD) '/IR/kcomp.CKD/'];

d1uncomp = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(1)   '/IR/g'];
dNuncomp = ['/asl/s1/sergio/RUN8_NIRDATABASE/CKD/' num2str(CKD) '/IR/g'];

mult = 1.0e23;
ckd1str = ['_CKD_' num2str(1)];
ckdNstr = ['_CKD_' num2str(CKD)];

f1comp   = [d1comp   '/cg' num2str(ix(1)) 'v' num2str(ix(2)) ckd1str '.mat'];
fNcomp   = [dNcomp   '/cg' num2str(ix(1)) 'v' num2str(ix(2)) ckdNstr '.mat'];

if ix(1) == 101
  fnamex  = [fnamex '/CKDSelf' num2str(CKD) '.bin'];
  f1uncomp = [d1uncomp num2str(ix(1)) '.dat/stdSELF' num2str(ix(2)) '_1_' tstr ckd1str '.mat'];
  fNuncomp = [dNuncomp num2str(ix(1)) '.dat/stdSELF' num2str(ix(2)) '_1_' tstr ckdNstr '.mat'];
elseif ix(1) == 102
  fnamex  = [fnamex '/CKDFor' num2str(CKD) '.bin'];
  f1uncomp = [d1uncomp num2str(ix(1)) '.dat/stdFORN' num2str(ix(2)) '_1_' tstr ckd1str '.mat'];
  fNuncomp = [dNuncomp num2str(ix(1)) '.dat/stdFORN' num2str(ix(2)) '_1_' tstr ckdNstr '.mat'];
end

[kx, freq, temp] = contread2(fnamex);

e1 = exist(f1comp);
e2 = exist(fNcomp);

if e1 > 0 & e2 > 0
  clear a1 a2
  disp(' ')
  disp('Reading CKD1 files ... ')
  fprintf(1,'  %s \n',f1comp)
  fprintf(1,'  %s \n',f1uncomp)

  loader = ['a1 = load(''' f1comp ''');'];
  eval(loader);

  fprintf(1,'number of (1) basis vectors = %3i \n',a1.d)
  donk = squeeze(a1.kcomp(:,:,ix(3)));
  new = (a1.B * donk)'; 
  new1 = new.^(4);

  loader = ['a2 = load(''' f1uncomp ''');'];
  eval(loader);
  old1 = a2.d * mult; 

  %%%%%%%%%%%%%%%%%%%%%%%%%
  clear a1 a2
  disp(' ')
  disp('Reading CKDN files ... ')
  fprintf(1,'  %s \n',fNcomp)
  fprintf(1,'  %s \n',fNuncomp)

  loader = ['a1 = load(''' fNcomp ''');'];
  eval(loader);

  fprintf(1,'number of (N) basis vectors = %3i \n',a1.d)
  donk = squeeze(a1.kcomp(:,:,ix(3)));
  new = (a1.B * donk)'; 
  newN = new.^(4);

  loader = ['a2 = load(''' fNuncomp ''');'];
  eval(loader);
  oldN = a2.d * mult; 

  %%%%%%%%%%%%%%%%%%%%%%%%%

  figure(1); imagesc(a1.fr,1:100,new1);       colorbar; title('compressed reconstruct CKD1');
  figure(2); imagesc(a1.fr,1:100,newN);       colorbar; title('compressed reconstruct CKDN');
  figure(3); 
    imagesc(a1.fr,1:100,(new1-newN)./newN * 100);     colorbar; title('100*(new1-newN)/new1')

  figure(4)
    plot(a1.fr,new1(1:10:100,:)./newN(1:10:100,:))

  figure(5)
    plot(a1.fr,newN(1:20:100,:),freq,kx(21,:)*mult,'o-')
    axis([min(a1.fr) max(a1.fr) 0 max(newN(:))*1.25])

  figure(6)
    plot(a2.w,oldN./old1); title('raw uncompressed CKDN/CKD1')

  if CKD == 6
    xmult = load('/home/sergio/SPECTRA/CKDLINUX/tunmlt_iasi_may09X.dat');
    plot(xmult(:,2),xmult(:,5),'ko-',a2.w,oldN./old1); title('raw uncompressed CKD1/CKDN')
    axis([min(a2.w) max(a2.w) 0.95*min(oldN(:,1)./old1(:,1)) 1.05*max(oldN(:,1)./old1(:,1))]); grid
  end

else
  fprintf(1,'%s DNE \n',fcomp)
  fprintf(1,'%s DNE \n',funcomp)
end
