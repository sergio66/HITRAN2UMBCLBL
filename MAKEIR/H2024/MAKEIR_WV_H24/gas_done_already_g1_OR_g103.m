function  [freqchunk, numchunk, linesx] = gas_done_already_g1_OR_g103(gasid,iYear,iRmEmptyFiles);

if nargin == 1
  %% default : if you find empty files, do not delete
  iRmEmptyFiles = -1;
  iYear = 2024;
elseif nargin == 2
  %% default : if you find empty files, do not delete
  iRmEmptyFiles = -1;  
end

iZeroCnt = 0;
oo = [];

homedir = pwd;

addpath /home/sergio/SPECTRA

%% ----------------------------------------------
%%         OLD                               NEW
%% ----------------------------------------------
%% gasid = +1 : g1    all isotopes but HDO : +1
%% gasid = -1 : g103  HDO                  : +103
%% gasid = -3 : g110  all isotopes         : +110
%% ----------------------------------------------

nbox = 5; pointsPerChunk = 10000;
%% dirout is correctly set in freq_boundaries_gX
if gasid == 1
  freq_boundaries_g1
elseif gasid == 103
  freq_boundaries_g103
elseif gasid == 110
  freq_boundaries_g110
else
  error('hmm ... not doing ALL isotoptes for H2020 or H2024 etc')
end

fA = wn1; fB = wn2; df = dv;
dir0 = dirout;

dir0 = dirout;

figure(1); clf
%gasid = input('enter gas id : ');

iCheck = -1;
if iCheck > 0
  iso110 = [1 2 3 4 5 6 7];
  iso001 = [1 2 3   5 6 7];
  iso103 = [      4      ];
  
  gasidx = 1;
  lines110 = show_vis_ir_lines_wavenumber_water(iYear,7,gasidx,iso110);
  lines103 = show_vis_ir_lines_wavenumber_water(iYear,7,gasidx,iso103);
  lines001 = show_vis_ir_lines_wavenumber_water(iYear,7,gasidx,iso001);
  disp('[lines001.linct lines103.linct lines110.linct]')
  [lines001.linct lines103.linct lines110.linct]
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if gasid == 110        %% all iso
  iso = [1 2 3 4 5 6 7];
elseif gasid == 103   %% HDO
  iso = 4;
elseif gasid == 1   %% all but HDO
  iso = [1 2 3   5 6 7];
else
  gasid
  error('unkown gasid (need 110,103,1)')
end

gasidx = 1;
lines = show_vis_ir_lines_wavenumber_water(iYear,7,gasidx,iso);

[mm,nn] = size(lines.iso);
if nn > 0
  figure(1);
  semilogy(lines.wnum,lines.stren);
  pause(0.1)
  oo = find(lines.wnum >= fA-df &  lines.wnum <= fB+df);
  if length(oo) > 0

    linesx.wnum   = lines.wnum(oo);
    linesx.stren  = lines.stren(oo);
    linesx.iso    = lines.iso(oo);
    linesx.tprob  = lines.tprob(oo);
    linesx.abroad = lines.abroad(oo);
    linesx.sbroad = lines.sbroad(oo);        
    linesx.els    = lines.els(oo);
    linesx.abcoef = lines.abcoef(oo);
    linesx.tsp    = lines.tsp(oo);
    linesx.flag   = lines.flag(oo);
    linesx.swus   = lines.swus(oo);
    linesx.swls   = lines.swls(oo);
    linesx.bslq   = lines.bslq(oo,:);
    linesx.uslq   = lines.uslq(oo,:);        
    linesx.ilsgq  = lines.ilsgq(:,oo);
    linesx.iusgq  = lines.iusgq(:,oo);        
    linesx.ref    = lines.ref(oo,:);
    linesx.ai     = lines.ai(oo,:);    
    linesx.linct  = length(oo);
    linesx.gasid  = lines.gasid(oo);
    
    semilogy(lines.wnum(oo),lines.stren(oo));
    axis([fA-df fB+df min(lines.stren(oo)) max(lines.stren(oo))])
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

fprintf(1,'cd to %s \n',dir0)
cder = ['cd ' dir0]; eval(cder);

