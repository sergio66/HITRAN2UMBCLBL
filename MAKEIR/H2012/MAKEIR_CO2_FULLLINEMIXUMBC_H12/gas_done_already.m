function  [freqchunk, numchunk, iCnt, iDone] = gas_done_already(gasid);

%% iCnt  = how many chunks need to be done
%% iDone = how many chunks HAVE been  done

iHitLinesFound = 0;

figure(1); clf

addpath /home/sergio/SPECTRA
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

iZeroCnt = 0;
oo = [];

homedir = pwd;

nbox = 5; pointsPerChunk = 10000;

gid = gasid;
freq_boundaries
fA = wn1; fB = wn2; df = dv;
dir0 = dirout;

%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /home/sergio/SPECTRA
[iYes,line] = findlines_plot(wn1-dv,wn2+dv,gid);

iCnt = 0;
for wn = wn1 : dv : wn2
  woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
  if length(woo) >= 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
%gasid = input('enter gas id : ');

if gasid == 1
  error('not for WV')
else
  iso = [-1];
end

lines = show_vis_ir_lines_wavenumber(2012,7,gasid);

[mm,nn] = size(lines.iso);
if nn > 0
  figure(1);
  semilogy(lines.wnum,lines.stren);
  pause(0.1)
  oo  = find(lines.wnum >= fA-df   &  lines.wnum <= fB+df);
  if length(oo) > 0
    semilogy(lines.wnum(oo),lines.stren(oo));
    axis([fA-df fB+df min(lines.stren(oo)) max(lines.stren(oo))])
    fprintf(1,'found %5i lines between %4i & %4i cm-1 \n',length(oo),fA,fB)
    fchunk = 0;
    for ff = fA : df : fB
      fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
      hitlinesfound(fchunk) = 0;
      boof = find(lines.wnum >= ff &  lines.wnum <= ff+df);
      hitlinesfound(fchunk) = length(boof);
      if length(boof) == 0
        boof2 = find(lines.wnum >= ff-df &  lines.wnum <= ff+2*df);  
        hitlinesfound(fchunk) = -length(boof2);  %%% << indicates this could be a chunk ie on the edge
      end
    end
  else
    fchunk = 0;
    for ff = fA : df : fB
      fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
      hitlinesfound(fchunk) = 0;
    end  
  end
else
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    hitlinesfound(fchunk) = 0;
  end  
end

cder = ['cd ' dir0]; eval(cder);

clear foundname
jj = 0;
jjx = 0;

if gasid > 1 
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      fname = ['std' num2str(ff) '_' num2str(gasid) '_' num2str(kk) '.mat'];
      dirr = dir(fname);
      if length(dirr) == 1 & dirr.bytes > 0
        jjx = +1;
        jj = jj + 1;
        ifound = ifound + 1;
        foundname(jj).name = dirr.name;
        foundname(jj).date = dirr.date;
      elseif length(dirr) == 1 & dirr.bytes == 0
        % comment out this ZERO file size warning
        % fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
        iZeroCnt = iZeroCnt + 1;
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

