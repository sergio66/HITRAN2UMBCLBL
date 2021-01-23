iCnt = 0;
prof = load('/home/sergio/SPECTRA/IPFILES/std_co2');
T = prof(:,4);
sec_theta = 1/cos(23.5*pi/180)

for ii = 605 : 2 : 1097
  iCnt = iCnt + 1;
  file1 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0002/kcomp//cg2v' num2str(ii) '.mat'];
  file2 = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm0.0002/kcomp/nmax=50/cg2v' num2str(ii) '.mat'];
  c1 = load(file1);
  c2 = load(file2);
  fr = c1.fr;
  kcomp = squeeze(c1.kcomp(:,:,6)); k1 = c1.B*kcomp; d1 = c1.d;
  kcomp = squeeze(c2.kcomp(:,:,6)); k2 = c2.B*kcomp; d2 = c2.d;

  r1 = ttorad(fr,(T(3)+T(4))/2)'; for jj = 4 : 100; kjunk = k1(:,jj)*sec_theta; tjunk = exp(-kjunk); rjunk = ttorad(fr,T(jj))'; r1 = r1.*tjunk + rjunk.*(1-tjunk); end
  r2 = ttorad(fr,(T(3)+T(4))/2)'; for jj = 4 : 100; kjunk = k2(:,jj)*sec_theta; tjunk = exp(-kjunk); rjunk = ttorad(fr,T(jj))'; r2 = r2.*tjunk + rjunk.*(1-tjunk); end

  figure(1); plot(fr,sum(k1'),fr,sum(k2'));           ylabel('Sum(abs)');
  figure(2); plot(fr,sum(k1')./sum(k2'));             ylabel('Ratio of k = abs');
  figure(3); plot(fr,exp(-sum(k1'))./exp(-sum(k2'))); ylabel('Ratio of T = trans');
  figure(4); subplot(211); plot(fr,rad2bt(fr,r1),'b',fr,rad2bt(fr,r2),'r')
             subplot(212); plot(fr,rad2bt(fr,r1)-rad2bt(fr,r2),'r')

  fchunk(iCnt) = fr(1);
  junk = sum(k1')./sum(k2');             maxkratio(iCnt) = max(junk(:));  d1N(iCnt) = d1;
  junk = exp(-sum(k1'))./exp(-sum(k2')); maxtratio(iCnt) = max(junk(:));  d2N(iCnt) = d2;
  junk = rad2bt(fr,r1) - rad2bt(fr,r2);  maxBTdiff(iCnt) = max(abs(junk));

  figure(5); plot(fchunk,maxkratio,'bo-',fchunk,maxtratio,'rx-',fchunk,maxBTdiff+1); ylabel('Ratio of K,T and diff(BT)'); hl = legend('k=abs','T=trans','BTdiff','location','best');
  figure(6); plot(fchunk,d1N,'bo-',fchunk,d2N,'rx-'); ylabel('N nbasus vectors');

  fprintf(1,'fr(1) d1 d2 = %8.3f %3i %3i \n',fr(1),d1,d2);
  %disp('ret'); pause
  pause(0.1)
end

