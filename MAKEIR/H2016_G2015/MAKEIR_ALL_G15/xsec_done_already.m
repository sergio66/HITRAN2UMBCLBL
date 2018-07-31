function  [freqchunk, numchunk, iCnt, iDone, Sremain] = xsec_done_already(gasid,iKeepEmpty);

addpath /home/sergio/SPECTRA
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

%gasid = input('enter gas id : ');
if gasid == 1
  error('not for WV')
else
  iso = [-1];
end

if gasid < 51 | gasid > 81
  error('this is for xsec gases 51-81')
end

%% see loop_xsec_done_already.m
%% for ii = 51 : 81; xsec_done_already(ii); pause; end

Sremain = [];
iRemain = 0;

if nargin == 1
  iKeepEmpty = 1;
end

if iKeepEmpty < 0
  disp('WARNING : removinging empty files!!! ');
  %disp('ret to continue'); pause
  pause(0.1)
end

figure(1); clf

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
addpath /home/sergio/SPECTRA/READ_XSEC

iSwitchXsecDataBase = 0063;  %% originally we had H2016 for g51-63 and H2012 for g64-81
iSwitchXsecDataBase = 9999;  %% now we have       H2016 for g51-81
if gasid <= iSwitchXsecDataBase
  bands = list_bands(gasid,2015);
else
  bands = list_bands(gasid,2012);
end

clear lines
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = findxsec_plot_fast(wn,wn+dv,bands);
  if woo == 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
    lines.wnum(iCnt)  = wn + dv/2;
    lines.stren(iCnt) = 1 + 0.01*randn(1,1);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf

if iCnt > 0
  [mm,nn] = size(lines.wnum);
else
  nn = 0;
end  
if nn > 0 & iCnt > 0
  figure(1);
  plot(lines.wnum,lines.stren,'+');
  pause(0.1)

  for ii = 1 : length(bands.v1)
    line([bands.v1(ii) bands.v2(ii)],[1 1],'color','k');
  end

  oo = find(lines.wnum >= fA-df &  lines.wnum <= fB+df);
  if length(oo) > 0
    plot(lines.wnum(oo),lines.stren(oo),'+');
    axis([fA-df fB+df min(lines.stren(oo)) max(lines.stren(oo))])
    axis([max(fA-df,min(bands.v1)-df) min(fB+df,max(bands.v2)+df) min(lines.stren(oo)) max(lines.stren(oo))])
    ax = axis;

    for ii = 1 : length(bands.v1)
      line([bands.v1(ii) bands.v2(ii)],[1 1],'color','r','linewidth',2);
      line([bands.v1(ii) bands.v1(ii)],[ax(3) 1],'color','r','linewidth',2);
      line([bands.v2(ii) bands.v2(ii)],[ax(3) 1],'color','r','linewidth',2);
    end    
   
    fprintf(1,'found %5i "chunks" than need to be done between %4i & %4i cm-1 \n',length(oo),fA,fB)
    fchunk = 0;
    for ff = fA : df : fB
      fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
      hitlinesfound(fchunk) = 0;
      boof = find(lines.wnum >= ff &  lines.wnum <= ff+df);
      hitlinesfound(fchunk) = length(boof);
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

bytesMin = 0;
bytesMin = 1e4;

if gasid > 1 
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      fname = ['std' num2str(ff) '_' num2str(gasid) '_' num2str(kk) '.mat'];
      dirr = dir(fname);
      if length(dirr) == 1 & dirr.bytes > bytesMin
        jjx = +1;
        jj = jj + 1;
        ifound = ifound + 1;
        foundname(jj).name = dirr.name;
        foundname(jj).date = dirr.date;
      elseif length(dirr) == 1 & dirr.bytes < bytesMin
        fprintf(1,'warning found file %s but size = %8i bytes! \n',fname,dirr.bytes)
	Sjunk = [num2str(gasid,'%02d') num2str(ff,'%05d') num2str(kk,'%02d')];
	%fprintf(1,'  %s \n',Sjunk);
	iRemain = iRemain + 1;	
	Sremain{iRemain} = [num2str(gasid,'%02d') num2str(ff,'%05d') num2str(kk,'%02d')];
	if iKeepEmpty < 0
	  rmer = ['!/bin/rm ' fname];
	  eval(rmer);
	end
        iZeroCnt = iZeroCnt + 1;
      elseif length(dirr) == 0 & hitlinesfound(fchunk) > 0 
	iRemain = iRemain + 1;	
	Sremain{iRemain} = [num2str(gasid,'%02d') num2str(ff,'%05d') num2str(kk,'%02d')];              
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

gasidx = gid;

cder = ['cd ' homedir]; eval(cder);
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);
if  jj > 0
  for kk = 1 : jj
   fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
 end
  for mm = 1 : length(freqchunk)
    if hitlinesfound(mm) > 0 & abs(gasidx) == 1 & numchunk(mm) == 55
      yesno(mm) = +1;  %% all 55 done for water
    elseif hitlinesfound(mm) > 0 & gasidx > 1 & numchunk(mm) == 11
      yesno(mm) = +1;  %% all 11 done for gid
    elseif hitlinesfound(mm) > 0 & abs(gasidx) == 1 & numchunk(mm) < 55
      yesno(mm) = -1;  %% less than 55 done for water
    elseif hitlinesfound(mm) > 0 & gasidx > 1 & numchunk(mm) < 11
      yesno(mm) = -1;  %% less than 11 done for gid
    elseif hitlinesfound(mm) == 0 & abs(gasidx) == 1 & numchunk(mm) == 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif hitlinesfound(mm) == 0 & gasidx > 1 & numchunk(mm) == 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif hitlinesfound(mm) == 0 & abs(gasidx) == 1 & numchunk(mm) & ...
      numchunk(mm) > 0 & numchunk(mm) < 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
    elseif hitlinesfound(mm) == 0 & gasidx > 1 & ...
      numchunk(mm) > 0 & numchunk(mm) < 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
%    elseif hitlinesfound(mm) == 0 & numchunk(mm)  0
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

if length(oo) > 0 & jjx == 0
  for kk = 1 : jj
    fprintf(1,'%4i  %3i %s %s \n',kk,gasid,foundname(kk).name,foundname(kk).date);
  end
  disp('gid  freqchunk hitlinesfound numchunk')
  [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk]'
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

  fprintf(1,' WARNING : gasid %3i has %5i lines w/in %4i,%4i cm-1 \n',gasid,length(oo),fA,fB)
  fprintf(1,'           but ZERO files found \n')
end

if jjx > 0
  iDone = 0;
  for ii = 1 : iCnt
    woo = find(freqchunk == iaChunk(ii));
    iaChunkNum(ii) = numchunk(woo);
    if yesno(woo) == 1
      iDone = iDone + 1;
      iaChunkDone(ii) = +1;
    else
      iaChunkDone(ii) = -1;
    end
  end
  figure(2); clf; bar(iaChunk,iaChunkNum);
else
  iDone = 0;
end

fprintf(1,'Needed %2i chunks to be done for gasid %2i, completed %2i \n',iCnt,gasid,iDone)
