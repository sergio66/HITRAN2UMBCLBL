%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

addpath /home/sergio/SPECTRA
addpath /asl/matlib/science
addpath /asl/matlib/aslutil

waterlines_plot

disp('<RET> to continue');
pause

nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016/MAKEIR_WV_H16/
%cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2020/MAKEIR_WV_H20/
cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2024/MAKEIR_WV_H24/

freq_boundaries_g1

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

fid = fopen('g1_ir_list2.txt','w');
for gg = 01 : 01
  for wn = wn1:25:wn2
    for tt = 1 : 11
      iFound = 0;
      for pp = 1 : 5
        fout = [dirout '/stdH2O' num2str(wn) '_1_' num2str(tt) '_' num2str(pp) '.mat'];
        if exist(fout)
          thefilex = dir(fout);
          if thefilex.bytes > 0
            iFound = iFound + 1;
          else
            fprintf(1,'%s has size %4i bytes \n',fout,thefilex.bytes)
          end
        end
      end
      if iFound < 5
        fprintf(1,'found %2i press_offset files for H2O w/o HDO wn = %4i toffset = %2i \n',iFound,wn,tt);
        str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
        fprintf(fid,'%s\n',str);
      else
        fprintf(1,'found all %2i press_offset files for H2O w/o HDO wn = %4i toffset = %2i \n',iFound,wn,tt);
      end
    end
  end
end
fclose(fid);

disp('90 chunks, 11 Toffsets, 5 press offsets .. so expect to make 90*11*5 = 4950 files')
