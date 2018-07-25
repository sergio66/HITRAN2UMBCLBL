function  [freqchunk, numchunk, nout, yesno, lastday] = gas_done_already(gasid);

%% numchunk  = number of files done per chunk
%% freqchunk = freq chunks
%% nout        = number of lines
%% yesno     = are the chunks done????? (1=yes,-1=no, 0 = no need)

iZeroCnt = 0;
oo = [];

homedir = pwd;

nbox = 5; pointsPerChunk = 10000; iWhichBand = 5;
freq_boundaries
fA = wn1; fB = wn2; df = dv;
dir0 = dirout;

figure(1); clf
%gasid = input('enter gas id : ');

yesno = [];

lines = show_vis_ir_lines_wavenumber_individualgas(iWhichBand,gasid);
[mm,nn] = size(lines.iso);
nn = length(lines.iso);
nout = nn;  %% this is temporary, for gid 7,22 which sometimes do continuum w/ no lines
if nn > 0
  figure(1);
  semilogy(lines.wnum,lines.stren);
  pause(0.1)
  oo = find(lines.wnum >= fA-df &  lines.wnum <= fB+df);
  nout = length(oo);
  if length(oo) > 0
    if length(oo) > 1
      semilogy(lines.wnum(oo),lines.stren(oo));
      axis([fA-df fB+df min(lines.stren(oo)) max(lines.stren(oo))])
    else
      semilogy(lines.wnum(oo),lines.stren(oo),'o');
      axis([fA-df fB+df 0.999*min(lines.stren(oo)) max(lines.stren(oo))*1.001])
    end
    fprintf(1,'found %5i lines between %4i & %4i cm-1 \n',length(oo),fA,fB)
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

cder = ['cd ' dir0 '/g' num2str(gasid) '/']; eval(cder);

clear foundname
jj = 0;
jjx = 0;

if gasid > 1
  thelastday = -1;
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
        foundname(jj).day = str2num(dirr.date(1:2));
        thelastday = max(dirr.datenum,thelastday);
      elseif length(dirr) == 1 & dirr.bytes == 0
        fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
        iZeroCnt = iZeroCnt + 1;
        end
      end
    numchunk(fchunk) = ifound;
    end 
  end

if gasid == 1
  thelastday = -1;
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['std' num2str(ff) '_' num2str(gasid) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
          foundname(jj).day = str2num(dirr.date(1:2));
          thelastday = max(dirr.datenum,thelastday);
        elseif length(dirr) == 1 & dirr.bytes == 0
          fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
          iZeroCnt = iZeroCnt + 1;
          end
        end
      end
    numchunk(fchunk) = ifound;
    end 
  end

cder = ['cd ' homedir]; eval(cder);
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);

if  jj > 0
  blonk = [1 2 jj-1 jj]; blonk = unique(blonk);
  konk = find(blonk <= jj & blonk > 0); blonk = unique(sort(blonk(konk)));
  for kkk = 1 : length(blonk)
    kk = blonk(kkk);
   fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
   end
  for mm = 1 : length(freqchunk)
    if hitlinesfound(mm) > 0 & gasid == 1 & numchunk(mm) == 55
      yesno(mm) = +1;  %% all 55 done for water
    elseif hitlinesfound(mm) > 0 & gasid > 1 & numchunk(mm) == 11
      yesno(mm) = +1;  %% all 11 done for gid
    elseif hitlinesfound(mm) > 0 & gasid == 1 & numchunk(mm) < 55
      yesno(mm) = -1;  %% less than 55 done for water
    elseif hitlinesfound(mm) > 0 & gasid > 1 & numchunk(mm) < 11
      yesno(mm) = -1;  %% less than 11 done for gid
    elseif hitlinesfound(mm) == 0 & gasid == 1 & numchunk(mm) == 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif hitlinesfound(mm) == 0 & gasid > 1 & numchunk(mm) == 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
    elseif hitlinesfound(mm) == 0 & gasid == 1 & numchunk(mm) & ...
      numchunk(mm) > 0 & numchunk(mm) < 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
    elseif hitlinesfound(mm) == 0 & gasid > 1 & ...
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
  disp(' ')
  disp('gid  freqchunk hitlinesfound numchunk chunkdone(Y/N/M)')
  disp('------------------------------------------------------')
  bonk = [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno];
  fprintf(1,'%3i    %8.5f     %6i        %2i          %2i \n',bonk);
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));
  end

if iZeroCnt > 0
  fprintf(1,'  ---> WARNING found %4i files of size 0 bytes .... \n',iZeroCnt);
  end

if length(oo) > 0 & jjx == 0
  yesno = -1 * ones(size(numchunk));
  blonk = [1 2 jj-1 jj]; blonk = unique(blonk);
  konk = find(blonk <= jj); blonk = unique(sort(blonk(konk)));
  if jj >= 2
    for kkk = 1 : length(blonk)
      kk = blonk(kkk);
      lonk = [kk gasid foundname(kk).name foundname(kk).date];
      fprintf(1,'%4i  %3i %s %s \n',lonk);
      end
    end
  disp('gid  freqchunk hitlinesfound numchunk chunkdone(Y/N/M)')
  disp('------------------------------------------------------')
  bonk = [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno];
  fprintf(1,'%3i    %8.5f     %6i        %2i          %2i\n',bonk);
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

  lonk = [gasid length(oo) fA fB];
  fprintf(1,' WARNING : gasid %3i has %5i lines w/in %8.4f,%8.4f cm-1 \n',lonk)
  fprintf(1,'           but ZERO files found \n')
  end

lastday = thelastday;