addpath /home/sergio/KCARTA/MATLAB
iChunk = input('Enter chunk : ');
iToffset = input('Enter Toff (-50 -40 ... +40 +50) : ');
iToffset = (iToffset - -50)/10 + 1;

newname = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/0_LTE/std2205_2_' num2str(iToffset) '.dat'];
[dnew,w] = readkcstd(newname);
w = w(1) + 0.0025 * ((1:length(w))-1);
ix = find(w >= iChunk,1);
ix = ix:ix+9999;
w = w(ix);
dnew = dnew(ix,1:100);

oldname = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/abs.dat/g2v' num2str(iChunk) '.mat'];
old = load(oldname);
dold = squeeze(old.k(:,:,iToffset));

ix = 1:10:100; 
figure(1); plot(w,dold(:,ix)./dnew(:,ix)); axis([min(w) max(w) 0 2])
figure(2); semilogy(w,dold(:,ix),'b',w,dnew(:,ix),'r'); 