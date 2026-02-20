%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 1-47 <<<

clear all

addpath0

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID, typically [3 49] since gid2 (CO2) made by LBLRTM ) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

gids = setdiff(gids,[30 35 42]);  %% those 3 gases NOT present in breakout of HITRAN

nbox = 5;
pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% make directories
iMakeOutputDirs = +1;
if iMakeOutputDirs >= 0
  make_output_dirs_for_molgas_3_42
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now make gN_ir_list2.txt which is list of all gases/ 11 T that should be made

fid = fopen('gN_ir_list2.txt','w');

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  fprintf(1,'gasID = %2i \n',gid);
  figure(1);  
  [iYes,line] = findlines_plot(605-dv,2830+dv,gid);

  %disp('<RET> to continue');
  pause(0.1)

  cder_home
  
  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  iCnt = 0;
  for gg = gid : gid
    for wn = wn1 : dv : wn2
      woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
      if length(woo) >= 1
        iCnt = iCnt + 1;
        fprintf(1,'for gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
        for tt = 1 : 11
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          fprintf(fid,'%s\n',str);
        end
      end
    end
  fprintf(1,'  >>> need to make %3i chunks for gas %2i \n',iCnt,gid)
  end

end
fclose(fid);

disp('to keep a copy of H2020 list, now do eg  cp -a gN_ir_list.txt gN_ir_list2020.txt');
disp('  followed by                            cp gN_ir_list2.txt gN_ir_list.txt')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

