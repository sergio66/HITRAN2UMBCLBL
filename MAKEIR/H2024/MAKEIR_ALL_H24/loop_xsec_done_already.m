clear all
iKeepEmpty = input('keep empty files? (+1 yes -1 no, remove them) : ');
if iKeepEmpty < 0
  iKeepEmpty = input('just checking keep empty files? (+1 yes -1 no, remove them) : ');
end

if iKeepEmpty < 0
  disp('WARNING : rming empty files!!! ');
  disp('ret to continue'); pause
end

Sallremain = [];
gidlist = 51 : 81;
for gidxx = 1 : length(gidlist)
  gid = gidlist(gidxx);

  [freqchunk, numchunk, iCnt(gid), iDone(gid), Sremain] = xsec_done_already(gid,iKeepEmpty);
  Sallremain = [Sallremain Sremain];  
  %disp('ret to continue : '); pause

  figure(3);
  plot(1:gid,iCnt,'bo-',1:gid,iDone,'rx-'); 
    xlabel('GasID'); ylabel('Number chunks needed/done'); grid on
  ax = axis;    
  axis([50 gid+1  ax(3) ax(4)])

  pause(0.1);
end

figure(3);
plot(gidlist,iCnt(gidlist),'bo-',gidlist,iDone(gidlist),'rx-'); 
    xlabel('GasID'); ylabel('Number chunks needed/done'); grid on
ax = axis;
axis([50 82 ax(3) ax(4)])

figure(4);
plot(gidlist,iCnt(gidlist) - iDone(gidlist),'rx-'); 
    xlabel('GasID'); ylabel('Number chunks remaining'); grid on
ax = axis;
axis([50 82 ax(3) ax(4)])

if length(Sallremain) > 0
  fid = fopen('gN_ir_xseclistX.txt','w');
  fprintf(1,'ah well still need to make %5i xsec files \n',length(Sallremain))
  for ii = 1 : length(Sallremain)
    fprintf(fid,'%s\n',Sallremain{ii});
  end
  fclose(fid);
end  