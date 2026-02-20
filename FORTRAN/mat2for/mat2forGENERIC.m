function mat2forGENERIC(chunkprefix, gid0, vchunk, cdir, fdir, dtype, fstep)

% function mat2forGENERIC(chunkprefix, gid0, vchunk, cdir, fdir, dtype, fstep)
%
% produce old-format fortran data for kcarta
%
% inputs
%   chunkprefix - prefix name out output file
%   gid0   -  gas ID
%   vchunk -  wavenumber start of 25 1/cm chunk
%   cdir   -  directory for matlab mat source files
%   fdir   -  directory for fortran output files
%   dtype  -  output data type (for matlab open)
%

% default output data type
if nargin < 7
  % disp('warning : 6 or less args, setting fstep = 0.0025')
  fstep = 0.0025;
end

if nargin < 6
  dtype = 'ieee-be';
end

% default dir's for fortran compressed data 
if nargin < 5
  if gid0 == 1 | gid0 == 103
    fdir = '/home/motteler/abstab/fbin/h2o.ieee-be';
  else
    fdir = '/home/motteler/abstab/fbin/etc.ieee-be';
  end
end

% default dir's for matlab compressed data
if nargin < 4
 if gid0 == 1 | gid0 == 103
   cdir = '/home/motteler/abstab/kcomp.h2o'; 
 elseif 1 < gid0  & gid0 <= 50
   cdir = '/home/motteler/abstab/kcomp';
 else
   cdir = '/home/motteler/abstab/kcomp.xsec';
 end
end

if nargin < 3
  error('mat2forGENERIC(chunkprefix, gid0, vchunk, [cdir, fdir, dtype, fstep]) : need at least 3 args')
end

% load the matlab variables:
%
%   fr        1 x 10000           frequency scale
%   gid       1 x 1               gas ID
%   B     10000 x <d>             basis
%   kcomp   <d> x 100 x 11 x <p>  tabulated absorptions
%

%%% eval(sprintf('load %s/cg%dv%d.mat', cdir, gid0, vchunk));   %% orig, from Howard
fIN_compressed_gas = [cdir '/cg' num2str(gid0) 'v' num2str(vchunk) '.mat'];
loader = ['load ' fIN_compressed_gas];
eval(loader);

% 
% variable names from old load
% 
%   GAS_NUM            1x1              8  double array
%   MAXU               1x1              8  double array
%   START_FREQ         1x1              8  double array
%   bt_ref             3x10000     240000  double array
%   k_comp            30x1100      264000  double array
%   k_max_errors       1x3             24  double array
%   k_std_errors       1x3             24  double array
%   u              10000x30       2400000  double array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make sure you edit fstep, and prefix for file in fname (r,s,v,w whatever)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
npts  = 10000;
%fstep = 0.0025;

%%%%fname = sprintf('s%d_g%d.dat', vchunk, gid0);   %%% VERY OLD, from Howard
fname = sprintf('%s%d_g%d.dat', chunkprefix,vchunk, gid0);  %% NEWER, modified
fname = [chunkprefix num2str(vchunk) '_g' num2str(gid0) '.dat'];    %%% NEWEST
fnamex = [fdir,'/',fname];
if exist(fnamex)
  fprintf(1,'output f77bin file %s exists, please delete -- exiting \n',fnamex)
  return
else
  fprintf(1,'%80s ---> %80s \n',fIN_compressed_gas,fnamex);  
end

ktype = 2;

nlay = 100;

%% expect nd == ndk
[npts,nd] = size(B);
[ndk,~,~] = size(kcomp);

% temperature offsets
ntemp = 11;
toff  = -50.0:10.0:50.0;

fid = fopen([fdir,'/',fname], 'w' ,dtype);
if fid == -1
  fprintf(1,'output dir = %s \n',fdir);
  error('can''t open output file')
end

ndmax = 100; %% EXCEPT very high res 650-1205 cm-1 CO2
ndmax = 50; %% DEFAULT
if nd > 100
  [nd ndmax]
  error('oops nd > ndmax == max size in kcarta ....')
end
if ntemp > 11
  ntemp
  error('oops ntemp > 11 == max size in kcarta ....')
end
if nlay > 100
  nlay
  error('oops nlay > 100 == max size in kcarta ....')
end
if npts > 10000
  npts
  error('oops npts > 10000 == max size in kcarta ....')
end
if nd ~= ndk
  [nd ndk]
  error('oops nd ~= ndk ....')
end

% Write header info
filemark = 4 + 8 + 8 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4;
fwrite(fid,filemark,'integer*4');
fwrite(fid,gid0,'integer*4');
fwrite(fid,[vchunk,fstep],'real*8');
fwrite(fid,[npts,nlay,ktype,nd,ntemp,nlay,npts,ndk],'integer*4');    %%% now wy do we write nd twice? becuz it is also size of first dim of kcomp
fwrite(fid,filemark,'integer*4');

% Write the temperature offsets
filemark = 8 * ntemp;
fwrite(fid,filemark,'integer*4');
fwrite(fid,toff,'real*8');
fwrite(fid,filemark,'integer*4');

% write the compressed absorptions
if gid0 > 1 & gid0 < 103
  % do anything but water
  filemark= 8 * ntemp * nlay;
  for i = 1:nd
    fwrite(fid,filemark,'integer*4');
    fwrite(fid, kcomp(i,:), 'real*8');
    fwrite(fid,filemark,'integer*4');
  end
else
  % do 5 partial pressures, for water
  for pi = 1 : 5
    filemark= 8 * ntemp * nlay;
    for i = 1:nd
      fwrite(fid,filemark,'integer*4');
      fwrite(fid, kcomp(i,:,:,pi), 'real*8');
      fwrite(fid,filemark,'integer*4');
    end
  end
end

% write the basis set 
filemark= 8 * npts;
for i = 1:nd
   fwrite(fid,filemark,'integer*4');
   fwrite(fid,B(:,i),'real*8');
   fwrite(fid,filemark,'integer*4');
end

fclose(fid);

