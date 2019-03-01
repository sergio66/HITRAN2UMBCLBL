addpath /home/sergio/KCARTA/MATLAB

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat
Tz = refpro.mtemp;

chunk = input('enter chunk : ');
outputdir

lm = [output_dirRUN8 '/std' num2str(chunk) '_2_6.mat'];
lm = [output_dir5    '/std' num2str(chunk) '_2_6.mat'];
new = load(lm);
new = new.dfirst';

% more  ../MAKEIR_CO2_O3_N2O_CO_CH4_othergases_LBLRTM12p8/freq_boundaries.m
gid = 2;
dirout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/lblrtm/'];
lblrtm = [dirout '/std' num2str(chunk) '_2_6.mat'];
old = load(lblrtm);
w = old.w;
old = old.d;

dn = 0 : 0.001 : 2;
plot(dn,hist(new(:)./old(:),dn))

tsurf = Tz(1)+1;
rnew =  ttorad(w,tsurf)';
rold =  ttorad(w,tsurf)';
for ii = 1 : 100
  k = old(:,ii); rold = rold.*exp(-k) + ttorad(w,Tz(ii))'.*(1-exp(-k));
  k = new(:,ii); rnew = rnew.*exp(-k) + ttorad(w,Tz(ii))'.*(1-exp(-k));    
end
figure(1); plot(w,rad2bt(w,rold),'b',w,rad2bt(w,rnew),'r'); title('(b)LBLRTM (r)LM HITRAN');
figure(2); plot(w,rad2bt(w,rold)-rad2bt(w,rnew),'r'); title('LBLRTM - LM')
figure(3); plot(w,new./old); title('LMHitranFirst/LBLRTMFirst')