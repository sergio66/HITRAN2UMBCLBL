ix = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('file0 = untouched LM : rd = 30  = switch to Lor, old Qtips, incorrect span bands, orig radiation correction')
disp('file1 = new       LM : rd = 1e6 = switch to Lor, new Qtips,   correct span bands, new  radiation correction')
disp('file2 = new       LM : rd = 1e3 = switch to Lor, new Qtips,   correct span bands, new  radiation correction')
disp('file3 = new       LM : rd = 1e3 = switch to Lor, new Qtips,   correct span bands, orig  radiation correction')

file0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/abs.dat/full/g2v730.mat';
file1 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/abs.dat/full/g2v730.mat';
file2 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/abs.dat/full/g2v730.mat';
file3 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/abs.dat/full/g2v730.mat';

a0 = load(file0);
a1 = load(file1);
a2 = load(file2);
a3 = load(file3);

fr = a0.fr;
a0 = squeeze(a0.k(:,:,6));
a1 = squeeze(a1.k(:,:,6));
a2 = squeeze(a2.k(:,:,6));
a3 = squeeze(a3.k(:,:,6));

%figure(1); semilogy(fr,a1./a0,'b',fr,a2./a1,'r')
%figure(2); semilogy(fr,a2./a1,'b',fr,a3./a1,'r')
%figure(3); semilogy(fr,a1(:,ix)./a0(:,ix),'b',fr,a2(:,ix)./a1(:,ix),'g',fr,a3(:,ix)./a1(:,ix),'r')

figure(1); semilogy(fr,a1(:,ix)./a0(:,ix),'b.-',fr,a2(:,ix)./a0(:,ix),'g',fr,a3(:,ix)./a0(:,ix),'r')
  hl = legend('a1/a0','a2/a0','a3/a0','location','best'); ylabel('raw ratio aN/a0')

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2); semilogy(fr,a2(:,ix)./a1(:,ix),'bx-',fr,a2(:,ix)./a0(:,ix),'g',fr,a3(:,ix)./a0(:,ix),'r')
  hl = legend('a2/a1','a2/a0','a3/a0','location','best'); ylabel('raw ratio ai/aj')
  
figure(3); semilogy(fr,a3(:,ix+20)./a0(:,ix+20),'bx-',fr,a3(:,ix+10)./a0(:,ix+10),'g',fr,a3(:,ix)./a0(:,ix),'r')
  ylabel('raw ratio a3/a0 various layers')
disp('ret'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/kcomp/full/cg2v730.mat';
file1 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed1/kcomp/full/cg2v730.mat';
file2 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed2/kcomp/full/cg2v730.mat';
file3 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm_fixed3/kcomp/full/cg2v730.mat';

xa0 = load(file0);
xa1 = load(file1);
xa2 = load(file2);
xa3 = load(file3);

fr = xa0.fr;
xa0 = xa0.B * squeeze(xa0.kcomp(:,:,6)); xa0 = xa0.^4;
xa1 = xa1.B * squeeze(xa1.kcomp(:,:,6)); xa1 = xa1.^4;
xa2 = xa2.B * squeeze(xa2.kcomp(:,:,6)); xa2 = xa2.^4;
xa3 = xa3.B * squeeze(xa3.kcomp(:,:,6)); xa3 = xa3.^4;

%figure(1); semilogy(fr,xa1./xa0,'b',fr,xa2./xa1,'r')
%figure(2); semilogy(fr,xa2./xa1,'b',fr,xa3./xa1,'r')
%figure(3); semilogy(fr,xa1(:,ix)./xa0(:,ix),'b',fr,xa2(:,ix)./xa1(:,ix),'g',fr,xa3(:,ix)./xa1(:,ix),'r')
figure(2); semilogy(fr,xa1(:,ix)./xa0(:,ix),'b',fr,xa2(:,ix)./xa0(:,ix),'gx-',fr,xa3(:,ix)./xa0(:,ix),'r')
  hl = legend('xa1/xa0','xa2/xa0','xa3/xa0','location','best'); ylabel('uncompr ratio xaN/xa0')
  
figure(3); semilogy(fr,xa0(:,ix)./a0(:,ix),'b',fr,xa1(:,ix)./a1(:,ix),'gx-',fr,xa2(:,ix)./a2(:,ix),'r',...
                    fr,xa3(:,ix)./a3(:,ix),'k')
  hl = legend('xa0/xa0','xa1/a1','xa2/a2','xa3/a3','location','best'); ylabel('uncompr/raw ratio xaN/aN')
  
disp('ret'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file0 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/lblrtm12.8/all/abs.dat/g2v730.mat';
file1 = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/lblrtm12.8/all/kcomp/cg2v730.mat';

ya0 = load(file0);   ya0 = squeeze(ya0.k(:,:,6));
ya1 = load(file1);   ya1 = ya1.B * squeeze(ya1.kcomp(:,:,6)); ya1 = ya1.^4;

figure(4); clf; semilogy(fr,ya1(:,ix)./ya0(:,ix)); title('lblrtm12.8 uncompr/raw')