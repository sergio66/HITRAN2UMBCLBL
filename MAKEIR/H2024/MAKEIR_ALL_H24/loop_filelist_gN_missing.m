%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 3 - 47 <<<

clear all

addpath0

gids = input('Enter gasID list (or -1 to prompt for start/stop gasID, typically [3 49] since gid2 (CO2) made by LBLRTM ) : ');
if gids < 0
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

gids0 = gids;
if gids0(1) ~= 3
  fprintf(1,'  WARNING : gids(1) = %2i but will be starting from gids(1) = 3 to make current accounting wrt gN_ir_list2024.txt \n',gids(1))
  gids = 3 : gids0(end);
end

gids = setdiff(gids,[30 35 42]);  %% those 3 gases NOT present in breakout of HITRAN

nbox = 5;
pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% make directories
iMakeOutputDirs = -1;
if iMakeOutputDirs >= 0
  make_output_dirs_for_molgas_3_42
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : 7; figure(ii); clf; end

iRemoveEmptyFiles = input('Enter (-1/+1) to remove empty files (default no -1) : ');
if length(iRemoveEmptyFiles) == 0
  iRemoveEmptyFiles = -1;
end

iEmpty = 0;
iNotDone = 0;

iaNotFound = [];
iNotFound = 0;
iSumTotalToDo = 0;

iaTotalChunksNeeded_PerGas = [];
iaTotalFiles_StillNeeded_PerGas = [];

iaTotalChunksNeeded_PerGas = zeros(1,length(gids));
iaTotalFiles_StillNeeded_PerGas = zeros(1,length(gids));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cder_home

fid = fopen('gN_ir_listMissingALL.txt','w');
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

  fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  fdir = dirout;

  gg = gid;
  iCnt = 0;

  for wn = wn1 : dv : wn2
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
    if length(woo) >= 1
      iCnt = iCnt + 1;
      iaTotalChunksNeeded_PerGas(ii) = iaTotalChunksNeeded_PerGas(ii) + 1;      
      fprintf(1,'  gid = %2i found %6i lines in chunk %4i \n',gid,length(woo),wn);
      for tt = 1 : 11
        iSumTotalToDo = iSumTotalToDo + 1;      
	wah = ['std' num2str(wn) '_' num2str(gg) '_' num2str(tt) '.mat'];
	thefile = [fdir '/' wah];

	if exist(thefile)
	  xdir = dir(thefile);
          %% check to see if file has finite size, remove if iRemoveEmptyFiles == 1
	  if xdir.bytes == 0
            iaTotalFiles_StillNeeded_PerGas(ii) = iaTotalFiles_StillNeeded_PerGas(ii) + 1;
	  
            if iRemoveEmptyFiles == +1
              rmer = ['!/bin/rm ' thefile];
              fprintf(1,'%s is empty file, removing \n',thefile);
              eval(rmer)
            end
            if gg >= gids0(1)
   	      iNotFound = iNotFound + 1;
	      iaNotFound(iNotFound) = iSumTotalToDo;	    	    
              str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
              fprintf(fid,'%s\n',str);
              iEmpty = iEmpty + 1;
              emptyname.name{iEmpty} = thefile;
              emptyname.gas(iEmpty)  = gg;
              emptyname.wn(iEmpty)   = wn;
  	      emptyname.T(iEmpty)    = tt;
	      emptyname.iCnt(iEmpty) = iCnt;
	    end
          end     %% if xdir.bytes == 0
        elseif ~exist(thefile)
          iaTotalFiles_StillNeeded_PerGas(ii) = iaTotalFiles_StillNeeded_PerGas(ii) + 1;

          if gg >= gids0(1)
  	    iNotFound = iNotFound + 1;
	    iaNotFound(iNotFound) = iSumTotalToDo;		  
            str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
            fprintf(fid,'%s\n',str);
            iNotDone = iNotDone + 1;
            notdone.name{iNotDone} = thefile;
            notdone.gas(iNotDone)  = gg;
            notdone.wn(iNotDone)   = wn;
	    notdone.T(iNotDone)    = tt;
            notdone.iCnt(iNotDone) = iCnt;	    
	  end %% if gg >= gids0(1)
        end   %% if exist(thefile)
      end     %% for tt = 1 : 11
    end       %% if length(woo) >= 1
  end         %% for wn = wn1 : dv : wn2

  junk = [iCnt gid iaTotalFiles_StillNeeded_PerGas(ii) iaTotalChunksNeeded_PerGas(ii)];
  fprintf(1,'  >>> need to make %3i chunks for gas %2i total needed so far %5i out of AllTotal %5i \n',junk)
  figure(4);
    plot(gids(1:ii),iaTotalChunksNeeded_PerGas(1:ii)*11,'kx-',...
         gids(1:ii),iaTotalChunksNeeded_PerGas(1:ii)*11 - iaTotalFiles_StillNeeded_PerGas(1:ii),'g',...
         gids(1:ii),iaTotalFiles_StillNeeded_PerGas(1:ii),'ro-',...  
           'linewidth',2);
    hl = legend('total needed','done','still need to do','location','northeast'); set(hl,'fontsize',10);
  figure(1); pause(0.1);
  %fprintf(1,'need to make %3i chunks for gas %2i \n',iCnt,gid)
  %disp('ret'); pause  
