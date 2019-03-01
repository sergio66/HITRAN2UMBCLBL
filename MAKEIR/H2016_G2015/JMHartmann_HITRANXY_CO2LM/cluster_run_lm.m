JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 1

cpptotal0 = cputime;

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

useCO2ppm = 385;  %% mistakenly used this for first set of runs
useCO2ppm = 400;  %% not yet done

for lay = 1 : 100
  cd /home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/
  fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);
  fprintf(1,'  layer = %3i \n',lay)
  
  load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres(lay);
  pco2 = refpro.gpart(lay,2) * useCO2ppm/385;;
  layT = refpro.mtemp(lay) + (Stoffset-6)*10;
  qamt = refpro.gamnt(lay,2) * useCO2ppm/385;;
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

  fortran_exec = 'lm_kcarta.x';                     %% at 0.0025 cm-1 res
  fortran_exec = 'lm_kcarta_5ptboxcar.x';
  fortran_exec = 'lm_kcarta_5ptboxcar_noWVbroad.x';
  fortran_exec = 'lm_kcarta_5ptboxcar_new.x';       %% Oct 2018`

  fullname = ['/home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/' fname];
  junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  lmer = ['!time ' fortran_exec ' < ' fullname];
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

  cpptotal = cputime-cpptotal0;
  fprintf(1,'cpptotal     for %3i loops = %12.6f mins \n',lay,cpptotal/60)
  fprintf(1,'cpptotal avg for %3i loops = %12.6f mins \n',lay,cpptotal/60/lay)

  %saver = ['save ' finalname ' w dvoigt dfirst dfull'];
  %eval(saver)
  %fprintf(1,'saver = %s \n',saver);

end

saver = ['save ' finalname ' w dvoigt dfirst dfull'];
eval(saver)
fprintf(1,'saver = %s \n',saver);

disp('done');

cpptotal = cputime-cpptotal0;
fprintf(1,'cpptotal     for 100 loops = %12.6f mins \n',cpptotal/60)
fprintf(1,'cpptotal avg for 100 loops = %12.6f mins \n',cpptotal/60/100)