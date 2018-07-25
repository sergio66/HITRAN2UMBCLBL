
% ---------------------------------------
%  22-24 Sept 2013 ITT CO2 gas cell tests
% ---------------------------------------

% RDR datasets in Matlab format
mat_pref = ['/Users/tilak/Desktop/Work/UMBC/GasAnal/cris/' ...
            'BenchData-Harvested/2013_09_23-24_GasCell/']; 
mat_stage2 = 'GasCell_Stage2';
mat_ict = '';
mat_spc = '';

% index for subsets of the above; [] = all
ind_et1 = [];
ind_et2 = [];
ind_ft1 = [];
ind_ft2 = [];
ind_ict = [];
ind_spc = [];

% Test Parameters
gas = 'H2O';       % gas name, for plot lables
rstr = '1';        % run label, for plot labels
bstr = 'LW';       % band name, for csv field selection
badfov = [];	   % FOVs to skip
vstats = [];       % turn off sample stats
ifile = 'crisB1a'; % interferometric parameters
kv1 = 605;	   % kcmix band low (must match ifile)
kv2 = 1105;	   % kcmix band high (must match ifile)
tv1 = 650;	   % test band low
tv2 = 1050;	   % test band high

% fitting interval, a subset of [tv1, tv2]
qv1 = 660;
qv2 = 730;

% metrology laser wavelength
wlaser = 773.1301;

% Gas path data
torr2mb = 1013.25 / 760;
tc2k = 273.15;
prof.glist = 4;
prof.mpres = 760.0 * torr2mb;
prof.gpart = 760.0 * 0.3d-6 * torr2mb;
prof.mtemp = 20 + tc2k;
% prof.gamnt = 1e-9;

% adjust for 12.543 cm cell
% abswt = 1.2543;

% HTBB values (set bb_et1 to [] for no HTBB cal)
bb_et1 = [];
bb_et2 = [];
bb_ft1 = [];
bb_ft2 = [];

% Optional run comments
notes{1} = '';

