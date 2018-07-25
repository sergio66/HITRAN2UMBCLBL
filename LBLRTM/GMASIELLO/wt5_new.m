function wt5_new_levels(title,hbound,vbound,tbound,pbound,altitude,pressure,temperature,nmolinp,idmolinp,unitinp,wmol,aflag,CN,cnt_mul)

% This function write the TAPE5 file, the input file for LBLRTM (version 10).
%
% USAGE  wt5_new(title,hbound,vbound,tbound,pbound,altitude,pressure,temperature,nmolinp,idmolinp,unitinp,wmol,aflag,CN,cnt_mul)
%
%
% Input:
% tilte        profile name (string)
% hbound       = [H1 H2 ANGLE]
%                {H1} observer altitude = hbound(1)
%                {H2} end point altitude = hbound(2)
%                {ANGLE} zenith angle at H1 =0 for uplooking = 180 for downlooking = hbound(3)
% vbound       = [V1 V2], first and last wavenumber.
% tbound       surface temperature
% pbound       pressure grid
% altitude     input profile altitude
% pressure       "     "     pressure
% temperature    "     "     temperature
% nmolinp      input number of species
% idmolinp     id for the input species (H2O = 1, O3 = 3, ...)
% unitinp      unit for the input species ('C' = g/kg, 'A' = ppvm, ...) (string)
% wmol         input species profile
% mol_scal     NOT AVAILABLE molecules for which scaling will applied
%                            if 0 no scaling will applied
% hmol_scal    NOT AVAILABLE scaling type (' ' = No scaling, '0' = scaling factor is 0, '1' scaling applied 
%              directly to profile, )
% xmol_scal    NOT AVALAIBLE scaling factor
% aflag        AFGL climatology
% CN           Flag For Continuum (Default = 1). If CN==6, the code reads continuum multipliers cnt_mul
% cnt_mul      Continuum multipliers (7). 1. H2O Self, 2. H2O Foreing, 3. CO2, 4. O3, 5. O2, 6. N2, 7. Rayleigh.  
%
% function wt5_orig(title,hbound,vbound,tbound,pbound,altitude,pressure,temperature,nmolinp,idmolinp,unitinp,wmol,
%                   mol_scal,hmol_scal,xmol_scal,aflag,CN,cnt_mul)
% function wt5_new(title,hbound,vbound,tbound,pbound,altitude,pressure,temperature,nmolinp,idmolinp,unitinp,
%                  wmol,aflag,CN,cnt_mul)
%

if exist('CN','var') == 0
   CN = 1;
end
   
no_input_levels = length(altitude);
  fprintf(1,'your input levels profile is at %3i levels \n',no_input_levels)
  fprintf(1,'  min(pinput),max(pinput) = %8.4f %8.4f \n',min(pressure),max(pressure))
disp(' ')
no_boundaries   = length(pbound);
  fprintf(1,'you have provided %3i pressure boundaries at which to convert input levels profile to, and do  LBLRTM calcs \n',no_boundaries)
  fprintf(1,'  min(pbound),max(pbound) = %8.4f %8.4f \n',min(pbound),max(pbound))
disp(' ')
  
pressure    = reshape(pressure,no_input_levels,1);
altitude    = reshape(altitude,no_input_levels,1);
temperature = reshape(temperature,no_input_levels,1);
wmol        = reshape(wmol,no_input_levels,nmolinp);
fid         = fopen('TAPE5','w');
fprintf(fid,'$ %s \n',title);

% flags
HI=1; F4=1; AE=0; EM=1; SC=0; FI=0; PL=0; TS=0; AM=1; MG=0; LA=0; MS=0; XS=1; MPTS=0; NPTS=0;
fprintf(fid,' HI=%1i F4=%1i CN=%1i AE=%1i EM=%1i SC=%1i FI=%1i PL=%1i TS=%1i AM=%1i MG=%1i LA=%1i MS=%1i XS=%1i    %1i    %1i\n',...
[HI F4 CN AE EM SC FI PL TS AM MG LA MS XS MPTS NPTS]);

% continuum multipliers
% cnt_mul=[1 1 1 1 1 1 1];
if CN == 6
   fprintf(fid,'%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f \n',cnt_mul);
end

% wavenumber bounds and nmol_scal
% string(1:105)=' ';
% string(1:20)=sprintf('%10.3f%10.3f',[vbound(1) vbound(2)]);
% string(end:end)=num2str(mol_max);
% fprintf(fid,'%s\n',[string]);
% clear string;
% string(1:38)=' ';
% for i=1:length(mol_scal)
%     string(mol_scal(i):mol_scal(i))=hmol_scal(mol_scal(i):mol_scal(i));
% end
% fprintf(fid,'%s\n',[string]);
% clear string
% string(1:105)=' ';
% scal_fact(1:38)=0;
% scal_fact(mol_scal)=xmol_scal;
% str1(1:mol_max,1:15)=' ';
% for i=1:length(mol_scal)
%     str2(1:15)=' ';
%     dumstr=num2str(abs(xmol_scal(i)),'%15.7E');
%     if(isunix==1)
%         str(2:length(dumstr)+1)=dumstr;
%     else
%         str(2:12)=dumstr(1:11);
%         str(13:14)=dumstr(13:14);
%     end
%     str2=['  ' str(2:end)];
%     str1(mol_scal(i),1:15)=str2;
% end
% sz1=size(str1);
% sz1=sz1(1);
% for i=1:mol_max
%     dumstr(1:15)=str1(i,:);
%     length(dumstr);
%     fprintf(fid,[dumstr]);
% end
% fprintf(fid,'\n',[]);
% clear str1 str dumstr

