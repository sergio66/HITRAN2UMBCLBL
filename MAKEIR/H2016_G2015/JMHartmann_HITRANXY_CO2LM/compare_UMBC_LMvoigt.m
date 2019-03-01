addpath /home/sergio/KCARTA/MATLAB

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat
Tz = refpro.mtemp;

iChunk = input('enter chunk : ');
outputdir

sf = input('enter scale factor to multiply UMBC ods by : [400/385 = 1.0390] ');

lm = [output_dirRUN8 '/std' num2str(iChunk) '_2_6.mat'];
lm = [output_dir5    '/std' num2str(iChunk) '_2_6.mat'];
new = load(lm);
new = new.dvoigt';

% more  ../MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/freq_boundaries.m
gid = 2;
%% (A) should be same as (C), modulo 400/385
iVers = 1;  
iVers = 5;
iVers = 6;
if iVers == 1
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_385ppm/'];       %% (A) this should be raw run8 with HITRAN2016
elseif iVers == 2  
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_385ppm/'];                   %% (B) just checking to see if they have really changed the params ...
elseif iVers == 3  
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_400ppm_Oct06_2018/'];        %% (C) this is the version of line params Iouli gave me in 08/2016 .. so should be same as "new"
elseif iVers == 4  
  %% dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_400ppm_Oct07_2018_tsp0/'];   %% (D) this is the version of line params Iouli gave me in 08/2016 .. so should be same as "new" esp since now I turned off prressure shift
elseif iVers == 5  
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0/'];  %% (D) this is raw run8 with HITRAN2016 ... but tsp = 0 ... hopefully closer match to "new" since now I turned off pressure shift
elseif iVers == 6  
  dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix/'];  %% (E) this is raw run8 with HITRAN2016 ... but tsp = 0, self braod T dep fixed ... hopefully closer match to "new" 
end  
fprintf(1,'for run8 using %s \n',dirout);
lblrtm = [dirout '/std' num2str(iChunk) '_2_6.mat'];
old = load(lblrtm);
w = old.w;
old = old.d' * sf;

tsurf = Tz(1)+1;
rnew =  ttorad(w,tsurf)';
rold =  ttorad(w,tsurf)';
for ii = 1 : 100
  k = old(:,ii); rold = rold.*exp(-k) + ttorad(w,Tz(ii))'.*(1-exp(-k));
  k = new(:,ii); rnew = rnew.*exp(-k) + ttorad(w,Tz(ii))'.*(1-exp(-k));    
end
  
addpath /home/sergio/MATLABCODE
[fc,qc] = quickconvolve(w,[rold rnew],0.5,0.5); tc = rad2bt(fc,qc);
figure(1); plot(w,rad2bt(w,rold),'b',w,rad2bt(w,rnew),'r'); title('BT TOA (b)UMBC (r)LM HITRAN voigt');
figure(2); plot(w,rad2bt(w,rnew)-rad2bt(w,rold),'r',fc,tc(:,2)-tc(:,1),'k'); title('BT TOA LMVoigt-UMBC')
figure(3); plot(w,new./old); title('LMHitranVoigt/UMBCVoigt')
figure(4); dn = 0.95 : 0.001 : 1.05;;plot(dn,hist(new(:)./old(:),dn)); grid; title('hist LMHitranVoigt/UMBC')
figure(5); semilogy(w,new(:,10),w,old(:,10)); title('(b)LMHitranVoigt (r) UMBC')
figure(5); plot(w,new(:,10)-old(:,10)); title('LMVHitranoigt - UMBC')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
layT = refpro.mtemp;
for ii = 1 : 100
  od = old(:,ii);
  boo1 = find(od == min(od),1);
  boo2 = find(od == max(od),1);  
  odmin_old(ii) = od(boo1);
  odmax_old(ii) = od(boo2);  
  od = new(:,ii);
  odmin_new(ii) = od(boo1);
  odmax_new(ii) = od(boo2);  
end
figure(6); plot(layT,odmin_new./odmin_old,'b',layT,odmax_new./odmax_old,'r'); xlabel('T'); ylabel('LM/UMBC (b) minOD (r) maxOD')
figure(7); plot(odmin_new./odmin_old,1:100,'b',odmax_new./odmax_old,1:100,'r'); ylabel('lay'); xlabel('LM/UMBC (b) minOD (r) maxOD')
disp('ret to continue1 '); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_385ppm/'];  %% this should be raw run8 with HITRAN2016
junk   = [dirout '/std' num2str(iChunk) '_2_6.mat'];
sf = 400/385;
H2016forsure = load(junk);
H2016forsure = H2016forsure.d' * sf;
figure(6); plot(w,H2016forsure./old);
figure(6); plot(w,H2016forsure(:,10),w,old(:,10));
figure(6); semilogy(w,H2016forsure(:,10),w,old(:,10));
figure(7); dn = 0.95 : 0.001 : 1.05;;plot(dn,hist(H2016forsure(:)./old(:),dn)); grid
disp('ret to continue2 '); pause

addpath /home/sergio/SPECTRA
%%% [iYes1,line1,iYes2,line2] = findlines_plot_compareHITRANx_lm2016_vs_2016(wv1,wv2,gid,HITRAN1,HITRAN2);
%[iYes16,line16,iYesJunk,LMold] = findlines_plot_compareHITRANx_lm2016_vs_2016(500,3000,2,2016,2017);
%disp('ret to continue : '); pause
%[iYes16,line16,iYesJunk,LMnew] = findlines_plot_compareHITRANx_lm2016_vs_2016(500,3000,2,2016,2018);
%disp('ret to continue : '); pause

cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = load(['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_400ppm_Oct06_2018//std' num2str(iChunk) '_2_6.mat']);
b = load(['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0//std' num2str(iChunk) '_2_6.mat']);   %%% this should closely duplicate "new"
c = load(['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_385ppm/std' num2str(iChunk) '_2_6.mat']);
figure(7)
plot(a.w,a.d(10,:)./b.d(10,:))
plot(a.w,a.d(10,:)./b.d(10,:))
plot(a.w,c.d(10,:)./b.d(10,:)*400/385)
plot(a.w,a.d(10,:)./b.d(10,:))
plot(a.w,c.d(10,:)./b.d(10,:)*400/385,'bo-',a.w,a.d(10,:)./b.d(10,:),'k',a.w,new(:,10)'./b.d(10,:),'r')
plot(a.w,c.d(10,:)-b.d(10,:)*400/385,'bo-',a.w,a.d(10,:)-b.d(10,:),'k',a.w,new(:,10)'-b.d(10,:),'r')