end            %% for ii = 1 : length(gids)
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4);
  plot(gids(1:ii),iaTotalChunksNeeded_PerGas(1:ii)*11,'kx-',...
       gids(1:ii),iaTotalChunksNeeded_PerGas(1:ii)*11 - iaTotalFiles_StillNeeded_PerGas(1:ii),'g',...
       gids(1:ii),iaTotalFiles_StillNeeded_PerGas(1:ii),'ro-',...  
         'linewidth',2);
  hl = legend('total needed','done','still need to do','location','northeast'); set(hl,'fontsize',10);

fprintf(1,'still need to make %5i out of %5i total files that need to be made \n',sum(iaTotalFiles_StillNeeded_PerGas),sum(iaTotalChunksNeeded_PerGas)*11);
if iNotDone > 0
  figure(5); hist(notdone.gas); xlabel('gasID'); ylabel('Histogram'); title('Not Done Files')
  figure(6); plot(notdone.gas,notdone.wn,'+'); xlabel('gasID'); ylabel('Chunk cm-1'); title('Not Done Files')
end

fprintf(1,'found %4i empty files size 0 bytes \n',iEmpty);
if iEmpty > 0
  disp('there are empty files .. maybe short+ is not enough time (one hour) and you need 4 hours/medium+')
  disp('                      .. or they are stil processing')
    figure(7); hist(emptyname.gas); xlabel('gasID'); ylabel('Histogram'); title('Empty Files')
    figure(8); plot(emptyname.gas,emptyname.wn,'+'); xlabel('gasID'); ylabel('Chunk cm-1'); title('Empty Files')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iNotFound > 0
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt

  if length(iaNotFound) <= 10
    disp('  ')
    catter = ['!cat gN_ir_listMissingALL.txt'];
    eval(catter)
  end

  if length(iaNotFound) <= 10
    iaMax = 1:length(iaNotFound);
    disp('  showing all job arrays that are not done')
  else
    iaS = 1 : 5;
    iaE = length(iaNotFound)-4 :length(iaNotFound);
    iaMax = [iaS iaE];
    disp('  showing first/last five job arrays that are not done')
  end
  disp(' ')
  printarray(iaNotFound(iaMax))
  kapoo = load('gN_ir_list.txt');
  printarray(kapoo(iaNotFound(iaMax)));       %% this should reproduce g1_ir_list2.txt above !!!!!

  disp(' ')
  disp('if you want, can     cp g1_ir_list2.txt g1_ir_list0.txt; mv g1_ir_list2.txt g1_ir_list.txt')

  disp(' ')
  disp('  But much beter to edit/run "jobs_not_done.sc" output from write_out_jobsnotdone_for_cluster')
  disp('XYZ should be set to 1')
  if iNotFound > 0
    excl =  [];
    excl = 'c24-14,c24-28,c24-42,c24-45,c24-49,c24-50,c24-52';   %% from sqfail    
    write_out_jobsnotdone_for_cluster(iaNotFound,1:iSumTotalToDo,excl);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
