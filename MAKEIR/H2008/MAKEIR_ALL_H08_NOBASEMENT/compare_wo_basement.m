ff = input('Enter chunk : ');
tt = input('Enter Toffset : ');

f08 = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g3.dat/WOBASEMENT/wobasement_std' num2str(ff) '_3_' num2str(tt) '.mat'];
f12 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/WOBASEMENT/wobasement_std' num2str(ff) '_3_' num2str(tt) '.mat'];
fCORRECT = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/std' num2str(ff) '_3_' num2str(tt) '.mat'];
f12LBL = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g3.dat/lblrtm2/std' num2str(ff) '_3_' num2str(tt) '.mat'];

loader = ['d08 = load(''' f08 ''');']; eval(loader)
loader = ['d12 = load(''' f12 ''');']; eval(loader)
loader = ['d12LBL = load(''' f12LBL ''');']; eval(loader)
loader = ['dCORRECT = load(''' fCORRECT ''');']; eval(loader)

figure(1); plot(d08.w,d12.d ./ d08.d);      title('no basement UMBC H12/H08')
figure(1); plot(d08.w,d12.d ./ dCORRECT.d); title('UMBC H12/H12 CORRECT')
figure(2); plot(d08.w,d12.d ./ d12LBL.d');  title('no basement UMBC H12/ LBL H12')

ratio = 0.5 : 0.002 : 1.5; rara = d12.d ./ d12LBL.d'; rara = rara(:);
figure(3); semilogy(ratio,histc(rara,ratio)); title('histc : UMBC H12/ LBL H12')

figure(4);
for ii =  1: 100
  plot(d08.w,d12.d(ii,:) ./ d12LBL.d(:,ii)');  title(num2str(ii)); pause(0.1); 
end

figure(5); ii = 80;
  semilogy(d08.w,d12.d(ii,:) , d08.w, d12LBL.d(:,ii)','r');  title(num2str(ii)); pause(0.1); 