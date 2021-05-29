fid = fopen('/home/sergio/KCARTA/INCLUDE/MARS_database_params/KCARTA_database.param_mars','w');

str = 'c see /home/sergio/HITRAN2UMBCLBL/MARS_MAKEIR/Develop/produce_kcarta_paramfiles.m';
fprintf(fid,'%s \n',str);
str = 'c Sergio Machado/Tilak Hewagama UMBC March 2014';
fprintf(fid,'%s \n\n',str);

str = '      REAL PLEV_KCARTADATABASE_AIRS(kMaxLayer+1)  ';
fprintf(fid,'%s \n',str);
str = '      REAL PAVG_KCARTADATABASE_AIRS(kMaxLayer)    ';
fprintf(fid,'%s \n\n',str);

str = '      DATA  (PLEV_KCARTADATABASE_AIRS(IPLEV),IPLEV=     1,  101,   1)';
fprintf(fid,'%s \n',str);
for ii = 1:25
  index = (1:4) + (ii-1)*4;
  fprintf(fid,'     $ %10.4f, %10.4f, %10.4f, %10.4f, \n',Y(index));
end
index = 101;
fprintf(fid,'     $ %10.4f \n',Y(index));
str = '     $ /';
fprintf(fid,'%s \n\n',str);

str = '      DATA  (PAVG_KCARTADATABASE_AIRS(IPLEV),IPLEV=     1,  100,   1)';
fprintf(fid,'%s \n',str);
str = '     $ /';
fprintf(fid,'%s \n',str);
for ii = 1:25
  index = (1:4) + (ii-1)*4;
  fprintf(fid,'     $ %10.4f, %10.4f, %10.4f, %10.4f, \n',Yav(index));
end
str = '     $ /';
fprintf(fid,'%s \n\n',str);

fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
