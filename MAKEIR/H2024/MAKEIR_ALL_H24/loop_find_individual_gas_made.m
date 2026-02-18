iNotFound = 0;
iCnt = 0;
iAllFound = 0;
iaaFoundTT_11 = [];
wnall = wn1 : dv : wn2;

fid = fopen('gN_ir_listN.txt','w');
iCnt = 0;

disp(' ')

for gg = gid : gid
  fcnt = 0;
  iAll_11_Files_Done_PerChunk = 0;
  for wnX = 1 : length(wnall)
    wn = wnall(wnX);
    fcnt = fcnt + 1;    
    iaaFoundTT_11(fcnt,1:11) = 0;  
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
    linescnt(fcnt) = length(woo);
    if length(woo) >= 1
      fprintf(1,'for gid = %2i found %6i lines in chunk %4i ',gid,length(woo),wn);
      i11total = 0;        
      for tt = 1 : 11
        iCnt = iCnt + 1;      
	fout = [dirout '/std' num2str(wn) '_' num2str(gid) '_' num2str(tt) '.mat'];
	if ~exist(fout)
	  iaaFoundTT_11(fcnt,tt) = 0;
          str = [num2str(gg,'%02d') num2str(wn,'%05d') num2str(tt,'%02d')];
          fprintf(fid,'%s\n',str);
          iNotFound = iNotFound + 1;
          iaNotFound(iNotFound) = iCnt;
	  fprintf(1,'N ')
          %fprintf(1,'for gid = %2i found %4i lines in chunk %4i, DID NOT FIND files for tt = %2i of 11 \n',gid,length(woo),wn,tt);	  
        else
	  iaaFoundTT_11(fcnt,tt) = 1;	
	  iAllFound = iAllFound + 1;
	  i11total = i11total + 1;	  
	  fprintf(1,'Y ')	  
          %fprintf(1,'for gid = %2i found %4i lines in chunk %4i, found files for tt = %2i of 11 \n',gid,length(woo),wn,tt);
        end	  
      end
      fprintf(1,' ... found %2i of 11 Tfiles \n',i11total)
      if i11total == 11
        iAll_11_Files_Done_PerChunk = iAll_11_Files_Done_PerChunk + 1;
      end
    end
  end
end
fclose(fid);

disp(' ')
fprintf(1,'gasID %2i : need to make %4i/11 = %2i chunks of files (with 11 T) .... found %4i files, did not find %4i files \n',gid,iCnt,iCnt/11,iAllFound,iNotFound)
fprintf(1,'wrote out 9 digit code (gasID.freqchunk,toffset) where files are not made into gN_ir_listN.txt iNotFound = %5i \n',iNotFound)
disp(' ')
fprintf(1,'found %2i chunks had all 11 Toffsets done, out of %2i that had lines \n',iAll_11_Files_Done_PerChunk,iCnt/11);

figure(2); yyaxis left;  plot(wnall, sum(iaaFoundTT_11,2));
  	     ylabel('Num T offsets done')
           yyaxis right; semilogy(wnall, linescnt,'+-')
           title(['Gas ' num2str(gid) ' Count of 11 T offsets done, and numlines in chunk']);
  	     xlabel('Wavenumber chunk'); ylabel('Num lines')

%% figure(3); plot(wnall, linescnt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now figure out where you havd to make chunks but less than 11 T chunks were made
chunks_have_lines = find(linescnt > 0);
needlinesX = find(sum(iaaFoundTT_11(chunks_have_lines,:),2) < 11);
needlines = chunks_have_lines(needlinesX);

if length(needlines) > 0
  fid = fopen('gN_ir_listN_T11.txt','w');
  for ii = 1 : length(needlines)
    str = [num2str(gg,'%02d') num2str(wnall(needlines(ii)),'%05d')];
    fprintf(fid,'%s\n',str);
  end    
  fclose(fid);
  fprintf(1,'found %2i chunks where not all 11 Toffset files are mode \n',length(needlines))
  disp('wrote out 7 digit code (gasID.freqchunk) where not all 11 T ofset files are not made  into gN_ir_listN_T11.txt')  
  disp(' ')

  figure(2); yyaxis left;  plot(wnall, sum(iaaFoundTT_11,2),'b',wnall(needlines),sum(iaaFoundTT_11(needlines,:),2),'k*');
               ylabel('Num T offsets done')
             yyaxis right; semilogy(wnall, linescnt,'+-')
               xlabel('Wavenumber chunk'); ylabel('Num lines')
	     str = ['  ' num2str(length(needlines)) ' black stars on blue chunk curve indicate \newline  where not all 11 T chunks made for a chunk'];
             title(['Gas ' num2str(gid) ' Count of 11 T offsets done, and numlines in chunk \newline ' str]);
end


