%% /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm   has (gasN+all gases)-(all gases) with N2 continuum ON
%% /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/lblrtm2  has (gasN+allgases)              with N2 continuum OFF

iaX = input('Enter [gasID chunk Toff]  where 605 <= chunk <= 2805 and 1 <= Toff <= 11 : ');
if length(iaX) ~= 3
  error('need 3 elements in array!')
end

if iaX(1) ~= 7 & iaX(1) ~= 22
  f1 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(iaX(1)) '.dat/lblrtm/std'  num2str(iaX(2)) '_' num2str(iaX(1)) '_' num2str(iaX(3)) '.mat'];
  f2 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(iaX(1)) '.dat/lblrtm2/std' num2str(iaX(2)) '_' num2str(iaX(1)) '_' num2str(iaX(3)) '.mat'];

  if exist(f1) & exist(f2)
    d0 = load(f1);
    d2 = load(f2);
    figure(1); plot(d0.w,d0.d ./ d2.d)
    figure(1); plot(d0.w,d0.d ./ d2.d - 1 )
    figure(2); semilogy(d0.w,d0.d(:,1),d0.w,d2.d(:,1),'r')     

 elseif exist(f1) & ~exist(f2)
    error('file in lblrtm2 does not exist');
  elseif ~exist(f1) & exist(f2)
    error('file in lblrtm does not exist');
  elseif ~exist(f1) & ~exist(f2)
    error('files in lblrtm/lblrtm2 do not exist');
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif iaX(1) == 22

  f0 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm/std' num2str(iaX(2)) '_22_'  num2str(iaX(3)) '.mat'];
  fx = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/std' num2str(iaX(2))        '_22_'  num2str(iaX(3)) '.mat'];       

  %f2 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g7.dat/lblrtm2/std' num2str(iaX(2))  '_7_'  num2str(iaX(3)) '.mat'];  %% before smart_separate_N2O2
  f2 = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g22.dat/lblrtm2/std' num2str(iaX(2))  '_22_'  num2str(iaX(3)) '.mat'];  %% after smart_separate_N2O2

  d2 = load(f2);
  d0 = load(f0);
  dx = load(fx);
  plot(d0.w,d0.d(:,1),d2.w,d2.d(:,1),'r.',dx.w,dx.d(1,:),'k')

end
