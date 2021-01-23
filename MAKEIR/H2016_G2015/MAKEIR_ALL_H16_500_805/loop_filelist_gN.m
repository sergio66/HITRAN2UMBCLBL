%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

%% >>> do gases 1-47 <<<

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil


gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end

gids = setdiff(gids,[30 35 42]);  %% those 3 gases NOT present in breakout of HITRAN

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
  fid = fopen('gN_ir_list_all.txt','w');
else
  fid = fopen('gN_ir_list_notdone.txt','w');
end

nbox = 5;
pointsPerChunk = 10000;

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  fprintf(1,'gasID = %2i \n',gid);

  dv25 = 25;
  [iYes,line] = findlines_plot(wn1-dv25,wn2+dv25,gid);

  %disp('<RET> to continue');
  pause(0.1)

  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_ALL_H16_500_805

  freq_boundaries

  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  fdir = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/IR_500_805/g' num2str(gid) '.dat'];

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

  if iWhich == +1
    iCnt = 0;
    gg = gid;
    for wn = wn1 : dv : wn2
      woo = find(line.wnum >= wn-dv25 & line.wnum <= wn+dv+dv25);
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
  else
    iCnt = 0;
    iNotMade = 0;
    gg = gid;
    for wn = wn1 : dv : wn2
      woo = find(line.wnum >= wn-dv25 & line.wnum <= wn+dv+dv25);
      if length(woo) >= 1
        iCnt = iCnt + 11;
        fprintf(1,'for gid = %2i found %4i lines in chunk %4i \n',gid,length(woo),wn);
        for tt = 1 : 11
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          %% example std725_3_5.mat
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
        end   %% for tt = 1 : 11
      end     %% if length(woo)
    end       %% for wn
    fprintf(1,'  >>> still need to %3i chunks out of %3i for gas %2i \n',iNotMade,iCnt,gid)
  end         %% for gid
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' >>>>>>>>>>>>>> ')
disp('size of files : still not made vs all to be made ')
morer = ['! more gN_ir_list_notdone.txt | wc -l; more gN_ir_list_all.txt | wc -l'];
eval(morer);
disp(' >>>>>>>>>>>>>> ')
