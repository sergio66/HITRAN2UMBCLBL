%% gas9 rather discontinous at 42000 cm-1
nbox = 5; pointsPerChunk = 10000;
freq_boundaries;

gid = input('Enter gasID : ');

figure(1); clf
for ii = wn1 : dv : wn2-dv
  if gid ~= 1
    fname = [dirout 'std' num2str(ii) '_xsec_' num2str(gid) '_6.mat'];
  else
    fname = [dirout 'std' num2str(ii) '_' num2str(gid) '_6_3.mat'];
    end
  ee = exist(fname);
  if ee > 0
    ind = 1 : 10 : 10000;
    loader = ['load ' fname]; eval(loader);
    plot(w(ind),sum(d(:,ind))); hold on
    pause(0.1)
    end
  end
hold off