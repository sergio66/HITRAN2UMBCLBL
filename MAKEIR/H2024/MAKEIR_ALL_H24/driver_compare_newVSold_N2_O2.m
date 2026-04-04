function [data] = driver_compare_newVSold_N2_O2(gid,fchunk,Toff);

if nargin == 0
  gid = 22;
  fchunk = 2380;
  Toff = 6;
elseif nargin == 1
  fchunk = 2380;
  Toff = 6;
elseif nargin == 2
  Toff = 6;
end  

fold = ['/home/sergio/nogit/H2024_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/oldrun8/std' num2str(fchunk) '_' num2str(gid) '_' num2str(Toff) '.mat'];
fnew = ['/home/sergio/nogit/H2024_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat/std'         num2str(fchunk) '_' num2str(gid) '_' num2str(Toff) '.mat'];

data = [];

if exist(fold) & exist(fnew)
  dir0 = dir(fold);
  dir1 = dir(fnew);
  if dir0.bytes > 1000 & dir1.bytes > 1000
    oldOD = load(fold);
    newOD = load(fnew);
    figure(1); plot(newOD.w,sum(newOD.d,1)./sum(oldOD.d,1)); title('new/old')
    figure(2); plot(oldOD.w,sum(oldOD.d,1),newOD.w,sum(newOD.d,1)); legend('old','new')
    data.w = newOD.w;
    data.od1 = sum(oldOD.d,1);
    data.od2 = sum(newOD.d,1);
  end
else
  fprintf(1,'exist(fold) %2i exist(fnew) %2i \n',exist(fold),exist(fnew))
  if exist(fold)
    oldOD = load(fold);
    figure(2); plot(oldOD.w,sum(oldOD.d,1)); legend('old')    
  elseif exist(fnew)
    newOD = load(fnew);
    figure(2); plot(newOD.w,sum(newOD.d,1)); legend('new')
  end
end

