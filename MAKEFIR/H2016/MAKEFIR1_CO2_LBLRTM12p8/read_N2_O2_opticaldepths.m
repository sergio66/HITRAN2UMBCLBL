%{
  d           10000x100              8000000  double              
  dx              0x0                      0  double              
  ee              1x1                      8  double              
  fname           1x81                   162  char                
  loader          1x86                   172  char                
  thedir          1x1                    969  struct              
  w               1x10000              80000  double              
  ww              1x1                      8  double              
  wx              0x0                      0  double              
%}

wx1 = [];
dx1 = [];

wx6 = [];
dx6 = [];

wx11 = [];
dx11 = [];

for ww = 605 : 25 : 2805

  fname = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/std' num2str(ww) '_22_1.mat'];
  ee = exist(fname);
  if ee > 0
    thedir = dir(fname);
    if thedir.bytes > 100000
      loader = ['load ' fname];
      eval(loader);
      wx1 = [wx1 w];
      dx1 = [dx1 sum(d')];
      plot(wx1,dx1,'b'); pause(0.1);
    end
  end

  fname = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/std' num2str(ww) '_22_6.mat'];
  ee = exist(fname);
  if ee > 0
    thedir = dir(fname);
    if thedir.bytes > 100000
      loader = ['load ' fname];
      eval(loader);
      wx6 = [wx6 w];
      dx6 = [dx6 sum(d')];
      plot(wx6,dx6,'g'); pause(0.1);
    end
  end

  fname = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/std' num2str(ww) '_22_11.mat'];
  ee = exist(fname);
  if ee > 0
    thedir = dir(fname);
    if thedir.bytes > 100000
      loader = ['load ' fname];
      eval(loader);
      wx11 = [wx11 w];
      dx11 = [dx11 sum(d')];
      plot(wx11,dx11,'r'); pause(0.1);
    end
  end

end


plot(wx1,dx1,wx6,dx6,wx11,dx11)
legend('Toff1','Toff6','Toff11','location','north')