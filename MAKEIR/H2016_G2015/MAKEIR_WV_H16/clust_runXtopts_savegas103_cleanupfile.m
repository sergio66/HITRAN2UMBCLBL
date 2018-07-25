gasID = 01;

for chunk = 2530 : 25 : 2530
  for tt = 1 : 11
    cd ~sergio/HITRAN2UMBCLBL/MAKEIR_WV
    %% JOB='010088004'; clust_runXtopts_savegas103_file
    fprintf(1,' >>>>>>>>>>>> chunk = %3i tt = %3i \n',chunk,tt);
    JOB=[num2str(gasID,'%02d') num2str(chunk,'%05d') num2str(tt,'%02d')]; clust_runXtopts_savegas103_file
    disp(' ')
    disp(' ')
  end
end

