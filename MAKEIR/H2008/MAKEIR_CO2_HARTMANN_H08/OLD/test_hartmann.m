f1 = 655; f2 = 755;
f1 = 755; f2 = 780;
f1 = 655; f2 = 705;
f1 = 2355; f2 = 2405;

ipfile = 'IPFILES/some_co2_9';
ipfile = 'IPFILES/co2one';
ipfile = 'IPFILES/some_co2_2';

%% hartmann, full linemix
clear topts
topts.hartmann_linemix = +1;
[w,dhartman] = run8co2(2,f1,f2,ipfile,topts);
error('ack');

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% umbc linemix
clear topts
topts.hartmann_linemix = -1;
[w,dumbc] = run8co2(2,f1,f2,ipfile,topts);

ii = 8; clf; 
h1 = subplot(211); 
  plot(w,dvoigt(ii,:),w,dhartmanvoigt(ii,:),w,dvoigt00(ii,:))
h2 = subplot(212); 
  plot(w,dvoigt(ii,:)-dhartmanvoigt(ii,:),...
       w,dvoigt00(ii,:)-dhartmanvoigt(ii,:),'r')
adjust21(h1,h2,'even')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pl
save test_hartmann.mat w dhartman dhartmanvoigt dumbc dvanhuber dvoigt* ipfile
plot(w,dvoigt-dhartmanvoigt,w,dvoigt-dvanhuber,w,dhartman-dumbc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%