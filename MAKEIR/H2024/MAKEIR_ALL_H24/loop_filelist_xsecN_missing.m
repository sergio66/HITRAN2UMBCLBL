%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

clear all

for ii = 1 : 6; figure(ii); clf; end

addpath0

iRemoveEmptyFiles = input('Enter (-1/+1) to remove empty files (default no -1) : ');
if length(iRemoveEmptyFiles) == 0
  iRemoveEmptyFiles = -1;
end
iEmpty = 0;
iNotDone = 0;

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbox = 5;
pointsPerChunk = 10000;

cder_home

iaTotalAll = [];
iaTotalNeed = [];

iaTotalAll = zeros(1,length(gids));
iaTotalNeed = zeros(1,length(gids));

for ii = 1 : length(gids)
  gid = gids(ii);

  fprintf(1,'gasID = %2i \n',gid);

  freq_boundaries

  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen('gN_ir_xseclist2.txt','w');
for ii = 1 : length(gids)
  gid = gids(ii);

  fprintf(1,'gasID = %2i \n',gid);

  freq_boundaries

  iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
  iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81
  iSwitchXsecDataBase = 9999;  %% now we have       H2020 for g51-81

  iCnt = 0;
  gg = gid;
  fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];

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
    if woo >= 1
      iCnt = iCnt + 1;
      iaTotalAll(ii) = iaTotalAll(ii) + 1;
      fprintf(1,'  gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
      for tt = 1 : 11
        wah = ['std' num2str(wn) '_' num2str(gg) '_' num2str(tt) '.mat'];
	thefile = [fdir '/' wah];

        if exist(thefile)
	  xdir = dir(thefile);
          %% check to see if file has finite size, remove if iRemoveEmptyFiles == 1
	  if xdir.bytes == 0
            iaTotalNeed(ii) = iaTotalNeed(ii) + 1;	  
            str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
            fprintf(fid,'%s\n',str);
            if iRemoveEmptyFiles == +1
              rmer = ['!/bin/rm ' thefile];
              fprintf(1,'%s is empty file, removing \n',thefile);
              eval(rmer)
            end
            iEmpty = iEmpty + 1;
            emptyname.name{iEmpty} = thefile;
            emptyname.gas(iEmpty) = gg;
            emptyname.wn(iEmpty) = wn;
          end        %% if xdir.bytes == 0
	elseif ~exist(thefile)
          iaTotalNeed(ii) = iaTotalNeed(ii) + 1;	  
          iNotDone = iNotDone + 1;
          notdone.name{iNotDone} = thefile;
          notdone.gas(iNotDone)  = gg;
          notdone.wn(iNotDone)   = wn;
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          fprintf(fid,'%s\n',str);
        end   %% if exist(thefile)
      end     %% for tt = 1 : 11
    end       %% if length(woo) >=1 
  end         %% for wn = wn1 : dv : wn2
  fprintf(1,'need to make %3i chunks for gas %2i \n',iCnt,gid)
  %disp('ret'); pause
end
fclose(fid);

fprintf(1,'still need to make %5i out of %5i total files that need to be made \n',sum(iaTotalNeed),sum(iaTotalAll)*11);
if iNotDone > 0
  figure(5); hist(notdone.gas); xlabel('gasID'); ylabel('Histogram'); title('Not Done Files')
  figure(6); plot(notdone.gas,notdone.wn,'+'); xlabel('gasID'); ylabel('Chunk cm-1'); title('Not Done Files')
end

fprintf(1,'found %4i empty files \n',iEmpty);
if iEmpty > 0
  disp('there are missing files .. maybe short+ is not enough time (one hour) and you need 4 hours/medium+')
  figure(7); hist(emptyname.gas); xlabel('gasID'); ylabel('Histogram'); title('Empty Files')
  figure(8); plot(emptyname.gas,emptyname.wn,'+'); xlabel('gasID'); ylabel('Chunk cm-1'); title('Empty Files')
end
