%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 3 - 47 <<<

clear all

for ii = 1 : 6; figure(ii); clf; end

iRemoveEmptyFiles = input('Enter (-1/+1) to remove empty files (default no -1) : ');
if length(iRemoveEmptyFiles) == 0
  iRemoveEmptyFiles = -1;
end
iEmpty = 0;
iNotDone = 0;

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

gids = setdiff(gids,[30 35 42]);  %% those 3 gases NOT present in breakout of HITRAN

nbox = 5;
pointsPerChunk = 10000;

iaTotalAll = [];
iaTotalNeed = [];

iaTotalAll = zeros(1,length(gids));
iaTotalNeed = zeros(1,length(gids));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  fprintf(1,'gasID = %2i \n',gid);

  [iYes,line] = findlines_plot(605-dv,2830+dv,gid);

  %disp('<RET> to continue');
  pause(0.1)

  %cd /home/sergio/HITRAN2UMBCLBL/MAKEIR//H2016/MAKEIR_ALL_H16/
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR//H2020/MAKEIR_ALL_H20/

  freq_boundaries

  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  ee = exist(fdir,'dir');
  if ee == 0
    fprintf(1,'%s does not exist \n',fdir);
    % iYes = input('make dir??? (-1/+1) : ');
    iYes = 1
    if iYes > 0
      mker = ['!mkdir ' fdir];
      eval(mker);
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen('gN_ir_list2.txt','w');
for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  iCnt = 0;

  gg = gid;
  fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  for wn = wn1 : dv : wn2
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
    if length(woo) >= 1
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
          end     %% if xdir.bytes == 0
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
    end       %% if length(woo) >= 1
  end         %% for wn = wn1 : dv : wn2

  junk = [iCnt gid iaTotalNeed(ii) iaTotalAll(ii)];
  fprintf(1,'  >>> need to make %3i chunks for gas %2i total needed so far %5i out of AllTotal %5i \n',junk)
  figure(4); plot(gids(1:ii),iaTotalNeed(1:ii),'bo-',gids(1:ii),iaTotalAll(1:ii)*11,'rx-','linewidth',2);
    hl = legend('still need to do','total needed','location','northeast'); set(hl,'fontsize',10);
  figure(1); pause(0.1);
end            %% for ii = 1 : length(gids)
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

