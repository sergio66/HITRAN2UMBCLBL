addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat

boo = input('Enter [gid wavechunk] : ');
dir2016 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(boo(1)) '.dat/'];
dir2016 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/abs.dat/'];
dir2020 = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(boo(1)) '.dat/'];

f2016 = [dir2016 '/std' num2str(boo(2)) '_' num2str(boo(1)) '_6.mat'];
f2016 = [dir2016 '/g' num2str(boo(1)) 'v' num2str(boo(2)) '.mat'];
f2020 = [dir2020 '/std' num2str(boo(2)) '_' num2str(boo(1)) '_6.mat'];

x2016 = load(f2016);
x2020 = load(f2020);

f = x2016.fr;
k2016 = squeeze(x2016.k(:,:,6))';
k2020 = x2020.d;

figure(1); clf; semilogy(f,sum(k2016,1),f,sum(k2020,1)); title([num2str(boo)])
figure(2); clf; plot(f,sum(k2020,1)./sum(k2016,1));  ylabel('k2020/k2016'); title([num2str(boo)])

