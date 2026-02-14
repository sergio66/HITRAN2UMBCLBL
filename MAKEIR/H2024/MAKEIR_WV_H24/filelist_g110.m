%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

disp(' you may want to "clear all" '); disp('RET to continue'); pause

addpath0

waterlines_plot

disp('<RET> to continue');
pause

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_WV_H16/
%cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2020/MAKEIR_WV_H20/
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/

freq_boundaries_g110

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

iNotFound = 0;
iCnt = 0;
iAllFound = 0;

fid = fopen('g1_ir_list2.txt','w');  %%% notice this is not g110_ir_list2.txt
for gg = 01 : 01
  for wn = wn1:25:wn2
    for tt = 1 : 11
      iFound = 0;
      iCnt = iCnt + 1;
      for pp = 1 : 5
        fout = [dirout '/stdH2OALL' num2str(wn) '_1_' num2str(tt) '_' num2str(pp) '.mat'];
        if exist(fout)
          thefilex = dir(fout);
          if thefilex.bytes > 0
            iFound = iFound + 1;
          else
            fprintf(1,'%s has size %4i bytes \n',fout,thefilex.bytes)
          end
        end
      end
      iAllFound = iAllFound + iFound;      
      if iFound < 5
        fprintf(1,'found few %2i press_offset files for H2O ALL wn = %4i toffset = %2i \n',iFound,wn,tt);
        str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
        fprintf(fid,'%s\n',str);
        iNotFound = iNotFound + 1;
	iaNotFound(iNotFound) = iCnt;
      else
        fprintf(1,'found all %2i press_offset files for H2O ALL wn = %4i toffset = %2i \n',iFound,wn,tt);
      end
    end
  end
end
fclose(fid);

junk = iAllFound/4950 * 100;
fprintf(1,'90 chunks, 11 Toffsets, 5 press offsets .. so expect to make 90*11*5 = 4950 files --- found %4i or %9.5f percent \n',iAllFound,junk)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iNotFound > 0
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt
  %% when you first run this, should do cp g1_ir_list.txt g1_ir_list_ALL.txt  

  if length(iaNotFound) <= 10
    disp('  ')
    catter = ['!cat g1_ir_list2.txt'];
    eval(catter)
  end
  
  if length(iaNotFound) <= 10
    iaMax = 1:length(iaNotFound);
    disp('  showing all job arrays that are not done')
  else
    iaMax = 1 : 10;
    disp('  showing first ten job arrays that are not done')    
  end
  disp(' ')
  printarray(iaNotFound(iaMax))
  kapoo = load('g1_ir_list.txt');
  printarray(kapoo(iaNotFound(iaMax)));       %% this should reproduce g1_ir_list2.txt above !!!!!
  
  disp(' ')
  disp('if you want, can     cp g1_ir_list2.txt g1_ir_list0.txt; mv g1_ir_list2.txt g1_ir_list.txt')
  
  disp(' ')  
  disp('  But much beter to edit/run "jobs_not_done.sc" output from write_out_jobsnotdone_for_cluster')
  disp('XYZ should be set to 3')
  if iNotFound > 0
    write_out_jobsnotdone_for_cluster(iaNotFound,1:990);
  end  
end