%% water, all isotopes
if gasid == -3
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['stdH2Oall' num2str(ff) '_' num2str(gasidx) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
        elseif length(dirr) == 1 & dirr.bytes == 0
          % comment out this ZERO file size warning
          % fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
          iZeroCnt = iZeroCnt + 1;
        end
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

%% heavy water
if gasid == -1
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['stdHDO' num2str(ff) '_' num2str(abs(gasid)) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
        elseif length(dirr) == 1 & dirr.bytes == 0
          % comment out this ZERO file size warning
          % fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
          iZeroCnt = iZeroCnt + 1;
        end
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

%% water without HDO
if gasid == +1
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['stdH2O' num2str(ff) '_' num2str(gasid) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
        elseif length(dirr) == 1 & dirr.bytes == 0
          % comment out this ZERO file size warning
          % fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
          iZeroCnt = iZeroCnt + 1;
        end
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

gasidx = gid;

yesno = [];
cder = ['cd ' homedir]; eval(cder);
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);
if  jj > 0
  % comment out this tedious print of every file/date/time
  % for kk = 1 : jj
  %   fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
  % end
  for mm = 1 : length(freqchunk)
    if abs(hitlinesfound(mm)) > 0 & abs(gasidx) == 1 & numchunk(mm) == 55
      yesno(mm) = +1;  %% all 55 done for water
    elseif abs(hitlinesfound(mm)) > 0 & gasidx > 1 & numchunk(mm) == 11
      yesno(mm) = +1;  %% all 11 done for gid
    elseif abs(hitlinesfound(mm)) > 0 & abs(gasidx) == 1 & numchunk(mm) < 55
      yesno(mm) = -1;  %% less than 55 done for water
    elseif abs(hitlinesfound(mm)) > 0 & gasidx > 1 & numchunk(mm) < 11
      yesno(mm) = -1;  %% less than 11 done for gid
    elseif abs(hitlinesfound(mm)) == 0 & abs(gasidx) == 1 & numchunk(mm) == 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif abs(hitlinesfound(mm)) == 0 & gasidx > 1 & numchunk(mm) == 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif abs(hitlinesfound(mm)) == 0 & abs(gasidx) == 1 & numchunk(mm) & ...
      numchunk(mm) > 0 & numchunk(mm) < 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
    elseif abs(hitlinesfound(mm)) == 0 & gasidx > 1 & ...
      numchunk(mm) > 0 & numchunk(mm) < 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
%    elseif abs(hitlinesfound(mm)) == 0 & numchunk(mm)  0
%      %% no need to worry, no lines here, but chunk may overlap with
%      %%lines that are close to the boundaries; may want to check this!
%      yesno(mm) = 0;
    else
      yesno(mm) = 0;
    end
  end

  %% now print the results
  disp(' ')
  disp('gid  freqchunk hitlinesfound numchunk chunkdone(Y/N/M)')
  disp('------------------------------------------------------')

  for ii = 1 : iCnt
    woo = find(freqchunk == iaChunk(ii));  
    common(ii) = woo;
  end
  bwop = setdiff(1:length(freqchunk), common);
  if sum(abs(yesno(bwop))) > 0
    error(' >>>>>>>>>> WARNING : somehow found different chunk files made by run8, than what we expect from findlines_plot');
  end

  %% [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno]'
  [gasid*ones(1,length(common)); freqchunk(common); hitlinesfound(common); numchunk(common); yesno(common)]'
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

end

if iZeroCnt > 0
  fprintf(1,'  ---> WARNING found %4i files of size 0 bytes .... \n',iZeroCnt);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(oo) > 0 & jjx == 0
  %% lines have been found in eg 2830 - 3530 cm-1 for this gas, but so far NOTHING completed
  for kk = 1 : jj
    fprintf(1,'%4i  %3i %s %s \n',kk,gasid,foundname(kk).name,foundname(kk).date);
  end

  disp('gid  freqchunk hitlinesfound numchunk')
  [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk]'
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

  fprintf(1,' WARNING : gasid %3i has %5i lines w/in %4i,%4i cm-1 \n',gasid,length(oo),fA,fB)
  fprintf(1,'           but ZERO files found \n')

  for ii = 1 : iCnt
    woo = find(freqchunk == iaChunk(ii));
    iaChunkNum(ii) = numchunk(woo);
    if hitlinesfound(woo) > 0 | hitlinesfound(woo) < 0
      iHitLinesFound = iHitLinesFound + 1;
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if jjx > 0
  %% lines have been found in eg 2830 - 3530 cm-1 for this gas, and SOMETHINGs already completed
  iDone = 0;
  iHitLinesFound = 0;
  for ii = 1 : iCnt
    woo = find(freqchunk == iaChunk(ii));
    iaChunkNum(ii) = numchunk(woo);
    if yesno(woo) == 1
      iDone = iDone + 1;
      iaChunkDone(ii) = +1;
    else
      iaChunkDone(ii) = -1;
    end

    if hitlinesfound(woo) > 0 | hitlinesfound(woo) < 0
      iHitLinesFound = iHitLinesFound + 1;
    end

  end
  figure(2); clf; bar(iaChunk,iaChunkNum);
else
  iDone = 0;
end
fprintf(1,'%2i chunks in this band; potentially %2i for gasid %2i, completed %2i \n',iCnt,iHitLinesFound,gasid,iDone)
iCnt = iHitLinesFound;   %% !!

fprintf(1,'last file looked for = %s -->  %s \n',dir0,fname)
