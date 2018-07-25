clear refpro
load refprof_usstd6Aug2010_lbl.mat
pnew = refpro;

clear refpro
load refprof_usstd2010_lbl.mat
pold = refpro;

clear refpro
plot(pnew.mtemp./pold.mtemp); title('temp'); pause;

jj = 0;
for ii = [[1:42] [51:81]]   %%1-42 = 42 lbl gases; 51-81=31 xsec gases
  jj = jj + 1;
  str = ['q1 = pnew.gamnt(:,' num2str(jj) ');']; eval(str);
  str = ['q2 = pold.gamnt(:,' num2str(jj) ');']; eval(str);
  figure(1); semilogy(q1);
  figure(2); plot(q1./q2); title(num2str(ii)); pause(1)
  end