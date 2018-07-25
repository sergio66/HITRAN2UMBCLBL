%% file will contain AB CDEFG HI JKL  which are gasID, wavenumber, temp offset  layer
%%                   12 34567 89 012
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999, layer 001:100

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

home = pwd;

%gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
%if gids == -1
%  iA = input('Enter Start and Stop gasIDs eg [2 42] : ');
%  gids = iA(1) : iA(2);
%end

%gids = setdiff(gids,[30 35 42]);  %% those 3 gases NOT present in breakout of HITRAN

gids = 12;

oo = find(gids > 42);
if length(oo) > 0
  ii = input('oops, you seem to have entered gasIDs > 42; no profiles for that, so rming those, ok (-/+ 1) ? ');
  if ii < 0
    error('hmm, so whaddya wanna do if no profile, huh??????')
  else
    gids = setdiff(gids,43:max(gids));
  end
end

fid = fopen('g12_list_layers.txt','w');
nbox = 5;
pointsPerChunk = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : length(gids)
  gid = gids(ii);

  fprintf(1,'gasID = %2i \n',gid);

  if dv >= 25
    [iYes,line] = findlines_plot(fmin-dv,fmax+dv,gid);
  else
    [iYes,line] = findlines_plot(fmin-25,fmax+dv+25,gid);
  end

  %disp('<RET> to continue');
  pause(0.1)

  cder = ['cd ' home]; eval(cder);

  freq_boundaries

  %% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
  %%                   12 34567 89
  %% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

  fdir = [dirout '/g' num2str(gid) '.dat/LAYERS/'];
  fdir = [dirout];
  ee = exist(fdir,'dir');
  if ee == 0
    fprintf(1,'%s does not exist \n',fdir);
    % iYes = input('make dir??? (-1/+1) : ');
    iYes = 1
    if iYes > 0
      fprintf(1,'>> making %s \n',fdir);
      mker = ['!mkdir -p ' fdir];
      eval(mker);
    end
  end

  iCnt = 0;
  for gg = gid : gid
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
        fprintf(1,'    for gid = %2i found %4i lines in chunk %8.2f \n',gid,length(woo),wn);
        for tt = 1 : 11
          for ll = 1 : 100
            strx = [num2str(floor(wn),'%03d') '.' num2str((wn-floor(wn))*10,'%01d')];
            str = [num2str(gg,'%02d') strx num2str(tt,'%02d') num2str(ll,'%03d')];
            fprintf(fid,'%s\n',str);
          end
        end
      end
    end
  fprintf(1,'    >>> need to make %3i chunks for gas %2i \n',iCnt,gid)
  end

  iaWhichGas(ii)  = gid;
  iaNumChunks(ii) = iCnt;

end
fclose(fid);

figure(1); clf; plot(iaWhichGas,iaNumChunks,'o-'); title('Number of Chunks needed vs GasID');