clear foundname
jj = 0;
jjx = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
if gasid == 11111
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
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% water, all isotopes
if gasid == 110
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['stdH2OALL' num2str(ff) '_' num2str(gasidx) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
        elseif length(dirr) == 1 & dirr.bytes == 0
          fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
	  if iRmEmptyFiles > 0
	    rmer = ['!/bin/rm ' fname];
	    fprintf(1,'removing %s \n',rmer)
	    eval(rmer)
	  end	  
          iZeroCnt = iZeroCnt + 1;
        end
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

%% heavy water
if gasid == 103
  fchunk = 0;
  for ff = fA : df : fB
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['stdHDO' num2str(ff) '_' num2str(abs(gasid)) '_' num2str(kk)];
        fname = ['stdHDO' num2str(ff) '_' num2str(1) '_' num2str(kk)];	
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1 & dirr.bytes > 0
          jjx = +1;
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          foundname(jj).date = dirr.date;
        elseif length(dirr) == 1 & dirr.bytes == 0
          fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
	  if iRmEmptyFiles > 0
	    rmer = ['!/bin/rm ' fname];
	    fprintf(1,'removing %s \n',rmer)
	    eval(rmer)
	  end	  
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
          fprintf(1,'warning found file %s but size = 0 bytes! \n',fname)
	  if iRmEmptyFiles > 0
	    rmer = ['!/bin/rm ' fname];
	    fprintf(1,'removing %s \n',rmer)
	    eval(rmer)
	  end
          iZeroCnt = iZeroCnt + 1;
        end
      end
    end
    numchunk(fchunk) = ifound;
  end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ----------------------------------------------
%%         OLD                               NEW
%% ----------------------------------------------
%% gasid = +1 : g1    all isotopes but HDO : +1
%% gasid = -1 : g103  HDO                  : +103
%% gasid = -3 : g110  all isotopes         : +110
%% ----------------------------------------------

pwd

cder = ['cd ' homedir]; eval(cder);
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);
iLocalPrint = -1;
if  jj > 0
  if iLocalPrint > 0
    for kk = 1 : jj
      fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
    end
  end

  for mm = 1 : length(freqchunk)
    if hitlinesfound(mm) > 0 & numchunk(mm) == 55
      yesno(mm) = +1;  %% all 55 done for water

    elseif hitlinesfound(mm) > 0 & numchunk(mm) < 55
      yesno(mm) = -1;  %% less than 55 done for water
      
    %elseif hitlinesfound(mm) > 0 & gasidx > 1 & numchunk(mm) == 11
    %  yesno(mm) = +1;  %% all 11 done for gid
      
    %elseif hitlinesfound(mm) > 0 & gasidx > 1 & numchunk(mm) < 11
    %  yesno(mm) = -1;  %% less than 11 done for gid
      
    elseif hitlinesfound(mm) == 0 & numchunk(mm) == 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
      
    elseif hitlinesfound(mm) == 0 & numchunk(mm) == 11
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = +1;
      
    elseif hitlinesfound(mm) == 0 numchunk(mm) > 0 & numchunk(mm) < 55
      %% no need to worry, no lines here, but chunk may overlap with
      %%lines that are close to the boundaries
      yesno(mm) = -1;
      
    elseif hitlinesfound(mm) == 0 & numchunk(mm) > 0 & numchunk(mm) < 11
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
  junk = [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno]';
  fprintf(1,'%5i  %5i  %5i %5i  %5i \n',junk');
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

  figure(2); plot(freqchunk,numchunk,'+'); title(num2str(gasid));
    xlabel('Wavenumber chunk'); ylabel('Numchunk done out of 55');

  disp('doing chunks from 605-630   all the way to   230-2855, which is 90 chunks')
  junk = sum(numchunk)/(5*11*90) * 100;
  fprintf(1,'found %4i chunks done (5 pp x 11 Toffset) out of %4i = %12.7f percent \n',sum(numchunk),5*11*90,junk)
  
end

if iZeroCnt > 0
  fprintf(1,'  ---> WARNING found %4i files of size 0 bytes .... \n',iZeroCnt);
end

if length(oo) > 0 & jjx == 0
  for kk = 1 : jj
    fprintf(1,'%4i  %3i %s %s \n',kk,gasid,foundname(kk).name,foundname(kk).date);
  end
  disp('gid  freqchunk hitlinesfound numchunk')
  junk = [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk]';
  fprintf(1,'%5i  %5i  %5i %5i  %5i \n',junk');
  fprintf(1,'found %5i lines between fA & fB cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));

  fprintf(1,' WARNING : gasid %3i has %5i lines w/in %4i,%4i cm-1 \n',gasid,length(oo),fA,fB)
  fprintf(1,'           but ZERO files found \n')
end
