function fname = make_fstd_ip_funnel(dirout0,solzen,ppp,i363,iVers)

xstartup

%%% ppp = 1 : 11 for Toffset = -50 -40 ... +40 +50
%% this code takes the rtp US Standard profile (with Toffset) upto 80 km; see
%%   NLTEProfs/make_toffsets_USSTD.m
%%
%% and outputs a text file ['std_gasID_2_' num2str(solzen) '_' num2str(ppp) '.ip']
%% which has the US Std profile (with Toffset) upto 120 km (2.5e-5 mb) 
%%
%% this code is called by g2_forwards_runXtopts_savegasX.m

if i363 < 0
  dirout = [dirout0 '/' num2str(solzen) '/'];
  actualprof = [dirout0 '/IPFILES/toffset_' num2str(solzen) '_USSTD.op.rtp'];
else
  dirout = [dirout0 '/' num2str(solzen) '_363ppm/'];
  actualprof = [dirout0 '/IPFILES/toffset_' num2str(solzen) '_USSTD_363.op.rtp'];
end

default = load('/asl/data/kcarta/KCARTADATA/NLTE/UA/std_gasID_2.ip');
[h,ha,p,pa] = oldrtpread(actualprof);

[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY] = layers2ppmv(h,p,ppp,2);
plot(ppmvMAX,'o-'); title('in make-fstd-ip : max CO2 ppmv')

new = default;

%whos ppm* pavg*

boo = min(pavgLAY); booI = find(pavgLAY == boo,1);
ind = find(default(:,2)*100 < boo,1);
lalaP = [pavgLAY; default(ind,2)*100];

%%%%%%%%%%%%%%%%%%%%%%%%%
%% now we need to join up the ppmv smoothly
papaP = interp1(log(default(:,2)*100),default(:,4),log(lalaP),[],'extrap');
ppmvoffset = ppmvLAY(booI) - default(ind,4);
ppmvoffset = ppmvLAY(booI) - papaP(booI);
new(:,4) = new(:,4) + ppmvoffset; new(:,4) = max(0,new(:,4));

figure(1); clf
semilogy(ppmvLAY,pavgLAY,'o-',default(:,4),default(:,2)*100,'rs-',...
         new(:,4),new(:,2)*100,'ko-'); grid
hl = legend('actual profile','std profile','new profile');
set(hl,'fontsize',10)
set(gca,'ydir','reverse')

%%%%%%%%%%%%%%%%%%%%%%%%%
%% now we need to join up the temps smoothly
papaT = interp1(log(default(:,2)*100),default(:,3),log(lalaP),[],'extrap');
toffset = tavgLAY(booI) - default(ind,3);
toffset = tavgLAY(booI) - papaT(booI);
new(:,3) = new(:,3) + toffset; new(:,3) = max(0,new(:,3));

figure(2); clf
semilogy(tavgLAY,pavgLAY,'o-',default(:,3),default(:,2)*100,'rs-',...
         new(:,3),new(:,2)*100,'ko-'); grid
hl = legend('actual profile','std profile','new profile');
set(hl,'fontsize',10)
set(gca,'ydir','reverse')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fname = [dirout 'std_gasID_2_' num2str(solzen) '_' num2str(ppp) '.ip'];
fid   = fopen(fname,'w');
fprintf(fid,'%8.5e   %8.5e  %8.5f  %8.5e  %8.5e \n',new');
fclose(fid);

