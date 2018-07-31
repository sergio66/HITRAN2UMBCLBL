kallG = [];  kallG = zeros(10000*90,100);
kallH = [];  kallH = zeros(10000*90,100);

freq = 1:10000*90;
freq = (freq-1)*0.0025 + 605;

glist = [1 103 3 4 5 6  9 12];
clist = 605 : 25 : 2805;
for vv = 1 : length(clist)
  iaInd = (1: 10000) + (vv-1)*10000;
  for gg = 1 : length(glist)
    [geisak,hitrank] = compareG2015_H2016(glist(gg),clist(vv));
    pause(0.1);
    kallG(iaInd,:) =  kallG(iaInd,:) + geisak;
    kallH(iaInd,:) =  kallH(iaInd,:) + hitrank;    
  end
  figure(4); plot(freq,sum(kallG,2)./sum(kallH,2)); pause(0.1); 
end

profile = load('/home/sergio/SPECTRA/IPFILES/std_co2');
T = profile(:,4); plot(T)

stemp = T(4);
addpath /home/sergio/KCARTA/MATLAB
radH = ttorad(freq,stemp);
radG = ttorad(freq,stemp);
for ii = 4 : 100
  k = kallH(:,ii); trans = exp(-k');
  plnck = ttorad(freq,T(ii));
  radH = radH .* trans + plnck .* (1-trans);

  k = kallG(:,ii); trans = exp(-k');
  plnck = ttorad(freq,T(ii));
  radG = radG .* trans + plnck .* (1-trans);
end

btG = rad2bt(freq,radG); btH = rad2bt(freq,radH);
figure(1); plot(freq,btG,freq,btH);
figure(2); plot(freq,btG - btH);

addpath /home/sergio/MATLABCODE
[fkc,rkc] = convolve_airs(freq,[radG; radH],1:2378); tkc = rad2bt(fkc,rkc); plot(freq,btG - btH,'b',fkc,tkc(:,1)-tkc(:,2),'r');  axis([600 2830 -1 +1])
title('US Std GEISA2015-HITRAN2016')
