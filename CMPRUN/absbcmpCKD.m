function absbcmp(gid, gdir, cdir, vchunk, B, CKD) 

% function absbcmp(gid, gdir, cdir, vchunk, B,CKD) 
%
% represent tabulated monochromatic absorptions wrt basis B
%
% inputs
%   gid    -  gas ID
%   gdir   -  path to monochromatic abs. data 
%   cdir   -  directory for output .mat files
%   vchunk -  wavenumber start of 25 1/cm chunk
%   B      -  supplied basis for the compression
%   CKD    -  ckd version
%
% The tabulated monochromatic absorption data should be in .mat 
% files named either g<gid>v<chunk>.mat, for all gasses but water, 
% or g<gid>v<chunk>p<i>.mat, for water, which is saved as a set
% of partial pressures.  These .mat files contain the variables:
% 
%   fr        1 x 10000     frequency scale
%   gid       1 x 1         gas ID
%   k     10000 x 100 x 11  tabulated absorptions
%   pind      1 x 1         partial pressure index (when relevant)
%
% The output data is saved in files cg<gid>v<chunk>.mat, with
% similar variables:
%
%   fr        1 x 10000           frequency scale
%   gid       1 x 1               gas ID
%   B     10000 x <d>             basis
%   kcomp   <d> x 100 x 11 x <p>  tabulated absorptions
%

if nargin ~= 6
  error('wrong number of arguments')
end

% pre-compression transform
kpow = 1/4; 

Binv = pinv(B);
[m,d] = size(B);

if gid == 1 | gid == 103 | gid == 110
  % represent several files of tabulated absorption wrt basis B
  kcomp = zeros(d, 100, 11, 5);

  % loop on partial pressure sets
  for pind = 1 : 5
    %%% eval(sprintf('load %s/g%dv%dp%d.mat', gdir, gid, vchunk, pind));
    loader = ...
      [gdir '/g' num2str(gid) 'v' num2str(vchunk) 'p' num2str(pind) '.mat'];
    loader = ['load ' loader];
    eval(loader);

    for tind = 1 : 11
      k(:,:,tind) = k(:,:,tind) .* (k(:,:,tind) > 0);  % force k non-neg.
      kcomp(:,:,tind,pind) = Binv * (k(:,:,tind) .^ kpow); 
    end
    clear k
  end

else
  % represent a single file of tabulated absorptions wrt basis B
  kcomp = zeros(d, 100, 11);

  %%% eval(sprintf('load %s/g%dv%d.mat', gdir, gid, vchunk));
  if gid == 101 | gid == 102
    loader = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD)  '.mat'];
  else
    loader = [gdir '/g' num2str(gid) 'v' num2str(vchunk) '.mat'];
    end
  loader = ['load ' loader];
  eval(loader);

  if gid == 101 | gid == 102
    k = k*1e23;
  end

  for tind = 1 : 11
    k(:,:,tind) = k(:,:,tind) .* (k(:,:,tind) > 0);  % force k non-neg.
    kcomp(:,:,tind) = Binv * (k(:,:,tind) .^ kpow);
  end
  clear k
end

% save the results

%%% eval(sprintf('save %s/cg%dv%d kcomp B fr gid', cdir, gid, vchunk));
saver = ['save '  cdir '/cg' num2str(gid) 'v' num2str(vchunk) '_CKD_' num2str(CKD) '.mat'];
eval(saver)

