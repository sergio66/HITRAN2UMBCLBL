function [fall,odall,odN] = plot_Toffset(gid,Toffset,N,iUsualORHigh)

%% [fall,odall,odN] = plot_Toffset(2,5,3);
%% gid = 2,6,7,22 (typically)
%% Toffset = 1 -- 11
%% N = layer to plot 1--100  in fig 1
  
if nargin == 0
  gid == 2;
  Toffset = 6;
  N = 3;
  iUsualORHigh = 10;  
elseif nargin == 1
  Toffset = 6;
  N = 3;  
  iUsualORHigh = 10;
elseif nargin == 2
  N = 3;  
  iUsualORHigh = 10;
elseif nargin == 3
  iUsualORHigh = 10;
end

fprintf(1,'GasID = %2i   Toffset = %2i of 11   Layer = %3i of 100 \n',gid,Toffset,N);
	
nbox = 5;
pointsPerChunk = 10000;
freq_boundariesLBL

fall = [];
odall = [];
odN   = [];
od1   = [];
od100 = [];

od_all_lays = [];

iCnt = 0;

disp('loading in 89 chunks ....')
for ff = wn1 : 25 : wn2
  iCnt = iCnt + 1;
  if mod(iCnt,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')  
  end
  
  clear x
  
  fname = [dirout '/std' num2str(ff) '_' num2str(gid) '_' num2str(Toffset) '.mat'];
  %fprintf(1,'%s \n',fname);
  if exist(fname)
    thedir = dir(fname);
    if thedir.bytes > 1e5
      x = load(fname);
      w = x.w;
      fall = [fall w];
      od = sum(x.d,2);
      odall = [odall; od];
      odN   = [odN   x.d(:,N)'];
      od1   = [od1   x.d(:,1)'];
      od100 = [od100 x.d(:,100)'];            
      od_all_lays(iCnt,:) = x.d(1,:);
    else
      x.w = (1:10000);
      x.w = (x.w-1)*0.0025 + ff;
      w = x.w;
      fall = [fall w];
      od = zeros(size(x.w));
      odall = [odall; od'];
      odN   = [odN    0*w];
      od1   = [od1    0*w];
      od100 = [od100  0*w];      
      od_all_lays(iCnt,:) = zeros(100,1);
    end      
  else
    x.w = (1:10000);
    x.w = (x.w-1)*0.0025 + ff;
    w = x.w;
    fall = [fall w];
    od = zeros(size(x.w));
    odall = [odall; od'];
    odN   = [odN 0*w];
    od1   = [od1    0*w];
    od100 = [od100  0*w];          
    od_all_lays(iCnt,:) = zeros(100,1);    
  end
  
end

fprintf(1,'\n')


% whos fall odall od_all_lays

figure(1); clf; semilogy(fall,odall,'o-',fall,od1,fall,odN,fall,od100); legend('Sum(OD)','OD(lay1)','OD(layN)','OD(lay100)','location','best');
figure(2); clf; semilogx(od_all_lays,1:100);

junk = ([min(od_all_lays(:)) max(od_all_lays(:)) min(od_all_lays(:,1)) max(od_all_lays(:,1)) min(od_all_lays(:,100)) max(od_all_lays(:,100))]);
fprintf(1,'no log : min(OD) max(OD) min(OD)lay001 max(OD)lay001 min(OD)lay100 max(OD)lay100  %8.4e  %8.4e  %8.4e  %8.4e  %8.4e  %8.4e \n',junk)

junk = log10([min(od_all_lays(:)) max(od_all_lays(:)) min(od_all_lays(:,1)) max(od_all_lays(:,1)) min(od_all_lays(:,100)) max(od_all_lays(:,100))]);
fprintf(1,'log10 : min(OD) max(OD) min(OD)lay001 max(OD)lay001 min(OD)lay100 max(OD)lay100  %8.4e  %8.4e  %8.4e  %8.4e  %8.4e  %8.4e \n',junk)
