function [fall,odall,odN] = plot_Toffset(gid,Toffset,N,iUsualORHigh)

%% [fall,odall,odN] = plot_Toffset(2,5,3);
  
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

nbox = 5;
pointsPerChunk = 10000;
freq_boundariesLBL

fall = [];
odall = [];
odN   = [];
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
  fprintf(1,'%s \n',fname);
  if exist(fname)
    thedir = dir(fname);
    if thedir.bytes > 1e5
      x = load(fname);
      w = x.w;
      fall = [fall w];
      od = sum(x.d,2);
      odall = [odall; od];
      odN   = [odN  x.d(:,N)'];
    else
      x.w = (1:10000);
      x.w = (x.w-1)*0.0025 + ff;
      w = x.w;
      fall = [fall w];
      od = zeros(size(x.w));
      odall = [odall; od'];
      odN   = [odN 0*w];
    end      
  else
    x.w = (1:10000);
    x.w = (x.w-1)*0.0025 + ff;
    w = x.w;
    fall = [fall w];
    od = zeros(size(x.w));
    odall = [odall; od'];
    odN   = [odN 0*w];    
  end
  
end

fprintf(1,'X \n')

% whos fall odall

figure(1); semilogy(fall,odall,fall,odN); legend('Sum(OD)','OD(layN)','location','best');
