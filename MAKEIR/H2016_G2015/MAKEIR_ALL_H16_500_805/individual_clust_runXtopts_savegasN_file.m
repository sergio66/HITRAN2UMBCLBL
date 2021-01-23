gid = input('Enter which gas : ');
wn = input('Enter which chunk : ');

for tt = 1 : 11
  %% this is for MAKEFIR4, MAKEFIR5, MAKEFIR6, MAKEFIR7, comment out as necessary
    strx = [num2str(floor(wn),'%03d') '.' num2str((wn-floor(wn))*10,'%01d')];
  %% this is for Rest eg MAKEFIR3, MAKENIR*, comment out as necessary
    strx = [num2str(floor(wn),'%05d')];
  JOB = [num2str(gid,'%02d') strx num2str(tt,'%02d')];
  clust_runXtopts_savegasN_file
end 
