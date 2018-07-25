addpath /home//sergio/HITRAN2UMBCLBL/READ_XSEC

if exist('xsecdata_chunks.mat')
  load xsecdata_chunks.mat
  end

nbox = 5;
pointsPerChunk = 10000;

freq_boundaries
fmin0 = fmin;

g1 = 51; g2 = 81;

g1 = 81; g2 = 81;

for gasid = g1 : g2
  gasid
  ix = gasid - 51 + 1;
  fname = gid2mol(gasid);
  fmin = fmin0;
  jj = 0;
  n  = 0;
  while fmin <= wn2
    jj = jj + 1;
    freq(jj) = fmin;
    fmax = fmin + dv;    
    [iYes,gf] = findxsec_plot(fmin,fmax,gasid);     
    if iYes > 0
      n = n + 1;
      datafound(ix,jj) = 1;
    else
      datafound(ix,jj) = 0;
      end
    fmin = fmin + dv;
    end
  save_xsecdata.freq = freq;  
  save_xsecdata.gasid(ix) = gasid;
  save_xsecdata.nchunk(ix) = n;
  save_xsecdata.found = datafound;
  plot(freq,datafound(ix,:)); title(num2str(gasid)); pause(1)
%  save xsecdata_chunks  save_xsecdata
  end