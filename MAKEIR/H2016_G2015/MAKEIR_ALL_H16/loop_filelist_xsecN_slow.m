%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

fid = fopen('gN_ir_xseclist.txt','w');
nbox = 5;
pointsPerChunk = 10000;

freq_boundaries


cd ~/HITRAN2UMBCLBL/MAKEIR_ALL_H12/

for ii = 1 : length(gids)
  gid = gids(ii);

  fprintf(1,'gasID = %2i \n',gid);

  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  ee = exist(fdir,'dir');
  if ee == 0
    fprintf(1,'%s does not exist \n',fdir);
    %iYes = input('make dir??? (-1/+1) : ');
    iYes = +1;
    if iYes > 0
      mker = ['!mkdir ' fdir];
      eval(mker);
    end
  end

  iCnt = 0;
  for gg = gid : gid
    for wn = wn1 : dv : wn2
      dwn = dv;
      dwn = 0;
      [iYes,line] = findxsec_plot(wn-dwn,wn+dwn,gid,2016);
      woo = iYes;
      if woo >= 1
        iCnt = iCnt + 1;
        fprintf(1,'  for gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
        for tt = 1 : 11
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          fprintf(fid,'%s\n',str);
        end
      end
    end
  fprintf(1,'need to make %3i chunks for gas %2i \n',iCnt,gid)
  end

end
fclose(fid);

