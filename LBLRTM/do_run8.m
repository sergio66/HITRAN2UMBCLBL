% test parameters
gid = 2;       % HITRAN gas id
pT  = 40.2;    % cell pressure in torr
tC  = 17;      % cell temperature in degrees C
Lcm = 12.59;   % path length in cm
v1  = 605;     % band start
v2  = 1230;    % band end

% convert pressures
torr2mb = 1013.25 / 760;
mb2atm = 9.86923267e-4;
patm = pT * torr2mb * mb2atm;
ppatm = patm;

% convert temperature
tC2K = 273.15;
tK = tC + tC2K;

% change to kmoles/cm2
MGC = 8.314674269981136;
gAmt = Lcm * 101325 * ppatm / 1e9 / MGC / tK;

% write a params file
gf = './run8_CO2.tmp';
fi = fopen(gf, 'w');
fprintf(fi, '%4d%12.4e%12.4e%8.2f%12.4e\n', 1, patm, ppatm, tK, gAmt)
fclose(fi);

% call run8
addpath /home/sergio/SPECTRA
%[fr, absc] = run8(gid, v1, v2, gf);
% keep data in column order
%fr = fr(:); absc = absc(:);

[fr,drun8,drun8noshift,drun8shiftneg1,dglab,dlblrtm] = driver_run8_glab_lblrtm_self(2,v1,v2,'run8_CO2.tmp');
fr = fr(:); dlblrtm = dlblrtm(:); genln2 = dglab(:);

cd /home/sergio/SPECTRA
[w1,dfull1] = run8co2_FULLlinemixUMBC(2,v1,905,'/home/sergio/HITRAN2UMBCLBL/LBLRTM/run8_CO2.tmp');
[w1,dorig1] = run8co2_linemixUMBC(2,v1,905,'/home/sergio/HITRAN2UMBCLBL/LBLRTM/run8_CO2.tmp');
[w2,dfull2] = run8co2_FULLlinemixUMBC(2,905,v2,'/home/sergio/HITRAN2UMBCLBL/LBLRTM/run8_CO2.tmp');
[w2,dorig2] = run8co2_linemixUMBC(2,905,v2,'/home/sergio/HITRAN2UMBCLBL/LBLRTM/run8_CO2.tmp');
cd /home/sergio/HITRAN2UMBCLBL/LBLRTM/

dfull = [dfull1 dfull2];
dorig = [dorig1 dorig2];

% save the results
save run8_402t_CO2 fr dlblrtm genln2 dfull dorig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot([w1 w2],exp(-dfull),'b',[w1 w2],exp(-dorig),'r',fr,exp(-genln2),'g',fr,exp(-dlblrtm),'k','linewidth',2)

