JOB1 = 1; JOB2 = 6000;
JOB1 = 2; JOB2 = 2;
JOB1 = 1; JOB2 = 34;

for JOB = JOB1 : JOB2
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_ALL_H16_500_805/
  JOB
  clust_runXtopts_savegasN_file
end
