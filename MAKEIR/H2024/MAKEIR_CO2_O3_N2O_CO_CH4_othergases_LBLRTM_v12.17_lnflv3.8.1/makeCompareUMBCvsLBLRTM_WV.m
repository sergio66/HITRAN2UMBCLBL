clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('see /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LNFL2.6/aer_v_3.2/line_files_By_Molecule/01_H2O/Readme')
%{
>>> disp('qtips04.m : for water the isotopes are 161  181  171  162  182  172');

lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl

originally
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O

now
lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O_use_this_for_all

ie (a) have moved 01_H2O to 01_H2O_use_this_for_all
   (b) currently symbolically link          01_H2O  to  01_h2o_162_excl         which is everything but the HDO (isotope 4) database  (gas 1)
   (c) after this is done symbolically link 01_H2O  to  01_h2o_162_only         which is ONLY the HDO isotope                         (gas 103)
   (d) after this is done symbolically link 01_H2O  to  01_H2O_use_this_for_all which is default                                      (gas 110)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gid = 1;
iShowLay = 20;
iShowLay = 10;

wALL = (1:89*10000); wALL = (wALL-1)*0.0025 + 605;

poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

%% this is offset x1
odALL_L = [];
odALL_U = [];

%% this is offset x10
odALL_L10 = [];
odALL_U10 = [];

v = 605 : 25 : 2805;

%%% gg = input('enter gid to look at (-1 to stop) : ');
%clust_runXtopts_checkgasN
%gg = Sgid;

gg = 1;

while gg > 0
  gstr = num2str(gg);
  odL = [];
  odU = [];

  odL10 = [];
  odU10 = [];

  for vstep = 1 : length(v)
    fileL = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/lblrtm2/stdH2O' num2str(v(vstep)) '_' gstr '_6_2.mat'];
    if exist(fileL)
       fprintf(1,' LBLx1 v %4i gid %2i \n',v(vstep),gg);
       thedir = dir(fileL);
       if thedir.bytes > 0
         loader = ['lbl = load(''' fileL ''');'];
         eval(loader);
         odL = [odL lbl.d(:,iShowLay)'];
      else
        odL = [odL zeros(1,10000)];
      end
    else
      odL = [odL zeros(1,10000)];
    end

    fileU = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/stdH2O' num2str(v(vstep)) '_' gstr '_6_2.mat'];
    if exist(fileU)
       fprintf(1,' UMBCx1 v %4i gid %2i \n',v(vstep),gg);
       thedir = dir(fileU);
       if thedir.bytes > 0       
         loader = ['umbc = load(''' fileU ''');'];
         eval(loader);
         odU = [odU umbc.d(iShowLay,:)];
      else
        odU = [odU zeros(1,10000)];
      end	 
    else
      odU = [odU zeros(1,10000)];
    end

    fileL = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' gstr '.dat/lblrtm2/stdH2O' num2str(v(vstep)) '_' gstr '_6_5.mat'];
    if exist(fileL)
       fprintf(1,' LBLx10 v %4i gid %2i \n',v(vstep),gg);
       thedir = dir(fileL);
       if thedir.bytes > 0
         loader = ['lbl = load(''' fileL ''');'];
         eval(loader);
         odL10 = [odL10 lbl.d(:,iShowLay)'];
      else
        odL10 = [odL10 zeros(1,10000)];
      end
    else
      odL10 = [odL10 zeros(1,10000)];
    end

    fileU = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g110.dat/stdH2O' num2str(v(vstep)) '_' gstr '_6_5.mat'];
    if exist(fileU)
       fprintf(1,' UMBCx10 v %4i gid %2i \n',v(vstep),gg);
       thedir = dir(fileU);
       if thedir.bytes > 0       
         loader = ['umbc = load(''' fileU ''');'];
         eval(loader);
         odU10 = [odU10 umbc.d(iShowLay,:)];
      else
        odU10 = [odU10 zeros(1,10000)];
      end	 
    else
      odU = [odU zeros(1,10000)];
    end

  end
  
  figure(1); semilogy(wALL,odU,wALL,odL); title(num2str(gg)); ylabel('(b) umbc (r) lbl')
  figure(2); plot(wALL,odU./(odL+1e-15)); title(num2str(gg));  ax = axis; axis([ax(1) ax(2) 0 2]); ylabel('UMBC/LBL')

  if exist('wall') & exist('dall')
    figure(3); clf; semilogy(wall,dall,'k',wALL,odU,'r',wALL,odL,'b'); title([num2str(gid) ' : from 500 cm-1 chunks'])
    hl = legend('500 cm-1 chunks','UMBC','try LBLRTM','location','south'); set(hl,'fontsize',10)
  end

  figure(4); semilogy(wALL,odU10,wALL,odL10); title(num2str(gg)); ylabel('offset10 (b) umbc (r) lbl')
  figure(5); plot(wALL,odU10./(odL10+1e-15)); title(num2str(gg));  ax = axis; axis([ax(1) ax(2) 0 2]); ylabel('UMBC/LBL offset 10')

  figure(6); plot(wALL,odU./(odU10+1e-15),'b',wALL,odL./(odL10+1e-15)+0.5,'r',wALL,odU./(odL+1e-15)-0.5,'k')
    title(num2str(gg));  ax = axis; axis([ax(1) ax(2) 0 2]); ylabel('x1/x10 (b) umc (r) lbl')

  figure(7); plot(wALL,odU./(odU10+1e-15),'b',wALL,odL./(odL10+1e-15)+0.5,'r',wALL,odU./(odL+1e-15)-0.5,'k')
    title(num2str(gg));  ax = axis; axis([1450 1500  0.25 1.75]); ylabel('x1/x10 (b) umc (r) lbl amd UMBC/LBL for x1')
    
  gg = -1;
  
end

