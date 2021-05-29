
XYZ = fliplr(Y);

fid = fopen('/home/sergio/KCARTA/INCLUDE/MARS_database_params/airslevels.param_mars','w');

str = 'c see /home/sergio/HITRAN2UMBCLBL/MARS_MAKEIR/Develop/produce_kcarta_paramfiles.m';
fprintf(fid,'%s \n\n',str);

str = 'c 101 pressure levels for the DEFINITION of the kCARTA MARS database';
fprintf(fid,'%s \n',str);
str = 'c Sergio Machado/Tilak Hewagama UMBC March 2014';
fprintf(fid,'%s \n\n',str);
str = '       REAL DATABASELEV(101)';
fprintf(fid,'%s \n',str);
str = '       INTEGER IPLEV';
fprintf(fid,'%s \n\n',str);

str = 'C      -----------------------------------------------------------------';
fprintf(fid,'%s \n',str);
str = 'C      Load up PLEV with the AIRS layer boundary pressure levels (in mb)';
fprintf(fid,'%s \n',str);
str = 'C      -----------------------------------------------------------------';
fprintf(fid,'%s \n',str);
str = '       DATA  ( DATABASELEV(IPLEV), IPLEV = 101, 1, -1 )';
fprintf(fid,'%s \n',str);
str = '     $ /';
fprintf(fid,'%s \n',str);
for ii = 1:20
  index = (1:5) + (ii-1)*5;
  fprintf(fid,'     $ %10.4f, %10.4f, %10.4f, %10.4f, %10.4f\n',XYZ(index));
end
index = 101;
fprintf(fid,'     $ %10.4f \n',XYZ(index));
str = '     $ /';
fprintf(fid,'%s \n\n',str);

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
