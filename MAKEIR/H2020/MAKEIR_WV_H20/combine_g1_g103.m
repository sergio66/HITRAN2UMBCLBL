addpath /home/sergio/SPECTRA

nbox = 5;
pointsPerChunk = 10000;

freq_boundaries_g103
  hdodir = dirout;

freq_boundaries_g1
  h2odir = dirout;

h2oalldir = [h2odir(1:end-7) 'g110.dat/'];

for wn = wn1 : dv : wn2
  for tt = 1 : 11
    fprintf(1,'%5i %2i \n',wn,tt);
    for pp = 1 : 5
      hdo = [hdodir '/stdHDO' num2str(wn) '_1_' num2str(tt) '_' num2str(pp) '.mat'];
      h2o = [h2odir '/stdH2O' num2str(wn) '_1_' num2str(tt) '_' num2str(pp) '.mat'];
      
      h2oall = [h2oalldir '/stdH2O' num2str(wn) '_1_' num2str(tt) '_' num2str(pp) '.mat'];

      ee0 = exist(h2o);
      eeD = exist(hdo);
      eeA = exist(h2oall);
     
      clear h2odata hdodata h2oalldata
      if ee0 > 0 & eeA == 0
        h2odata = load(h2o);
        hdodata.w = h2odata.w;
        hdodata.d = zeros(size(h2odata.d));

        if eeD > 0
          hdodata = load(hdo);
          fprintf(1,'    %4i cm-1 : h2o,hdo exist \n',wn);
        else
          fprintf(1,'    %4i cm-1 : h2o exists but hdo DNE \n',wn);
        end

        h2oalldata.w = h2odata.w;
        h2oalldata.d = h2odata.d + hdodata.d;        

        w = h2oalldata.w;
        d = h2oalldata.d;

        saver = ['save ' h2oall ' w d'];
        eval(saver)

      end   %% if exist(ee0) & ~exist(eeA)
    end     %% pp
  end       %% tt
end         %% wn

        