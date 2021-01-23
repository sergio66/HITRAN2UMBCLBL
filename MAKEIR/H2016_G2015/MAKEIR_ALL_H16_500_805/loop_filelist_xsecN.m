%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 51-81 <<<

addpath /home/sergio/SPECTRA
addpath /home/sergio/SPECTRA/READ_XSEC
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

gids = gids(gids >= 51 & gids <= 81);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

homedir = pwd;

iWhich = input('Make filelist for (+1) all files, default or (-1) missing files : ');
%iWhich = +1;
if length(iWhich) == 0
  iWhich = 1;
end
if iWhich == -1
  iRemove = input('Remove empty files (-1) default (+1) yes : ');
  if length(iRemove) == 0
    iRemove = -1;
  end 
end

if iWhich == 1
  fid = fopen('gN_ir_xseclist_all.txt','w');
else
  fid = fopen('gN_ir_xseclist_notdone.txt','w');
end

nbox = 5;
pointsPerChunk = 10000;

cder = ['cd ' homedir]; eval(cder);

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  fprintf(1,'gasID = %2i \n',gid);

  dv25 = 25;
  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  fdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g' num2str(gid) '.dat'];

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

  iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
  iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81

  dv25 = 25;
  if iWhich == 1
    iCnt = 0;
    for gg = gid : gid
      if gg <= iSwitchXsecDataBase
        bands = list_bands(gg,2016);
      else
        bands = list_bands(gg,2012);
      end
      numbands = length(bands.v1);
      dwn = dv;
      dwn = 0;
      for wn = wn1 : dv : wn2
        woo = findxsec_plot_fast(wn-dv25,wn+dv+dv25,bands);
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
    %disp('ret'); pause
    pause(1)
  
  else
    iCnt = 0;
    iNotMade = 0;
    for gg = gid : gid
      if gg <= iSwitchXsecDataBase
        bands = list_bands(gg,2016);
      else
        bands = list_bands(gg,2012);
      end
      numbands = length(bands.v1);
      dwn = dv;
      dwn = 0;
      for wn = wn1 : dv : wn2
        woo = findxsec_plot_fast(wn-dv25,wn+dv+dv25,bands);
        if woo >= 1
          iCnt = iCnt + 1;
          fprintf(1,'  for gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
          for tt = 1 : 11
            str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
            fnameout = [fdir '/std'  num2str(wn) '_' num2str(gg) '_' num2str(tt) '.mat'];
            if exist(fnameout)
              %% well fine it exists, but it maybe empty
              thedir = dir(fnameout);
              if thedir.bytes == 0 & iRemove == 1
                fprintf(1,'%s is empty \n',fnameout);
                rmer = ['!/bin/rm ' fnameout];
                eval(rmer)
              end
            end
            if ~exist(fnameout)
              iNotMade = iNotMade + 1;
              fprintf(fid,'%s\n',str);
            end
          end
        end
      end
    fprintf(1,'need to make %3i chunks for gas %2i \n',iCnt,gid)
    end
    %disp('ret'); pause
    pause(1)
  end  
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' >>>>>>>>>>>>>> ')
disp('size of files : still not made vs all to be made ')
morer = ['! more gN_ir_xseclist_notdone.txt | wc -l; more gN_ir_xseclist_all.txt | wc -l'];
eval(morer);
disp(' >>>>>>>>>>>>>> ')

