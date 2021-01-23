function for2for_gasmult(gid,fr,kcomp,B,scale,fout,dtype)

% function for2for_gasmult(gid,fr,kcomp,B,scale,fout,dtype)
%
% produce old-format fortran data for kcarta
%
% inputs
%   gid    -  gas ID
%   kcomp  - compressed ODs
%   B      - basis vectors
%   scale  - scaling for kcomp
%   fr     - wavenumber scale
%   fout   -  fortran output files
%   dtype  -  output data type (for matlab open)
%
% where we loaded
% the matlab variables using eg ../for2mat/for2mat_kcomp_reader.m
%   fr        1 x 10000           frequency scale
%   gid       1 x 1               gas ID
%   B     10000 x <d>             basis
%   kcomp   <d> x 100 x 11 x <p>  tabulated absorptions
%

fname = fout;

kcomp = kcomp .* (scale ^ (1/4));

ktype=2;

npts=10000;
%fstep=0.0025;
vchunk = fr(1);
fstep = mean(diff(fr));

nlay = 100;
[npts,nd]=size(B);

% temperature offsets
ntemp=11;
toff=-50.0:10.0:50.0;

fid=fopen(fname, 'w' ,dtype);
if fid == -1
  fprintf(1,'trying to open %s \n',fname);
  error('can''t open output file')
end

% Write header info
filemark= 4 + 8 + 8 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4;
fwrite(fid,filemark,'integer*4');
fwrite(fid,gid,'integer*4');
fwrite(fid,[vchunk,fstep],'real*8');
fwrite(fid,[npts,nlay,ktype,nd,ntemp,nlay,npts,nd],'integer*4');
fwrite(fid,filemark,'integer*4');

% Write the temperature offsets
filemark= 8 * ntemp;
fwrite(fid,filemark,'integer*4');
fwrite(fid,toff,'real*8');
fwrite(fid,filemark,'integer*4');

% write the compressed absorptions
if gid > 1
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

