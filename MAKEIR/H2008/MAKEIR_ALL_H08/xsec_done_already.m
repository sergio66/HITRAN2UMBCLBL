function iYes = xsec_done_already(gasid)

addpath /home//sergio/HITRAN2UMBCLBL/READ_XSEC

iZeroCnt = 0;
oo = [];

homedir = pwd;

nbox = 5; pointsPerChunk = 10000;
freq_boundaries
fA = wn1; fB = wn2; df = dv;
dir0 = [dirout '/g' num2str(gasid) '.dat/'];

%gasid = input('enter gas id : ');

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
        fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
        iZeroCnt = iZeroCnt + 1;
        end
      end
    numchunk(fchunk) = ifound;
    end 
  end

load /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08/xsecdata_chunks.mat
cder = ['cd ' homedir]; eval(cder);
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);
if  jj > 0
  for kk = 1 : jj
    fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
    end
  for mm = 1 : length(freqchunk)
    fmin = freqchunk(mm);     fmax = freqchunk(mm) + df;
    %[iYes,gf] = findxsec_plot(fmin,fmax,gasid); 
    iYes = save_xsecdata.found(gasid-51+1,mm);
    if iYes == 0
      hitlinesfound(mm) = 0;
    else
      hitlinesfound(mm) = 100;
      end
    if numchunk(mm) == 11
      yesno(mm) = +1;  %% all 11 done for gid
    elseif numchunk(mm) < 11
      yesno(mm) = -1;  %% less than 11 done for gid
      end
    end
  disp(' ')
  disp('gid  freqchunk hitlinesfound numchunk chunkdone(Y/N/M)')
  disp('------------------------------------------------------')
  [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno]'
  fprintf(1,'found %5i "lines" between fA & fB cm-1 = %3i chunks \n',sum(hitlinesfound),sum(hitlinesfound)/100)
%  figure(1); title(num2str(gasid));
  figure(2); plot(freqchunk,hitlinesfound,'ro-','MarkerSize',2); 
             title(num2str(gasid));
  figure(3); bar(freqchunk,numchunk,'r'); title(num2str(gasid));
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
  fprintf(1,'found %5i lines between fA & fB cm-1 = %3i chunks \n',sum(hitlinesfound),sum(hitlinesfound)/100)
%  figure(1); title(num2str(gasid));

  fprintf(1,' WARNING : gasid %3i has %5i lines w/in %4i,%4i cm-1 \n',gasid,length(oo),fA,fB)
  fprintf(1,'           but ZERO files found \n')
  end

  end