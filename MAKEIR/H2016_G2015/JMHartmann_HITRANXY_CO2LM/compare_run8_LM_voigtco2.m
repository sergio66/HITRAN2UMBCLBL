bandinfo = load('/asl/data/hitran/H2016/LineMix2/Updates_LMCO2_HITRANonline2018/data_new/BandInfo.dat');

disp('iDir = LM executable : (1) Orig (2) only fixed rdmult (3) fixed rdmult and Qtips and MassIso');

junk = input('Enter [chunk dir] to look at : ');
iChunk = junk(1);
iDir   = junk(2); 

T = 200 : 20 : 320;

if iDir == 1
  finalname = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix/sampleT_'];
elseif iDir == 2
  finalname = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix_rdmult/sampleT_'];
elseif iDir == 3
  finalname = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0_selfbroadTfix_rdmult_newQtip/sampleT_'];
end

finalname = [finalname num2str(iChunk) '_2_6.mat'];

load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link

if exist(finalname)
  loader = ['load ' finalname];
  eval(loader)

  [mm,nn]     = size(d);
  [mmLM,nnLM] = size(dvoigt);  

  if nn ~= nnLM
    disp('oops run8 and LM are different array sizes, need to fix ...');
    ratio = nn/nnLM;
    wout = 1:nn; wout = wout-1; wout = w(1) + wout*0.0025/ratio;
    for jj = 1 : mm
      dx(jj,:) = interp1(wout,d(jj,:),w,[],'extrap');
    end
    d = dx;
  end

  figure(1); plot(w,dvoigt./d); title('LM/UMBC Voigt');
  figure(2); plot(w,d(1,:),w+1.5*0.0025,dvoigt(1,:)); hl = legend('UMBC','LM Voigt');
 
  ix = find(d(1,:) == min(d(1,:)),1);
  iy = find(d(1,:) == max(d(1,:)),1);  
  fprintf(1,'chunk %4i minOD/maxOD at %10.5f %10.5f\n',iChunk,w(ix),w(iy));

  T = T(1:mm);
  
  figure(3); plot(T,dvoigt(:,ix)./d(:,ix),'bo-',T,dvoigt(:,iy)./d(:,iy),'rx-');
  %hl = legend(num2str((T)'));
  hl = legend('minOD','maxOD');xlabel('T'); ylabel('LMvoigt/UMBCvoigt');

  if length(T) > 3
    P = polyfit(T,dvoigt(:,ix)'./d(:,ix)',1);
    %% now find T where the ratio = 1    y = mx+c ==> x = (y-c)/m
    fprintf(1,'according to the ratio VS T plot, need To = %8.6f for ratio = 1 \n',(1-P(2))/P(1))

    %T0 = refpro.mtemp(5);
    %factor = (T)/T0;

    %wahfactor = dvoigt(:,ix)./d(:,ix);
    %[factor; wahfactor'; factor.*wahfactor']
  end
  
else
  fprintf(1,'%s DNE \n',finalname);
end
