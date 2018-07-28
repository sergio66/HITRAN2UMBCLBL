%{
Suppose you notice chunk 830 is incomplete
this chunk starts at line 100 and goes on for 11 lines of eg g103_1105_list.txt for one temp
                                             
iStart = (830-605)/25*11 + 1 = 100
iStop = iStart + 10*11
%}

iDo = -1;
if iDo > 0
  iStart = 1; iStop  = 80;
  iStart = 959; iStop  = 990;  
  disp('make sure you have edited clust_runXtopts_savegas1_file by commenting out JOB = slurmblah');
  disp('ret to continue'); pause
  for JOB = iStart : iStop
    clust_runXtopts_savegas1_file
    cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_WV_G15/
  end
  disp('make sure you have fix clust_runXtopts_savegas1_file by fixing JOB = slurmblah');
  disp('ret to continue'); pause
  error('ugh')  
end

iDo = -1;
if iDo > 0
  iStart = 90;
  iStop  = 90;
  disp('make sure you have edited clust_runXtopts_mkg1vfiles by commenting out JOB = slurmblah');
  disp('ret to continue'); pause
  for JOB = iStart : iStop
    clust_runXtopts_mkg1vfiles  
    cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_WV_G15/
  end
  disp('make sure you have fixed clust_runXtopts_mkg1vfiles JOB = slurmblah');
  disp('ret to continue'); pause
  error('ugh')  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iDo = -1;
if iDo > 0
  iStart = 1; iStop  = 80;
  iStart = 900; iStop  = 990;
  iStart = 54 ; iStop  = 90;
  
  iStart = 830; iStart = (iStart - 605)/25*11 + 1 ; iStop  = iStart + 10;
  iStart = 1255; iStart = (iStart - 605)/25*11 + 1 ; iStop  = iStart + 10*12;
  iStart = 1505; iStart = (iStart - 605)/25*11 + 1 ; iStop  = iStart + 10;
  
  disp('make sure you have edited clust_runXtopts_savegas103_file by commenting out JOB = slurmblah');
  disp('ret to continue'); pause
  for JOB = iStart : iStop
    clust_runXtopts_savegas103_file
    cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_WV_G15/
  end
  disp('make sure you have fix clust_runXtopts_savegas103_file by fixing JOB = slurmblah');
  disp('ret to continue'); pause
  error('ugh')
end

iDo = +1;
if iDo > 0
  iStart = 1;  iStop  = 90;
  iSummmAlreadyy = 0;
  disp('make sure you have edited clust_runXtopts_mkg103vfiles by commenting out JOB = slurmblah');
  disp('ret to continue'); pause
  for JOB = iStart : iStop
    clust_runXtopts_mkg103vfiles  
    cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/MAKEIR_WV_G15/
  end
  iSummmAlreadyy
  disp('make sure you have fixed clust_runXtopts_mkg103vfiles JOB = slurmblah');
  disp('ret to continue'); pause
  error('ugh')  
end

