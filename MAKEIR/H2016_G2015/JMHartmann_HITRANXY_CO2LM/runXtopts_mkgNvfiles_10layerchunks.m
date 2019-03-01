%% this simply does all wavenumbers for gN

%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil
addpath /asl/matlib/science

outputdir
home = pwd;

%gid = input('Enter gasID : ');
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
JOB = 2;
gid = JOB;
if gid == 1
  error('not for WV')
end

if gid >= 51
  error('not for XSEC gases')
end

%{
%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
%% load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat
%}

nbox = 5;
pointsPerChunk = 10000;
freq_boundaries

figure(1); clf
addpath /home/sergio/SPECTRA
[iYes,line] = findlines_plot(wn1-dv,wn2+dv,gid);

if dv >= 25
  [iYes,line] = findlines_plot(fmin-dv,fmax+dv,gid);
else
  [iYes,line] = findlines_plot(fmin-25,fmax+dv+25,gid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);

  if dv >= 25
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
  else
    woo = find(line.wnum >= wn-25 & line.wnum <= wn+dv+25);
  end

  dv2 = max(dv,25);
  woo = find(line.wnum >= wn-dv2 & line.wnum <= wn+dv+dv2);

  if length(woo) >= 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%

cder = ['cd ' home]; eval(cder);

slash = findstr(dirout,'/');
if dirout(end) == '/'
  diroutXN = dirout(1:slash(end-1)-1);
else
  diroutXN = dirout(1:slash(end)-1);
end

outputdir;
dirout   = output_dir0;
diroutXN = output_dir0;
dirout   = output_dir5;
diroutXN = output_dir5;

fid = fopen('xg2_ir_list_notdone.txt','w');
for fmin = 605 : 25 : 2805
  iTCnt = 0;
  for pp = - 5 : 5
    iCnt = 0;  
    for iBlock = 1 : 10
      fin = [dirout '/'  num2str(iBlock) '/std' num2str(fmin) '_' num2str(gid) '_' num2str(pp+6) '_laychunk_' num2str(iBlock) '.mat'];
      ee = exist(fin);
      if ee > 0
        eeData((fmin-605)/25+1,pp+6,iBlock) = 1;
	iCnt = iCnt + 1;
      else
        %% 020188008 is an example     02 = gid    01880 = freq chunk     08 = Toffset
        eeData((fmin-605)/25+1,pp+6,iBlock) = 0;
	str = ['02' num2str(fmin,'%05d') num2str(pp+6,'%02d')];
	fprintf(fid,'%s\n',str);
      end      
    end
    eeData_allchunks((fmin-605)/25+1,pp+6) = iCnt;
    if iCnt == 10
      iTCnt = iTCnt + 1;
    end      
  end
  eeDataT((fmin-605)/25+1) = iTCnt;
  fx((fmin-605)/25+1) = fmin;
end

figure(1); plot(fx,eeDataT,'+-')
figure(2); imagesc(fx,1:11,eeData_allchunks'); colorbar
iBad = 0;
for ff = 1 : 89
  for pp = 1 : 11
    if eeData_allchunks(ff,pp) < 10
      iBad = iBad + 1;
      fprintf(1,'chunk %4i Toffset %2i only done %3i layerchunks instead of 10 layer chunks \n',fx(ff),pp,eeData_allchunks(ff,pp))
    end
  end
end
fclose(fid);
if iBad > 0
  error('xooox')
else
  disp('proceeding ...')
end

iShape = input('for LM ods enter (-1) voigt (0) first (+1) full : ');
if iShape == -1
  fout = [diroutXN '/abs.dat/voigt/'];
elseif iShape == 0
  fout = [diroutXN '/abs.dat/firstorder/'];
elseif iShape == +1
  fout = [diroutXN '/abs.dat/full/'];
end

ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  if iAns == 1
    mker = ['!mkdir -p ' fout];
    eval(mker);
  else
    error('cannot proceed');
  end
end

figure(2); clf;
fmin = wn1; 
fmin = iaChunk(1);
while fmin <= iaChunk(end)
  fmax = fmin + dv;

  iSave = 0;
  fr = [];
  k = zeros(10000,100,11);

  if iShape == -1
    foutY = [diroutXN '/abs.dat/voigt/'];
  elseif iShape == 0
    foutY = [diroutXN '/abs.dat/firstorder/'];
  elseif iShape == +1
    foutY = [diroutXN '/abs.dat/full/'];
  end
  fout = [foutY '/g' num2str(gid) 'v' num2str(fmin) '.mat'];
  if exist(fout) == 0
    fprintf(1,'processing %8.2f \n',fmin)

    for pp = -5 : +5
      iBlockCnt = 0;
      dvoigt = [];
      dfirst = [];
      dfull = [];
      
      for iBlock = 1 : 10
        ind = (1:10) + (iBlock-1)*10;
	fin = [dirout '/'  num2str(iBlock) '/std' num2str(fmin) '_' num2str(gid) '_' num2str(pp+6) '_laychunk_' num2str(iBlock) '.mat'];	
        lser = dir(fin);
        if length(lser) == 0
          clear lser
          lser.bytes = 0;
        end
        if lser.bytes > 50000
          loader = ['junk = load(''' fin ''');'];
          eval(loader);
	  dvoigt = [dvoigt; junk.dvoigt];
	  dfirst = [dfirst; junk.dfirst];
	  dfull  = [dfull ; junk.dfull];
	  w = junk.w;
	  iBlockCnt = iBlockCnt + 1;
	end
      end

      [mmfinal,nnfinal] = size(dfull);
      if iBlockCnt == 10 & mmfinal == 100
        iSave = iSave + 1;
        fprintf(1,'  gasID freq pp = %3i %6f %3i \n',gid,fmin,pp);
%        loader = ['load ' fin ];
%        eval(loader);
        fr = w;

        if iShape == -1
          d = dvoigt;
        elseif iShape == 0
          d = dfirst;
        elseif iShape == +1
          d = dfull;
        end
        d = max(d,0);

        k(:,:,pp+6) = d';
        if pp == 0
          figure(2); plot(fr,exp(-d(1,:))); hold on; pause(0.1); % disp('ret to continue');   
        end
      end
    end                 %% loop over temperature (1..11) pp

    if iSave == 11
      fprintf(1,'saving %s \n',fout);
      saver = ['save ' fout ' fr gid k ' ];
      eval(saver);
    else
      fprintf(1,'file(s) too small : gasID freq size = %3i %6i %8i \n',gid,fmin,lser.bytes);
    end  %% if
  else
    fprintf(1,'%s already exists .... \n',fout)
  end

  fmin = fmin + dv;
end                   %% loop over freq

figure(2); hold off;
