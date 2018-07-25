function write_ckd_lookup(foutdir,CKD,fr,ckdX,iSorF)

%% see /home/sergio/SPECTRA/CKDLINUX/CKD_LOOKUP_ALLBANDS_Oct2014/ckd_lookupBIN_IR.m
loc = 0;

[m,n]=size(ckdX);

if iSorF == -1
  fout_s = [foutdir 'CKDSelf' num2str(CKD) '.bin'];
else  
  fout_s = [foutdir 'CKDFor' num2str(CKD) '.bin'];
end

fprintf(1,'writing to %s \n',fout_s);

fid = fopen(fout_s,'w','ieee-le');

fstart = fr(1);
fend   = fr(length(fr));
npts   = length(fr);
df     = fr(2)-fr(1);

%%header = f1,f2,df
filemark=8+8+8;
fwrite(fid,filemark,'integer*4');
fwrite(fid,[fstart,fend,df],'real*8');
fwrite(fid,filemark,'integer*4');

%%header = loc,CKD vers,m,n
filemark=4+4+4+4;
fwrite(fid,filemark,'integer*4');
fwrite(fid,[loc,CKD,m,n],'integer*4');
fwrite(fid,filemark,'integer*4');

%save the temps
temp=100:10:400;
filemark = 8*length(temp);
fwrite(fid,filemark,'integer*4');
fwrite(fid,temp','real*8');
fwrite(fid,filemark,'integer*4');

%%save the matrix
%%%%loop over the rows (temperature)
filemark = 8*length(fr);
for i = 1:m
   fwrite(fid,filemark,'integer*4');
   fwrite(fid,ckdX(i,:)','real*8');
   fwrite(fid,filemark,'integer*4');
end
fclose(fid);
	    