iCnt = 0;
prof = load('/home/sergio/SPECTRA/IPFILES/std_co2');
T = prof(:,4);
sec_theta = 1/cos(23.5*pi/180)

for ii = 605 : 2 : 797
  iCnt = iCnt + 1;
  file1 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0002/kcomp//cg2v' num2str(ii) '.mat'];
  file2 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0002/kcomp/nmax=50/cg2v' num2str(ii) '.mat'];

  file0 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0002/abs.dat/g2v' num2str(ii) '.mat']; 
  c0 = load(file0);
  k0 = squeeze(c0.k(:,:,6));

  c1 = load(file1);
  c2 = load(file2);
  fr = c1.fr;

  kcomp = squeeze(c1.kcomp(:,:,6)); k1 = (c1.B*kcomp).^(1/0.25); d1 = c1.d;
  kcomp = squeeze(c2.kcomp(:,:,6)); k2 = (c2.B*kcomp).^(1/0.25); d2 = c2.d;

  %% contant lay
  r0 = simplerad1(fr,sec_theta,T,k0,4);
  r1 = simplerad1(fr,sec_theta,T,k1,4);
  r2 = simplerad1(fr,sec_theta,T,k2,4);

  %% pade approx 2 (two term)
  r0 = simplerad2b(fr,sec_theta,T,k0,4);
  r1 = simplerad2b(fr,sec_theta,T,k1,4);
  r2 = simplerad2b(fr,sec_theta,T,k2,4);

  %% pade approx 1 (one term)
  r0 = simplerad2a(fr,sec_theta,T,k0,4);
  r1 = simplerad2a(fr,sec_theta,T,k1,4);
  r2 = simplerad2a(fr,sec_theta,T,k2,4);

  figure(1); plot(fr,sum(k0'),fr,sum(k1'),fr,sum(k2'));                                 ylabel('Sum(abs)');
  figure(2); plot(fr,sum(k1')./sum(k0'),fr,sum(k2')./sum(k0'));                         ylabel('Ratio of k = abs');
  figure(3); plot(fr,exp(-sum(k1'))./exp(-sum(k0')),fr,exp(-sum(k2'))./exp(-sum(k0'))); ylabel('Ratio of T = trans');
  figure(4); subplot(211); plot(fr,rad2bt(fr,r0),'k',fr,rad2bt(fr,r1),'b',fr,rad2bt(fr,r2),'r')
             subplot(212); plot(fr,rad2bt(fr,r0)-rad2bt(fr,r1),'b',fr,rad2bt(fr,r0)-rad2bt(fr,r2),'r')

  fchunk(iCnt) = fr(1);

  junk = sum(k1')./sum(k0');             maxkratio1(iCnt) = max(junk(:));  d1N(iCnt) = d1;
  junk = exp(-sum(k1'))./exp(-sum(k0')); maxtratio1(iCnt) = max(junk(:));  d2N(iCnt) = d2;
  junk = rad2bt(fr,r0) - rad2bt(fr,r1);  maxBTdiff1(iCnt) = max(abs(junk));
  junk = rad2bt(fr,r0) - rad2bt(fr,r1);  meanBTdiff1(iCnt) = mean(abs(junk));

  junk = sum(k2')./sum(k0');             maxkratio2(iCnt) = max(junk(:));  d1N(iCnt) = d1;
  junk = exp(-sum(k2'))./exp(-sum(k0')); maxtratio2(iCnt) = max(junk(:));  d2N(iCnt) = d2;
  junk = rad2bt(fr,r0) - rad2bt(fr,r2);  maxBTdiff2(iCnt) = max(abs(junk));
  junk = rad2bt(fr,r0) - rad2bt(fr,r2);  meanBTdiff2(iCnt) = mean(abs(junk));

  figure(5); 
    plot(fchunk,maxkratio1,'bo-',fchunk,maxtratio1,'ro-',...
         fchunk,maxkratio2,'cx-',fchunk,maxtratio2,'mx-')
    ylabel('Ratio of K,T'); hl = legend('k1=abs1','T1=trans1','k2=abs2','T2=trans2','location','best');

  figure(6); 
    plot(fchunk,maxBTdiff1,'b',fchunk,meanBTdiff1,'r',fchunk,maxBTdiff2,'c',fchunk,meanBTdiff2,'m')
    ylabel('diff(BT)'); hl = legend('BTdiff1','meanBTdiff1','BTdiff2','meanBTdiff2','location','best');

  figure(7); plot(fchunk,d1N,'bo-',fchunk,d2N,'rx-'); ylabel('N nbasus vectors');

  fprintf(1,'fr(1) d1 d2 = %8.3f %3i %3i \n',fr(1),d1,d2);
  pause(0.1)
  %disp('ret'); pause

end

