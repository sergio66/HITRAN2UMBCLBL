function [geisak,hitrank] = compareG2015_H2016(gasID,chunk,Toffset,Poffset);

%% recall for all gases there are 11 toffsets, number 6 = US Std
%% recall for WV        there are  5 poffsets, number 2 = US Std

if nargin == 2
  Toffset = 6;
  Poffset = 2;
elseif nargin == 3
  Poffset = 2;
end

%junk = input('Enter [gasID chunk] to compare : ')
%gasID = junk(1);
%chunk = junk(2);

if gasID ~= 1 & gasID ~= 103
  gname =  ['/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/kcomp/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
  hname =  ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/kcomp/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
elseif gasID == 1
  gname =  ['/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/g1.dat/kcomp.h2o/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
  hname =  ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat/kcomp.h2o/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
elseif gasID == 103
  gname =  ['/asl/s1/sergio/G2015_RUN8_NIRDATABASE/IR_605_2830/g103.dat/kcomp.h2o/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
  hname =  ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g103.dat/kcomp.h2o/cg' num2str(gasID) 'v' num2str(chunk) '.mat'];
end

if ~exist(gname)
  fprintf(1,'GEISA 2015 %s DNE \n',gname);
  geisak = zeros(10000,100);
  freq = 1:10000;
  freq = chunk + (freq-1)*0.0025;
else
  geisa = load(gname);
  if gasID > 1 & gasID < 101
    geisak = (geisa.B *squeeze(geisa.kcomp(:,:,Toffset))).^4;
  else
    geisak = (geisa.B *squeeze(geisa.kcomp(:,:,Toffset,Poffset))).^4;
  end
  freq  = geisa.fr;  
end  
  
if ~exist(hname)
  fprintf(1,'HITRAN 2015 %s DNE \n',gname);
  hitrank = zeros(10000,100);
  freq = 1:10000;
  freq = chunk + (freq-1)*0.0025;
else
  hitran = load(hname);
  if gasID > 1 & gasID < 101
    hitrank = (hitran.B *squeeze(hitran.kcomp(:,:,Toffset))).^4;
  else
    hitrank = (hitran.B *squeeze(hitran.kcomp(:,:,Toffset,Poffset))).^4;
  end
  freq  = hitran.fr;    
end

%{
oo1 = find(isnan(geisak(:))); 
oo2 = find(isnan(hitrank(:)));
oo3 = find(isinf(geisak(:))); 
oo4 = find(isinf(hitrank(:)));
whos oo*
%}

figure(1); semilogy(freq,sum(geisak,2),'b.-',freq,sum(hitrank,2),'r');
  hl = legend('GEISA','HITRAN','location','best');
  
figure(2); plot(freq,sum(geisak,2)./sum(hitrank,2)); axis([freq(1) freq(end) 0.75 1.25])
figure(3); pcolor(freq,1:100,geisak'./hitrank'); shading flat; caxis([0.75 1.25]); colorbar
addpath /home/sergio/MATLABCODE/COLORMAP/; colormap(usa2)

for ii = 1 : 3
  figure(ii); title(['gid = ' num2str(gasID)])
end  