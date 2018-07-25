clear all

gid = [[4] [7:29] 31 32];
gid = [[2:29] 31 32];

%wALL = (1:89*10000); wALL = (wALL-1)*0.0025 + 605;
odALL_L = [];
odALL_U = [];

v = 605 : 25 : 2805;

if ~exist('Sgid')
  gg = input('enter gid to look at (-1 to stop) : ');
else
  clust_runXtopts_checkgasN
  gg = Sgid;
end

iV = input('Enter chunk : ');

while gg > 0
  gstr = num2str(gg);
  odL = [];
  odU = [];

  for vstep = iV
    if gg > 1
      fileL = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/lblrtm2/std' num2str(vstep) '_' gstr '_6.mat'];
    else      
      fileL = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/lblrtm2/stdH2O' num2str(vstep) '_' gstr '_6_1.mat'];
    end
    if exist(fileL)
       fprintf(1,' LBL v %4i gid %2i \n',vstep,gg);
       thedir = dir(fileL);
       if thedir.bytes > 0
         loader = ['lbl = load(''' fileL ''');'];
         eval(loader);
         odL = [sum(lbl.d')];
      else
        odL = [zeros(1,10000)];
      end
    else
      odL = [zeros(1,10000)];
    end

    if gg > 1
      fileU = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/std' num2str(vstep) '_' gstr '_6.mat'];
    else
      fileU = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/stdH2O' num2str(vstep) '_' gstr '_6_1.mat'];
      fileU = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/stdH2O' num2str(vstep) '_' gstr '_6_1.mat'];      
    end
    if exist(fileU)
       fprintf(1,' UMBC v %4i gid %2i \n',vstep,gg);
       thedir = dir(fileU);
       if thedir.bytes > 0       
         loader = ['umbc = load(''' fileU ''');'];
         eval(loader);
         odU = [sum(umbc.d)'];
      else
        odU = [zeros(1,10000)];
      end	 
    else
      odU = [zeros(1,10000)];
    end
  end
  wALL = (1:10000)-1;
  wALL = vstep + wALL * 0.0025;
  
  figure(1); semilogy(wALL,odU,wALL,odL); title(num2str(gg)); ylabel('(b) umbc (r) lbl')
  figure(2); plot(wALL,odU'./(odL+1e-15)); title(num2str(gg));  ax = axis; axis([ax(1) ax(2) 0 2]); ylabel('UMBC/LBL')

  if exist('wall') & exist('dall')
    figure(3); clf; semilogy(wall,dall,'k',wALL,odU,'r',wALL,odL,'b'); title([num2str(gid) ' : from 500 cm-1 chunks'])
      hl = legend('500 cm-1 chunks','UMBC','try LBLRTM','location','south'); set(hl,'fontsize',10)
  end

  if gg <= 40
    figure(5);  
    [iYes,lines] = findlines_plot(vstep-25,vstep+25,gg);
    [iYesL,linesL] = read_LBLRTM_LNFL(vstep-25,vstep+25,gg);
    if gg > 1
      semilogy(lines.wnum,lines.stren,'bo',linesL.wnum,linesL.stren,'r.'); title('HITRAN lines')
    else
      semilogy(lines.wnum,lines.stren,'bx',linesL.wnum,linesL.stren,'r.'); title('HITRAN lines')
    end
    ylabel('(b) HITRAN (r) LNFL')    
  end
			  
  gg = -1;
  
end

%   gg = input('enter gid to look at (-1 to stop) : ');
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
