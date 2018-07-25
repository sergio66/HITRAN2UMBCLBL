% Load in all the data
load t250.tau;
load t255.tau;
load t260.tau;
load t265.tau;
load t270.tau;
load t275.tau;
load t280.tau;
load t285.tau;
load t290.tau;
load t295.tau;
load t300.tau;
load t305.tau;
load t310.tau;
load t315.tau;
load t320.tau;
load t325.tau;
load t330.tau;
load t335.tau;
load t340.tau;
load t345.tau;
load t350.tau;
%
% Set up the temp and freq arrays
temp=[-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50];
tempmid=[-45, -35, -25, -15, -5, 5, 15, 25, 35, 45];
freq=t250(:,1);
%
% Resort the data to be fit
trans=[t250(:,2), t260(:,2), t270(:,2), t280(:,2), t290(:,2), t300(:,2)];
trans=[trans, t310(:,2), t320(:,2), t330(:,2), t340(:,2), t350(:,2)];
clear t250 t260 t270 t280 t290 t300 t310 t320 t330 t340 t350
%
% Resort the data that will not be fit
transmid=[t255(:,2), t265(:,2), t275(:,2), t285(:,2), t295(:,2)];
transmid=[transmid, t305(:,2), t315(:,2), t325(:,2), t335(:,2), t345(:,2)];
clear t255 t265 t275 t285 t295 t305 t315 t325 t335 t345
%
NPTS=length(freq)
%
% Loop over the points
clear fitmid
I=1;
coef=polyfit(temp, trans(I,:), 5);
fitmid=polyval(coef,tempmid)';
ffreq=freq(1);
J=NPTS/10
for I=2:J
   coef=polyfit(temp, trans(I,:), 4);
   xjunk=polyval(coef,tempmid);
   fitmid=[fitmid, xjunk'];
   ffreq=[ffreq, freq(I)];
end
%
% Show the fitting results
subplot(2,1,1),plot(ffreq(1:J),transmid(1:J,:),'y',ffreq(1:J),fitmid(:,1:J),'r--')
subplot(2,1,2),plot(ffreq(1:J),100*(fitmid(:,1:J)'-transmid(1:J,:))./transmid(1:J,:),'y')
