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
ipfile = 'IPFILES/std_co2_1_91'

for jj = 1 : length(fx)
  f1 = fx(jj);
  f2 = f1 + 25;

  %% hartmann, full linemix
  clear topts
  topts.hartmann_linemix = +1;
  [w,dhartman] = run8co2(2,f1,f2,ipfile,topts);

  %% hartmann, voigt only
  clear topts
  topts.hartmann_linemix = +1;
  topts.NIF = 'v';
  [w,dhartmanvoigt] = run8co2(2,f1,f2,ipfile,topts);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% run8 voigt
  clear topts
  topts.hartmann_linemix = 0;
  topts.LVF = 'G';
  [w,dvoigt] = run8co2(2,f1,f2,ipfile,topts);

  %% run8 voigt, with H2k database
  clear topts
  topts.hartmann_linemix = 0;
  topts.LVF = 'G';
  topts.HITRAN    = '/asl/data/hitran/h2k.by.gas';
  [w,dvoigt00] = run8co2(2,f1,f2,ipfile,topts);

  %% run8 van huber
  clear topts
  topts.hartmann_linemix = 0;
  [w,dvanhuber] = run8co2(2,f1,f2,ipfile,topts);

  %% umbc linemix
  clear topts
  topts.hartmann_linemix = -1;
  [w,dumbc] = run8co2(2,f1,f2,ipfile,topts);

  outname = ['test_hartamannNEW_'  num2str(f1) '.mat'];
  saver = ['save ' outname ' w dhartman dhartmanvoigt dumbc dvanhuber dvoigt* ipfile'];
  eval(saver)
  end