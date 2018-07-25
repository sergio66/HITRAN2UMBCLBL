addpath /home/sergio/HITRAN2UMBCLBL/FORTRAN/for2mat
addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE

iWhichDir = input('Enter run8 using (0) rather incorrect LM lineparams (+1) slightly bad LM line params (-1) H2016 line params or (+2) good LM params : ');
if iWhichDir == 2
  %% hopefully this one has the broadenings done correctly while writing out the g2 file
  %% which was done using SUBR read_parse_file_march20 in rewrite_g2.m
  %% /asl/data/hitran/h16.by.gas/g2.dat -> /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_Mar20_10.43am
  umbcdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8/';
  str = ['UMBC uses swapped LM database (try 3, March 20)'];
elseif iWhichDir == 1
  %% hopefully this one has the broadenings done correctly while writing out the g2 file, still small problems
  %% which was done using SUBR read_parse_file_march19 in rewrite_g2.m
  %% /asl/data/hitran/h16.by.gas/g2.dat -> /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_Mar19_22.29pm  
  umbcdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_Mar19lm2/';
  str = ['UMBC uses swapped LM database (try 2, March 19)'];  
elseif iWhichDir == 0
  %% this one messed up the broadenings while writing out the g2 file
  %% basically used /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_Mar19_03.31am
  %% which was done using SUBR read_parse_file_march18 in rewrite_g2.m
  %% /asl/data/hitran/h16.by.gas/g2.dat -> /asl/data/hitran/H2016/LineMix/new_lm_g2.dat_Mar19_03.31am    
  umbcdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_oopsFirstTryRewriteG2/';
  str = ['UMBC uses swapped LM database (try 1, March 18)'];  
elseif iWhichDir == -1
  umbcdir = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params/';
  str = ['UMBC uses HITRAN database'];
end

%outputdir
%lmdir = output_dir0;
%lmdir = output_dir5;
iWhichLMDir = input('Enter LM dir (-9999) GARBAGE LM using 0005 cm-1 boxcar, WV broad = 0,1 (-1) LM using 0025 cm-1 (+1) LM using 0005 cm-1 boxcar : ');
if iWhichLMDir == -1
  lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/';                    %% 385 ppm
elseif iWhichLMDir == +1
  lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox/';              %% 385 ppm
elseif iWhichLMDir == -9999
  lmdir   = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_noWVbroad/';    %% 385 ppm
end  

wall     = [];
umbcall  = [];
lmall    = [];
rad_umbc = [];
rad_lm   = [];

toffset = 11;
toffset = input('enter toffset 1..11 : ');

Stoffset = toffset;
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres;
  pco2 = refpro.gpart(:,2);
  layT = refpro.mtemp + (Stoffset-6)*10;
  qamt = refpro.gamnt(:,2);

lay = input('enter layer 1..100 : ');

%iShape = input('for LM ods enter (-1) voigt (0) first (+1) full : ');
iShape = -1;

fStart = 1355; fStop = 1405;
fx = input('Enter [fStart fStop] : ');
fStart = fx(1); fStop = fx(2);

for ii = fStart : 25 : fStop
  fname = [lmdir '/std' num2str(ii) '_2_' num2str(toffset) '.mat'];  
  lm = load(fname);
  if iShape == -1
    d = lm.dvoigt(lay,:);
    dx = lm.dvoigt;
  elseif iShape == 0
    d = lm.dfirst(lay,:);
    dx = lm.dfirst;
  elseif iShape == +1
    d = lm.dfull(lay,:);
    dx = lm.dfull;
  end
  d = max(d,0);
  wall = [wall;  lm.w];
  lmall = [lmall d];
  
  rad = ttorad(lm.w,(layT(3)+layT(4))/2)';
  for ll = 4 : 100
    od = dx(ll,:);
    tau = exp(-od/cos(22*pi/180));
    rad = rad.*tau + ttorad(lm.w,layT(ll))'.*(1-tau);
  end
  rad_lm = [rad_lm rad];  
fprintf(1,'%5i rad_lm \n',floor(lm.w(1)))
  %%%%%%%%%%%%%%%%%%%%%%%%%
  
  fnameU = [umbcdir '/std' num2str(ii) '_2_' num2str(toffset) '.mat'];  
  lm = load(fnameU);
  dx = lm.d;  
  d = lm.d(lay,:);
  umbcall = [umbcall d];

  rad = ttorad(lm.w,(layT(3)+layT(4))/2);
  for ll = 4 : 100 
    od = dx(ll,:);
    tau = exp(-od/cos(22*pi/180));
    rad = rad.*tau + ttorad(lm.w,layT(ll)).*(1-tau);
  end
  rad_umbc = [rad_umbc rad];  
fprintf(1,'%5i rad_umbc \n',floor(lm.w(1)))
  %%%%%%%%%%%%%%%%%%%%%%%%%
  
  figure(1); plot(wall,umbcall,'b',wall,lmall,'r','linewidth',2); ylabel('OD');
    hl = legend('UMBC','HITRAN16 LM'); set(hl,'fontsize',10); title(str);
  figure(2); semilogy(wall,umbcall,'b',wall,lmall,'r','linewidth',2); ylabel('OD');
    hl = legend('UMBC','HITRAN16 LM'); set(hl,'fontsize',10); title(str);
  figure(6); plot(wall,rad2bt(wall,rad_lm)-rad2bt(wall,rad_umbc));
    title(str); xlabel('Wavenumber cm-1'); ylabel('\delta BT(K) LM-UMBC'); grid
  
  pause(0.1)
end

figure(3); plot(wall,umbcall./lmall,'r','linewidth',2)
axis([min(wall) max(wall) 0.5 1.5]); grid
hl = legend('UMBC/LM'); set(hl,'fontsize',10); ylabel('OD ratio')
title(str)

figure(4); plot(wall,exp(-umbcall),'b',wall,exp(-lmall),'r','linewidth',2); grid
hl = legend('UMBC','HITRAN16 LM'); set(hl,'fontsize',10); ylabel('transmission')
title(str)

figure(5); plot(wall,exp(-umbcall)-exp(-lmall),'r','linewidth',2); grid
hl = legend('UMBC - LMALL'); set(hl,'fontsize',10); ylabel('transmission diff')
title(str)

[fc,qc] = quickconvolve(wall,[rad_umbc; rad_lm],0.5,0.5);
figure(6); plot(fc,rad2bt(fc,qc(:,2))-rad2bt(fc,qc(:,1)));
    title(str); xlabel('Wavenumber cm-1'); ylabel('\delta BT(K) LM-UMBC'); grid