addpath /home/sergio/SPECTRA
cd /home/sergio/SPECTRA

airs_nodes;

fx1 =  605 : 25 : 855;
fx2 = 2105 : 25 : 2455;

fx1 =  605 : 25 : 780;
fx2 = 2205 : 25 : 2380;

fx = [fx1 fx2];

ipfile = 'IPFILES/std_co2';

iDoHart = -1;
iDoUMBC = +1;

jj0 = iDoJob;
for jj = jj0 : jj0
  f1 = fx(jj);
  f2 = f1 + 25;

  [f1 f2]

  if iDoHart > 0
    %% hartmann
    outname = ['/carrot/s1/sergio/TESTHARTMANN_CO2/'];
    outname = [outname 'test_std_hart'  num2str(f1) '.mat'];
    clear topts
    topts.hartmann_linemix = +1;
    [w,dhart] = run8co2(2,f1,f2,ipfile,topts);
    saver = ['save ' outname ' w dhart'];
    eval(saver)
    end

  if iDoUMBC > 0
    %% umbc linemix
    outname = ['/carrot/s1/sergio/TESTHARTMANN_CO2/'];
    outname = [outname 'test_std_umbc12_1998_'  num2str(f1) '.mat'];
    clear topts
    topts.hartmann_linemix = -1;
    topts.HITRAN    = '/asl/data/hitran/h98.by.gas';
    %topts.v12p1 = +1;

    [w,dumbc12_2002] = run8co2(2,f1,f2,ipfile,topts);
    saver = ['save ' outname ' w dumbc12_2002 '];
    eval(saver)
    end

  end