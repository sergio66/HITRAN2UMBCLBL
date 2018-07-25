avheightsMarsUpper = interp1(log(plevsMarsUpper),heightsMarsUpper,log(YavUpper));
XYZ = avheightsMarsUpper;

fid = fopen('/home/sergio/KCARTA/INCLUDE/MARS_database_params/airsheights_upper.param_mars','w');

str = 'c see /home/sergio/HITRAN2UMBCLBL/MARS_MAKEIR/Develop/produce_kcarta_paramfiles.m';
fprintf(fid,'%s \n\n',str);

str = 'c 100 layer heights for the DEFINITION of the kCARTA database';
fprintf(fid,'%s \n',str);
str = 'c Sergio Machado/Tilak Hewagama UMBC March 2014';
fprintf(fid,'%s \n\n',str);

str = 'c this is for the upper atm ';
fprintf(fid,'%s \n',str);
str = '       REAL DatabaseHeight(kMaxLayer)';
fprintf(fid,'%s \n',str);
str = '       INTEGER IPHEIGHT';
fprintf(fid,'%s \n\n',str);

str = 'c note that the program expects heights in km, so these numbers will have';
fprintf(fid,'%s \n',str);
str = 'c to be read in and divided by 1000.0';
fprintf(fid,'%s \n\n',str);

str = 'C      -----------------------------------------------------------------';
fprintf(fid,'%s \n',str);
str = 'C      Load up Pheight with the AIRS layer heights US Standard Profile (in m)';
fprintf(fid,'%s \n',str);
str = 'C      -----------------------------------------------------------------';
fprintf(fid,'%s \n\n',str);

str = '       DATA  (DatabaseHEIGHT(IPHEIGHT), IPHEIGHT = 1,100,1 )';
fprintf(fid,'%s \n',str);
str = '     $ /';
fprintf(fid,'%s \n',str);
for ii = 1:25
  index = (1:4) + (ii-1)*4;
  fprintf(fid,'     $ %10.7e, %10.7e, %10.7e, %10.7e\n',XYZ(index)*1000);
end
str = '     $ /';
fprintf(fid,'%s \n\n',str);

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%