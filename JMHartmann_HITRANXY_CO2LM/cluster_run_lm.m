JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 1

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 02 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('g2_ir_list.txt');
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));
Stoffset = str2num(XJOB(8:9));    %Stt = Stoffset - 6;

%%% junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '.mat'];
junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '.mat'];  %% should have been this, have to rename things
outputdir
finalname = [output_dir0 '/std' junkstr];
if exist(finalname)
  fprintf(1,'%s already exists .. why bother running???? \n',finalname)
  error('file already exists')
end

for lay = 1 : 100
  cd /home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/
  fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);
  fprintf(1,'  layer = %3i \n',lay)
  
  load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres(lay);
  pco2 = refpro.gpart(lay,2);
  layT = refpro.mtemp(lay) + (Stoffset-6)*10;
  qamt = refpro.gamnt(lay,2);
  fprintf(1,'  from refpro p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',ptot,pco2,layT,qamt)
  
  %cp /home/sergio/SPECTRA/IPFILES/std_gx2x_6 .
  xdata = load('std_gx2x_6');
  xdata = xdata(lay,:);
  xptot = xdata(2);
  xpco2 = xdata(3);
  xlayT = xdata(4) + (Stoffset-6)*10;
  xqamt = xdata(5);
  fprintf(1,'  from std_gx2x_6 p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',xptot,xpco2,xlayT,xqamt)
  
  fname = ['inputparam_' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  fprintf(1,'%s \n',fname);
  fid = fopen(fname,'w');
  fprintf(fid,'%5i \n',Schunk);
  fprintf(fid,'%10.6e %10.6e \n',ptot,pco2);  
  fprintf(fid,'%10.6f \n',layT);
  fprintf(fid,'%10.6e \n',qamt);
  fprintf(fid,'%2i %3i \n',lay,Stoffset);  
  fclose(fid);

  cd /asl/data/hitran/H2016/LineMix
  fullname = ['/home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/' fname];
  junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  lmer = ['!lm_kcarta.x < ' fullname];
  eval(lmer);
  rmer = ['!/bin/rm ' fullname];
  eval(rmer);
  
  outname  = [output_dir0 '/std' junkstr];  %% this is all in the executable of lm_kcarta.x
  lala = load(outname);
  w = lala(1:10000,1);
  dvoigt(lay,:) = lala(1:10000,2);
  dfirst(lay,:) = lala(1:10000,3);
  dfull(lay,:)  = lala(1:10000,4);  
  rmer = ['!/bin/rm ' outname];
  eval(rmer);
    
end

saver = ['save ' finalname ' w dvoigt dfirst dfull'];
eval(saver)
fprintf(1,'saver = %s \n',saver);

disp('done');
