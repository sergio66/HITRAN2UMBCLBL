%% rather discontinous at 42000 cm-1
nbox = 5; pointsPerChunk = 10000;
freq_boundaries;
figure(1); clf
for ii = wn1 : dv : wn2-dv
  loader = ['load ' dirout 'std' num2str(ii) '_xsec_9_6.mat'];
  eval(loader);
  plot(w,sum(d)); hold on
  pause(0.1)
  end
hold off