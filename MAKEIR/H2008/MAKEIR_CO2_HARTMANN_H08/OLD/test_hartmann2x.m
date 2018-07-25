f1 = 655; f2 = 755;
f1 = 755; f2 = 780;
f1 = 655; f2 = 705;
f1 = 2355; f2 = 2405;

f1a = 605; f2a = 2830;

fx1 =  605 : 25 : 1205;
fx2 = 1805 : 25 : 2805;

fx = [fx1 fx2];

fx = 2255;

ipfile = 'IPFILES/std_co2_1_91'
ipfile = 'IPFILES/refgas2_1_91'

for jj = 1 : length(fx)
  f1 = fx(jj);
  f2 = f1 + 25;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% umbc linemix with H98 database
  rmer = ['!/bin/rm /home/sergio/SPECTRA/CO2_MATFILES/*.mat'];
  eval(rmer)
  clear topts
  topts.hartmann_linemix = -1;
  topts.HITRAN    = '/asl/data/hitran/h98.by.gas';
  [w,dumbc98] = run8co2(2,f1,f2,ipfile,topts);

  %% umbc linemix with latest database
  rmer = ['!/bin/rm /home/sergio/SPECTRA/CO2_MATFILES/*.mat'];
  eval(rmer)
  clear topts
  topts.hartmann_linemix = -1;
  [w,dumbc] = run8co2(2,f1,f2,ipfile,topts);


%  outname = ['test_hartamannNEW_'  num2str(f1) '.mat'];
%  saver = ['save ' outname ' w dhartman dhartmanvoigt dumbc dvanhuber dvoigt* ipfile'];
%  eval(saver)
  end