string(1:20) = ' ';
string(1:20) = sprintf('%10.3f%10.3f',[vbound(1) vbound(2)]);
fprintf(fid,'%s\n',[string]);
clear string;

% boundary temperature and emissivity
fprintf(fid,'%10.3f%10.3f\n',[tbound  1]);
MODEL = 0;			       % user supplied atmospheric profile
ITYPE = 2;			       % slant path calculation
IBMAX = -no_boundaries;	               % number of user supplied layer boundaries
NOZERO = 1;			       % suppress zeroing absorber amounts
NOPRNT = 1;			       % selects short printout
NMOL   = 28;                           % number of molecules
IPUNCH = 1;
IFXTYP = 0;
MUNITS = 0;
RE = 0;
HSPACE = 100;
VBAR = (vbound(1)+vbound(2))/2;
CO2MX = 385; 	                       % Reference CO2 mixing ratio (ppmv)
REF_LAT = 0;
altxs1 = max(pressure);
altxs2 = min(pressure);
nlayertot = no_input_levels;

if min(pressure) > hbound(1)
  aa1 = (floor(max(altitude)/10)+1)*10.0;
  aa2 = 90.;
  alt = [aa1:10:aa2];
  altxs2 = aa2;
  nlayertot = no_input_levels+length(alt);
end

% Cross section mixing ratio;
nlayerxs = 2;
nmolxs = 3;
axs = linspace(altxs1,altxs2,nlayerxs);
for i = 1:nlayerxs
  xs(i,1:nmolxs) = [1.105e-04 2.783e-04 5.027e-04];
end

fprintf(fid,'%5i%5i%5i%5i%5i%5i%5i%2i %2i%10.3f%10.3f%10.3f          %10.3f\n',...
    [MODEL ITYPE IBMAX NOZERO NOPRNT NMOL IPUNCH IFXTYP MUNITS RE HSPACE VBAR REF_LAT]);
% print slant path parameters
fprintf(fid,'%10.3f%10.3f%10.3f\n',[hbound(1) hbound(2) hbound(3)]);

for i = 1:no_boundaries
  fprintf(fid,'%10.3f',pbound(i));
  if rem(i,8) == 0 & i ~= no_boundaries
    fprintf(fid,'\n',[]);
  end
end

fprintf(fid,'\n');
form = '';
for i=1:NMOL
    form = [form num2str(aflag)];
end

forma = form;
for i = 1:nmolinp
  form(idmolinp(i)) = unitinp(i);
end

% print profile info
fprintf(fid,'%5i %s\n',[nlayertot title]);
str0 = '                                                                                                    ';
for i =  1:no_input_levels
  fprintf(fid,['%10.4f%10.4f%10.4f     AA   ' form '\n'],[altitude(i) pressure(i) temperature(i)]);
  str1 = str0;
  for m = 1:nmolinp
    dum = wmol(i,m);
    if dum < 0
      str(1) = '-';
    else
      str(1) = ' ';
    end
    dumstr = num2str(abs(dum),'%10.3E');
    if(isunix == 1)
      str(2:length(dumstr)+1) = dumstr;
    else
      str(2:8)  = dumstr(1:7);
      str(9:10) = dumstr(9:10);
    end
    str1((idmolinp(m)-1)*10+1:10*idmolinp(m)) = str;
  end
  fprintf(fid,'%s\n',[str1]);
  fprintf(fid,'%s\n',[str0]);
  fprintf(fid,'%s\n',[str0]);
  fprintf(fid,'%s\n',[str0(1:40)]);
end

%
% Add extra-levels
%
if min(pressure)>hbound(1)
  disp('boo1')
  form1 = str0(1:30);
  form1(26) =num2str(aflag);form1(27)=num2str(aflag);
  for i = 1:length(alt)
    fprintf(fid,['%10.3f' form1 forma '\n'],[alt(i)]);
    fprintf(fid,'%s\n',[str0]);
    fprintf(fid,'%s\n',[str0]);
    fprintf(fid,'%s\n',[str0]);
    fprintf(fid,'%s\n',[str0(1:40)]);
  end
end

if XS == 1
  % add in the x-section info  
  fprintf(fid,'%5i%5i%5i selected x-sections are :\n',[nmolxs 0 0]);
  fprintf(fid,'CCL4      F11       F12 \n');
  fprintf(fid,'%5i%5i  \n',[nlayerxs 1]);

  for i = 1:nlayerxs
    for m = 1:nmolxs
      strxs(1:10) = '          ';
      dum = xs(i,m);
      if dum<0
        strxs(1) = '-';
      else
        strxs(1) = ' ';
      end
      dumstr = num2str(abs(dum),'%10.3E');
      if(isunix == 1)
        strxs(2:length(dumstr)+1) = dumstr;
      else
        strxs(2:8) = dumstr(1:7);
        strxs(9:10) = dumstr(9:10);
      end
      xsstr((m-1)*10+1:10*m) = strxs;
    end
    fprintf(fid,'%10.3f     AAA\n',[axs(i)]);
    fprintf(fid,'%s\n',[xsstr]);
  end
end

fprintf(fid,'-1.\n');
fprintf(fid,'%%\n');
fclose(fid);
