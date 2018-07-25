%{
Chunk =    2630.000      numgases =           18  gasIDs are ....
              1           2           3           4           6           8
	                 9          11          13          14          15          16
			           17          20          22          24          26          31
%}

figure(1); clf
figure(1); set(gca,'fontsize',10)
figure(1); 

w1 = 2630; w2 = 2655;
iaList = [1 2 3 4 6 8 9 11 13 14 15 16 17 20 22 24 26 31];
for ii = 1 : length(iaList)
  [iYes,lines] = findlines_plot(w1-25,w2+25,iaList(ii));
  [iYesL,linesL] = read_LBLRTM_LNFL(w1-25,w2+25,iaList(ii));
  semilogy(lines.wnum,lines.stren,'bx',linesL.wnum,linesL.stren,'r.'); title([num2str(iaList(ii)) ' (b) HITRAN (r) LBLRTM lines'])
set(gca,'fontsize',10)
set(gca,'fontsize',10)
  ax = axis; axis([2630-25 2630+25 ax(3) ax(4)]); grid
  pause
end
				