%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

addpath0

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

cder_home

gid = input('Enter gasID : ');

freq_boundaries

figure(1);
[iYes,line] = findlines_plot(605-dv,2830+dv,gid);

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_ALL_H24/

%disp('<RET> to continue'); pause
pause(0.1)

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

fdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
fdir = dirout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ee = exist(fdir,'dir');
if ee == 0
  fprintf(1,'%s does not exist \n',fdir);
  iYes = input('make dir??? (-1/+1) : ');
  if iYes > 0
    mker = ['!mkdir ' fdir];
    eval(mker);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iNotFound = 0;
iCnt = 0;
iAllFound = 0;

loop_find_individual_gas_made

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_ALL_H24/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

