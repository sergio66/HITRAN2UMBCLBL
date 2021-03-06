function  [freqchunk, numchunk] = gas_done_already_g1_OR_g103(gasid,iRmEmptyFiles);

if nargin == 1
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
  %dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
  %dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/';
  %dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat';   
elseif gasid == 103
  freq_boundaries_g103
  %dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g103.dat/';
  %dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g103.dat';
elseif gasid == 110
  freq_boundaries_g1
  %dirout = '/spinach/s6/sergio/RUN8_NIRDATABASE/IR_2405_3005_WV/';
  %dirout = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_2405_3005_WV/g1.dat/';
  %dirout = '/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat';     
else
  error('hmm ... not doing ALL isotoptes for H2016')
end

fA = wn1; fB = wn2; df = dv;
dir0 = dirout;

dir0 = dirout;

figure(1); clf
%gasid = input('enter gas id : ');

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
lines = show_vis_ir_lines_wavenumber_water(2016,7,gasidx,iso);

[mm,nn] = size(lines.iso);
if nn > 0
  figure(1);
  semilogy(lines.wnum,lines.stren);
  pause(0.1)
  oo = find(lines.wnum >= fA-df &  lines.wnum <= fB+df);
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

%% water, all isotopes
if gasid == 110
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
if  jj > 0
  for kk = 1 : jj
   fprintf(1,'%4i %3i %s %s\n',kk,gasid,foundname(kk).name,foundname(kk).date);
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
  [gasid*ones(1,length(freqchunk)); freqchunk; hitlinesfound; numchunk; yesno]'
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
