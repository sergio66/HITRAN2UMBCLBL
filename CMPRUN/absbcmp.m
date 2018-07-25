function absbcmp(gid0, gdir, cdir, vchunk, B) 

% function absbcmp(gid0, gdir, cdir, vchunk, B) 
%
% represent tabulated monochromatic absorptions wrt basis B
%
% inputs
%   gid0   -  gas ID
%   gdir   -  path to monochromatic abs. data 
%   cdir   -  directory for output .mat files
%   vchunk -  wavenumber start of 25 1/cm chunk
%   B      -  supplied basis for the compression
%
% The tabulated monochromatic absorption data should be in .mat 
% files named either g<gid0>v<chunk>.mat, for all gasses but water, 
% or g<gid0>v<chunk>p<i>.mat, for water, which is saved as a set
% of partial pressures.  These .mat files contain the variables:
% 
%   fr        1 x 10000     frequency scale
%   gid0      1 x 1         gas ID
%   k     10000 x 100 x 11  tabulated absorptions
%   pind      1 x 1         partial pressure index (when relevant)
%
% The output data is saved in files cg<gid0>v<chunk>.mat, with
% similar variables:
%
%   fr        1 x 10000           frequency scale
%   gid0      1 x 1               gas ID
%   B     10000 x <d>             basis
%   kcomp   <d> x 100 x 11 x <p>  tabulated absorptions
%

if nargin ~= 5
  error('wrong number of arguments')
end

% pre-compression transform
kpow = 1/4; 

Binv = pinv(B);
[m,d] = size(B);

if gid0 == 1 | gid0 == 103 | gid0 == 110
  % represent several files of tabulated absorption wrt basis B
  kcomp = zeros(d, 100, 11, 5);

  % loop on partial pressure sets
  for pind = 1 : 5
    %%% eval(sprintf('load %s/g%dv%dp%d.mat', gdir, gid0, vchunk, pind));
    loader = [gdir '/g' num2str(gid0) 'v' num2str(vchunk) 'p' num2str(pind) '.mat'];
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

  %%% eval(sprintf('load %s/g%dv%d.mat', gdir, gid0, vchunk));
  loader = [gdir '/g' num2str(gid0) 'v' num2str(vchunk) '.mat'];
  loader = ['load ' loader];
  eval(loader);

  if gid0 == 101 | gid0 == 102
    k = k*1e23;
  end

  for tind = 1 : 11
    k(:,:,tind) = k(:,:,tind) .* (k(:,:,tind) > 0);  % force k non-neg.
    kcomp(:,:,tind) = Binv * (k(:,:,tind) .^ kpow);
  end
  clear k
end

% save the results

%%% eval(sprintf('save %s/cg%dv%d kcomp B fr gid0', cdir, gid0, vchunk));
saver = ['save '  cdir '/cg' num2str(gid0) 'v' num2str(vchunk) '.mat'];
eval(saver)

