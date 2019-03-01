JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 155

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 02 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('g2_ir_list.txt');
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end

useCO2ppm = 385;  %% mistakenly used this for first set of runs
useCO2ppm = 400;  %% not yet done

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));
Stoffset = str2num(XJOB(8:9));    %Stt = Stoffset - 6;

%%% junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '.mat'];
junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '.mat'];  %% should have been this, have to rename things
outputdir
finalname = [output_dirRUN8 '/std' junkstr];
if exist(finalname)
  fprintf(1,'%s already exists .. why bother running???? \n',finalname)
  error('file already exists')
end

homedir = pwd;
for lay = 1 : 100
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM
  cder = ['cd ' homedir];
  eval(cder)
  fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);
  fprintf(1,'  layer = %3i \n',lay)
  
  load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres(lay);
  pco2 = refpro.gpart(lay,2)  * useCO2ppm/385;
  layT = refpro.mtemp(lay)  + (Stoffset-6)*10;
  qamt = refpro.gamnt(lay,2)  * useCO2ppm/385;
  fprintf(1,'  from refpro p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',ptot,pco2,layT,qamt)
  
  %cp /home/sergio/SPECTRA/IPFILES/std_gx2x_6 .
  xdata = load('std_gx2x_6');
  xdata = xdata(lay,:);
  xptot = xdata(2);
  xpco2 = xdata(3)  * useCO2ppm/385;
  xlayT = xdata(4)  + (Stoffset-6)*10;
  xqamt = xdata(5)  * useCO2ppm/385;
  fprintf(1,'  from std_gx2x_6 p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',xptot,xpco2,xlayT,xqamt)

  fname = ['inputparam_' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  fid = fopen(fname,'w');
  fprintf(fid,'%4i %10.6e %10.6e %10.6f %10.6e \n',lay,ptot,pco2,layT,qamt); 
			       %% see also /asl/data/hitran/H2016/LineMix/LM_calc_CO2_2017_kcarta.for
  fclose(fid);
  fullname = ['/home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/' fname];

  cd /home/sergio/SPECTRA
  topts.xfar = 250;
  topts.xfar = 500;

  %% new for /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0/ checking how things look WITH NO PRESSURE SHIFT, ORIG HITRAN2016 params
  topts.tsp_mult = 0; %% new
  topts.HITRAN   = '/asl/data/hitran/h16.by.gas';  %% new
  [wout,dout] = run8(2,Schunk,Schunk+25,fullname,topts);
  
  w = wout;
  d(lay,:) = dout;
  rmer = ['!/bin/rm ' fullname];
  eval(rmer);

  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM
end

saver = ['save ' finalname ' w d'];
eval(saver)
fprintf(1,'saver = %s \n',saver);

disp('done');
