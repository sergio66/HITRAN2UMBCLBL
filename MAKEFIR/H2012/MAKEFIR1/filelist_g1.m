%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

home = pwd;

waterlines_plot

disp('<RET> to continue');
pause

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

cder = ['cd ' home]; eval(cder);

freq_boundaries_g1

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

fid = fopen('g1_list.txt','w');
for gg = 01 : 01
  for wn = wn1:dv:wn2
    for tt = 1 : 11
      str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
      fprintf(fid,'%s\n',str);
    end
  end
end
fclose(fid);
