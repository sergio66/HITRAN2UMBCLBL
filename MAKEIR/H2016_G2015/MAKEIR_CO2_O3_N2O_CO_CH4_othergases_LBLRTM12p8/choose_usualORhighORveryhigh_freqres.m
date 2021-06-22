%%% freq_boundaries       %%% these are standard, using 0.0025 cm-1 output

iUsualORHigh = -1;    %%% these are high     res, using 0.0005 cm-1 output --> 0.0025 cm-1 after 5 pt boxcar
iUsualORHigh = -2;    %%% these are v.high   res, using 0.0001 cm-1 output --> 0.0005 cm-1 after 5 pt boxcar
iUsualORHigh = -3;    %%% these are v.high   res, using 0.0002 cm-1 output, which is limit of LBLRTM output for 580-2830 cm-1
iUsualORHigh = -4;    %%% these are v.lo     res, using 0.02   cm-1 output --> 0.1 cm-1    after 5 pt boxcar
iUsualORHigh = -5;    %%% these are quite lo res, using 0.01   cm-1 output --> 0.05 cm-1   after 5 pt boxcar
iUsualORHigh = -6;    %%% these are lo       res, using 0.005  cm-1 output --> 0.025 cm-1  after 5 pt boxcar

iUsualORHigh = -1;    %%% these are high   res, using 0.0005 cm-1 output since we are done testing and settled on 0.0005 cm-1

iUsualORHigh = +1;    %%% usual res

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_boundariesLBL    %%% these are high res, using 0.0005 or 0.0001 cm-1 output

