%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

home = pwd;

nbox = 5;
pointsPerChunk = 10000;
gases = [1]; gid = 1;

cder = ['cd ' home]; eval(cder);

freq_boundaries

waterlines_plot(fmin-25,fmax+25);

disp('<RET> to continue');
pause

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gg = 1;

gid = gg;
fdir = [dirout '/g' num2str(gid) '.dat'];
fdir = [dirout];
ee = exist(fdir,'dir');
if ee == 0
  fprintf(1,'%s does not exist \n',fdir);
  % iYes = input('make dir??? (-1/+1) : ');
  iYes = 1;
  if iYes > 0
    mker = ['!mkdir ' fdir];
    eval(mker);
  end
end

fid = fopen('g1_list.txt','w');
for gg = 01 : 01
  for wn = wn1:dv:wn2
    for tt = 1 : 11
      str  = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
      strx = [num2str(floor(wn),'%03d') '.' num2str(10*( wn-floor(wn)),'%01d')];
      str  = [num2str(gg,'%02d') strx  num2str(tt,'%02d')];

      str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];

      fprintf(fid,'%s\n',str);
    end
  end
end
fclose(fid);
