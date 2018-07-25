function notdone = loop_gas_done_already(iaGasList);

%% can be sped up by sending in iaGasList, but
%%    warning crashes if iaGasList is sent in (as I have not tweaked the plots)

notdone = [];

if nargin < 1
  iaGasList = 1 : 42;
end

figure(1)
ee = exist('loop_gas_done_already.mat');
if ee > 0
  load loop_gas_done_already.mat
  old_alldone  = alldone;
  old_fracdone = fracdone;
  old_iaGasID  = iaGasID;
  clear fracdone iaGasID alldone;
else
  old_alldone  = 0;
  old_fracdone = 0;
  old_iaGasID  = 1;
end

alldone = [];
iCnt = 0;
maxgasID = 42;
for iii = 1 : length(iaGasList)
  ii = iaGasList(iii);
  [freqchunk, numchunk, nn, yesno, lastday] = gas_done_already(ii);
  iCnt = iCnt + 1;
  iaGasID(iCnt) = ii;
  if nn > 0
    disp(' ')
    disp(' ')
    iBad = find(yesno < 0);
    thelastday(ii) = lastday;
    if length(iBad) > 0
      alldone(iCnt) = -1;
      if ii > 1
        fracdone(iCnt) = sum(numchunk)/11/length(freqchunk);
      else
        fracdone(iCnt) = sum(numchunk)/55/length(freqchunk);
      end
    else
      alldone(iCnt) = +1;
      fracdone(iCnt) = +1;
    end
    disp('**************************************************************')
    disp('ret to continue : '); pause(1)
  else
    fprintf(1,'\n gas %3i has no lines in this band .. continue \n',ii);
    disp(' ')
    disp(' ')
    alldone(iCnt) = 1;
    fracdone(iCnt) = +1;
    thelastday(iCnt) = NaN;
    disp('**************************************************************')
  end
end

save  loop_gas_done_already.mat iaGasID fracdone alldone thelastday

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
plot(iaGasID,fracdone,'ro',old_iaGasID,old_fracdone,'bx'); 
grid; xlabel('GasID'); ylabel('OK/Bad')
axis([min(iaGasID)-1 max(iaGasID)+1 -0.1 +1.1]);

iNotDone = find(fracdone < 1);
if length(iNotDone) > 0
  disp('following gases not yet finished ....')
  iaGasID(iNotDone)'
  notdone = iaGasID(iNotDone);
end

figure(2);
dmax = 0.5;
ponk = find(isfinite(thelastday));
scatter(iaGasID(ponk),now-thelastday(ponk),30,fracdone(ponk),'filled'); 
axis([1 max(iaGasID) 0 dmax])
colorbar; grid; xlabel('GasID'); ylabel('Days')
title('Days since last file made');
text(42,dmax+0.5,'frac done')

colormap('default');
kala = colormap; kala = kala(27:64,:); kala = flipud(kala);
caxis([0 1]); colormap(kala);     

iOldNotDone = find(old_fracdone < 1);
if length(setdiff(iOldNotDone,iNotDone)) > 0
  disp('following gases JUST finished ....')
  iaGasID(setdiff(iOldNotDone,iNotDone))'
  figure(1); hold on
    junk = setdiff(iOldNotDone,iNotDone);
    plot(iaGasID(junk),fracdone(junk),'ro','Markersize',4,'Linewidth',5)
  figure(1); hold off
end
