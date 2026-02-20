%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 51-81 <<<

clear all

addpath0

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids < 0
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

nbox = 5;
pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% make directories
iMakeOutputDirs = +1;
if iMakeOutputDirs >= 0
  make_output_dirs_for_xsecgas_51_81
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now make gN_ir_xseclist2.txt which is list of all gaess/ 11 T that should be made

fid = fopen('gN_ir_xseclist2.txt','w');

cder_home

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  fprintf(1,'gasID = %2i \n',gid);

  iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
  iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81
  iSwitchXsecDataBase = 9999;  %% now we have       H2020 for g51-81

  iCnt = 0;
  for gg = gid : gid
    if gg <= iSwitchXsecDataBase
      %bands = list_bands(gg,2016);
      bands = list_bands(gg,2020);
    else
      bands = list_bands(gg,2012);
    end
    numbands = length(bands.v1);
    dwn = dv;
    dwn = 0;
    for wn = wn1 : dv : wn2
      woo = findxsec_plot_fast(wn,wn+dv,bands);
      cder_home      
      if woo >= 1
        iCnt = iCnt + 1;
        fprintf(1,'  for gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
        for tt = 1 : 11
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          fprintf(fid,'%s\n',str);
        end
      end
    end
  fprintf(1,'   >>> need to make %3i chunks for gas %2i \n',iCnt,gid)
  end

end
fclose(fid);

disp('to keep a copy of H2020 xseclist, now do eg  cp -a gN_ir_xseclist.txt gN_ir_xseclist2020.txt');
disp('  followed by                            cp gN_ir_xseclist2.txt gN_ir_xseclist.txt')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



