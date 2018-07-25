nbox = 5;
pointsPerChunk = 10000;

time_pause = ceil(rand*100);
time_pause = 1;
pause(time_pause)

freq_boundaries

hpcfname = '2';
clear gases
dash = findstr(hpcfname,'_');
if length(dash) == 0
  gases = str2num(hpcfname);
elseif length(dash) == 1
  gases(1) = str2num(hpcfname(1:dash-1));
  gases(2) = str2num(hpcfname(dash+1:length(hpcfname)));
else
  error('error in hpcfname')
  end

woof = isfinite(gases);
if sum(woof) ~= length(gases)
  error('error2 in hpcfname')
  end

if length(gases) == 1
  %% user forgot to put in start chunk
  gases = gases(1);
  startchunk = wn1;
else
  startchunk = gases(2);
  gases = gases(1);
  end
fprintf(1,'processing gasid with startchunk = %3i %8.4f \n',gases,startchunk);

wn1 = startchunk;

load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

ppmin = -5; ppmax = +5;
ppmin = -0; ppmax = +0;
iaLayerList = 1 : 100;       %% all 100 layers

i2007 = -1; %% use 2010 code
i2007 = +1; %% use 2007 code

iDebug = -1;
iDebug = +1;
if iDebug > 0
  iaLayerList = [05 11 21 40]; %% masiello layers
  ppmin = 0;   ppmax = 0;      %% toffset
  wn1 = 605;
  wn2 = 805;
%  wn2 = 605;
  disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
  disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
  disp(' ')
  disp('  doing limited iaLay (5,11,21,40)')
  disp('  doing limited freqs (605-805) and Toffset (0 only)')
  disp(' ')
  disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
  disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
  end

fmin = wn1; 
fmax = wn2; 

cd /home/sergio/SPECTRA


%% extra wavenumber pts originally automatically done in 
%% /home/sergio/SPECTRA/JMHARTMANN_2007/LM_PQR_CO2_2.0/Source2010/Total_program_win.f.orig
sgmin = wn1;
sgmax = (wn2+25);

%% but now add them here, to make the "input" compatible with
%%  cd /home/sergio/SPECTRA/JMHARTMANN_2010/Source/Total_program_win.f
sgmin = wn1      - 0.0005*2;
sgmax = (wn2+25) + (-3)*0.0005;

iType = 20 * ones(100,1);    %%% see /home/sergio/KCARTA/INCLUDE/pre_defined.param var = kaTag
varray = sgmin : topts.ffin : sgmax;
narray = length(varray) * ones(100,1);

%sgmin = wn1;
%sgmax = wn2 + dv;
dsg = topts.ffin;

dirout0 = dirout;

gg = 1;
gasid = gases(gg);  
if gasid ~= 2
  error('should run WATER or OTHER GASES separately')
  end

for pp = ppmin : ppmax
  gq = gasid;
  tprof = refpro.mtemp + pp*10;
  if i2007 == -1
    %%2010 
    profile100 = ...
      [(1:100)' refpro.mpres refpro.gpart(:,gq) zeros(size(tprof)) tprof refpro.gamnt(:,gq) narray iType]';
    profile100 = ...
      [(1:100)' refpro.mpres refpro.gpart(:,gq) refpro.gpart(:,1)  tprof refpro.gamnt(:,gq) narray iType]';
  else
    %% 2007
    profile100 = [(1:100)' refpro.mpres refpro.gpart(:,gq) tprof refpro.gamnt(:,gq)]';
    end

  for llx = 1 : length(iaLayerList)
    ll = iaLayerList(llx);
    if i2007 == -1
      %% 2010   
      % print *,'units : cm-1  cm-1  cm-1  atm   atm   atm K    kilomoles/cm2 lenarray iType'
      % print *,'Enter : sgmin sgmax dsg   pTot  pCO2  pWV Temp qamt          len      iType : '
      profilex = profile100(:,ll);
      profile = [sgmin sgmax dsg profilex(2:8)'];
    else
      %% 2007
      % print *,'units : cm-1  cm-1  cm-1  atm   atm   K    kilomoles/cm2 '
      % print *,'Enter : sgmin sgmax dsg   pTot  pCO2  Temp qamt          : '
      profilex = profile100(:,ll);
      profile = [sgmin sgmax dsg profilex(2:5)'];
      end

    if i2007 == -1
      %% 2010
      cd /home/sergio/SPECTRA/JMHARTMANN_2010/Source
    else
      %% 2007
      cd /home/sergio/SPECTRA/JMHARTMANN_2007/LM_PQR_CO2_2.0/Source2010
      end

    fip = ['IPFILES/std_gx' num2str(gq) '_' num2str(pp+6) '_' num2str(ll)];
    fid = fopen(fip,'w');
    if i2007 == -1
      %% 2010
      fprintf(fid,'%20.16e %20.16e %20.16e %20.16e %20.16e %20.16e %20.16e %20.16e %10i %10i\n',profile);
    else
      %% 2007
      fprintf(fid,'%10.8e %10.8e %10.8e %10.8e %10.8e %10.8e %10.8e \n',profile);
      end
    fclose(fid);

    dirout = [dirout0 '/g' num2str(gasid) '.dat/'];

    if i2007 == -1
      fout = [dirout '/std2010_' num2str(fmin)];
    else
      fout = [dirout '/std2007_' num2str(fmin)];
      end

    fouttxt = [fout '_' num2str(gq) '_' num2str(pp+6) '_' num2str(ll) '.txt'];
    fout    = [fout '_' num2str(gq) '_' num2str(pp+6) '_' num2str(ll) '.mat'];
    ee1 = exist(fout,'file');
    ee2 = exist(fouttxt,'file');
    if ee1 > 0 | ee2 > 0
      fprintf(1,'%s or %s already exists \n',fout,fouttxt);
      end

    %iYes = findlines_plot(fmin-25,fmax+25,gasid); 
    if gasid == 2 & ee1 == 0 & ee2 == 0
      toucher = ['!touch ' fout]; %% do this so other runs go to diff chunk 
      eval(toucher);
      fprintf(1,'g,w1,toffset,layer = %3i %6i %3i %3i\n',gasid,fmin,pp,ll);
      runner = ['!Total_program_win.x < ' fip ' > ' fouttxt];
      eval(runner);
      dd = load(fouttxt);
      [mmx,nnx] = size(dd);
      if i2007 == -1
        dd = dd(4:mmx,:);
      else
        dd = dd(2:mmx,:);
        end
      cd /home/sergio/SPECTRA
      boxcar_jmh(:,1) = boxint2_jmh(dd(:,1),nbox);
      boxcar_jmh(:,2) = boxint2_jmh(dd(:,2),nbox);
      boxcar_jmh(:,3) = boxint2_jmh(dd(:,3),nbox);
      boxcar_jmh(:,4) = boxint2_jmh(dd(:,4),nbox);
      saver = ['save ' fout ' boxcar_jmh']; eval(saver);
%      rmer = ['!/bin/rm ' fouttxt];         eval(rmer);
      clear dd
      cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08
      end

    end             %% loop over layers
  end                 %% loop over temperature (1..11)

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08
