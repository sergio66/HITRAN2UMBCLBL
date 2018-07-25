f1 = 655; f2 = 755;
f1 = 755; f2 = 780;
f1 = 655; f2 = 705;
f1 = 2355; f2 = 2405;

f1a = 605; f2a = 2830;

fx1 =  605 : 25 : 1205;
fx2 = 1805 : 25 : 2805;

fx = [fx1 fx2];

ipfile = 'IPFILES/some_co2_9';
ipfile = 'IPFILES/co2one';
ipfile = 'IPFILES/some_co2_2';

for jj = 1 : length(fx)
  f1 = fx(jj);
  f2 = f1 + 25;

  outname = ['TESTHARTMANN/test_hartamann_'  num2str(f1) '.mat'];
  loader = ['load ' outname];
  eval(loader);

  %% umbc linemix
  clear topts
  topts.hartmann_linemix = -1;
  topts.v12p1 = -1;
  [w,dumbc14] = run8co2(2,f1,f2,ipfile,topts);

  topts.v12p1 = +1;
  [w,dumbc12] = run8co2(2,f1,f2,ipfile,topts);

  saver = ['save ' outname ' w dhartman dhartmanvoigt dumbc* dvanhuber '];
  saver = [saver ' dvoigt* ipfile'];
  eval(saver)
  end