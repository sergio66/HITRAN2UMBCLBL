function [vx, OD, v, vxorig] = lblrtm_tape11_reader(fname, opt)

% example [vx, OD, v, vxorig] = lblrtm_tape11_reader(fname, 's');   %% lblrtm compiled single precision
%% vx,OD are the high res output from LBLRTM; "vx" comes from "v" which is a Nx3 matrix giving [start step size]
%%
%% Oct 2019 :
%% vall is internally trying to keep track of vx while reading the individual panels, 
%% and is more accurate than vx so I swap : vx becomes vall, vxorig become vx
%% this way, size(OD) === size(vx) ... before they were slightly off ...

% http://www.mathworks.com/matlabcentral/fileexchange/8467-lblrtm-tape11-and-tape12-readers/content/lblrtm_TAPE11_reader.m

% File format illustration
% for single precision
% shift 266*4 bytes
% LOOP
% 1 int        , 24 (block of v1, v2, dv, npts)
% 2 double vars, for v1, and v2
% 1 float      , for dv
% 1 int        , for npts
% 1 int        , 24
% 1 int        , 9600 or npts*4 (beg of block output)
% NPTs float   , OD
% 1 int        , 9600 or npts*4 (end of block of output)
% LOOP ENDS

% for double precision
% shift 356*4 bytes
% LOOP
% 1 int        , 32 (v1, v2, dv and npts, extra 0)
% 3 double vars, for v1, v2, and dv
% 1 long int   , for npts
% 1 int        , 32   
% 1 int        , 19200 or npts*8 (beg of block of output)
% NPTS double  , OD
% 1 int        , 19200 or npts*8 (end of block of output)
% LOOP ENDS

% Author: Xianglei Huang
% Tested on Redhat Linux with pgi-compiler version of LBLRTM

v = [];
OD = [];

iQuietRead = -1;  %% do     keep displaying "read panel"
iQuietRead = +1;  %% do not keep displaying "read panel"

if nargin ~= 2
   disp('wrong number of input parameters, you must specify data type');
   return;
end

fid = fopen(fname, 'rb', 'l');

if lower(opt(1)) == 'f' | lower(opt(1)) == 's'
   shift = 266;
   itype   = 1;
else
  shift = 356;
  itype = 2;
end

fseek(fid, shift*4, -1);

% decide whether need to open as big-endian file
test = fread(fid, 1, 'int');

fclose(fid);

if (itype == 1 & test == 24) | (itype == 2 & test == 32)
  disp('opening output lblrtm as le')
  fid = fopen(fname, 'rb', 'l');
  fseek(fid, shift*4, -1);
else
  disp('opening output lblrtm as be')
  fid = fopen(fname, 'rb', 'b');
  fseek(fid, shift*4, -1);
end

endflg = 0;

panel = 0;

vall = [];
if itype == 1
  while (endflg == 0)
    panel = panel + 1;
    if iQuietRead < 0
      disp(['read panel ', int2str(panel)]);
    end
    fread(fid, 1, 'int');

    v1 = fread(fid, 1, 'double');
    if isnan(v1) 
      break;
    end  
    v2 = fread(fid, 1, 'double');
%    dv = fread(fid, 1, 'float');
    dv = fread(fid, 1, 'single');
    npts = fread(fid, 1, 'int');
    %fprintf(1,'%10.6f %10.6f %10.6f %5i \n',[v1 v2 dv],npts)
    %fprintf(1,'v1 + dv*npts = %15.10f  v2 = %15.10f \n',v1+dv*(npts-1),v2)
    wii = 1 :  npts;
    vall = [vall v1 + (wii-1)*dv];

    fread(fid, 1, 'int');  
    LEN = fread(fid, 1, 'int');
    %fprintf(1,'LEN = %5i npts = %5i \n',LEN,npts)

    if (LEN ~= 4*npts)
      disp('internal file inconsistency 1');
      endflg = 1;
    end
%    tmp = fread(fid, npts, 'float');
    tmp = fread(fid, npts, 'single');
    LEN2 = fread(fid, 1, 'int');
    if (LEN ~= LEN2)
      disp('internal file inconsistency 2');
      endflg = 1;
    end
  
    v = [v; [v1, v2, dv]];
    %whos OD tmp
    OD = [OD; reshape(tmp, npts, 1)];
    plot(OD)
  end
else
  while(endflg == 0)
    panel = panel + 1;
    if iQuietRead < 0
      disp(['read panel ', int2str(panel)]);
    end
    fread(fid, 1, 'int');

    tmp = fread(fid, 3, 'double');
    v1 = tmp(1); v2 = tmp(2); dv = tmp(3);
    if isnan(v1) 
      break;
    end
    npts = fread(fid, 1, 'int64');
    wii = 1 :  npts;
    vall = [vall v1 + (wii-1)*dv];
    if npts ~= 2400
      endflg = 1;
    end
   fread(fid, 1, 'int');
   LEN = fread(fid, 1, 'int');
   if (LEN ~= 8*npts)
     disp('internal file inconsistency 1');
     endflg = 1;
   end
   tmp = fread(fid, npts, 'double');
   LEN2 = fread(fid, 1, 'int');
   if (LEN ~= LEN2)
     disp('internal file inconsistency');
     endflg = 1;
   end

   v = [v; [v1, v2, dv]];
   OD = [OD; reshape(tmp, npts, 1)];
  end
end

%v = v1:dv:v2;
%v = reshape(v, length(v), 1);
%OD = tmp;
%OD = reshape(OD, length(v), 1);

fclose(fid);

[mm,nn] = size(v);
vx = [];
for ii = 1 : mm
  vjunk = v(ii,1) :  v(ii,3) :  v(ii,2);
  vx = [vx vjunk];
end
vx = vx';

%%%% oops I think vall is better than vx so swap
vjunk = vall;
vall   = vx;
vxorig = vx;
vx = vjunk';
