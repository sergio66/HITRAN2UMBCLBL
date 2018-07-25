homedir = pwd;

nbox = 5; pointsPerChunk = 10000;
freq_boundaries
fA = wn1; fB = wn2; df = dv;

zerobytes = [];
zz = 0;
g1 = 01; g2 = 63;
g1 = 51; g2 = 81;
g1 = 01; g2 = 81;
for gasid = g1 : g2
  fprintf(1,'gas = %3i \n',gasid)
  clear woof
  dir0 = [dirout '/g' num2str(gasid) '.dat/'];
  thedir = dir(dir0);
  if length(thedir) > 2     %% . and .. are "two" files
    jj = 0;
    for ii = 3 : length(thedir)
      if thedir(ii).bytes == 0
        jj = jj + 1;
        woof(jj) = ii;
        end
      end

    if exist('woof')
      if length(woof) > 0
        fprintf(1,'gasID = %3i   num of zero files found = %3i \n',gasid,length(woof));
        for ii = 1 : length(woof)
          zz = zz + 1;
          zerobytes(zz).name = [dir0 thedir(woof(ii)).name];
          end
        end
      end
    end
  end

if length(zerobytes) > 0
  disp('deleting files of zero length')
  for ii = 1 : length(zerobytes)
    thename = zerobytes(ii).name;
    lser = ['!ls -lt  ' thename]; eval(lser); pause(1)
    rmer = ['!/bin/rm ' thename];
    eval(rmer);
    end
  end