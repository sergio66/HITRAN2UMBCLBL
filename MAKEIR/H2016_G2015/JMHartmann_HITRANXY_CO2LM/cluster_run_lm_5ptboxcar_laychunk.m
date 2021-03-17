addpath /home/sergio/SPECTRA

%% JOB can vary between 1 and length(g2_ir_list.txt) = 990 == 11 T offsets * 90 chunks = from 020060501 to 020283011
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%% JOB = 1

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 02 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('g2_ir_list.txt');
%% gasIDlist = load('g2_ir_list_notdone.txt');  %% see runXtopts_mkgNvfiles_10layerchunks

XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end
fprintf(1,'JOB = %2i XJOB = %s \n',JOB,XJOB);

%% laychunk = 6    %% for debugging
if ~exist('laychunk')
  error('need laychunk variable  : laychunk = 1 -- 10 since we have 100 layers (100/10 = 10) ')
else
  fprintf(1,'laychunk = %2i \n',laychunk);
end
layers = (1 : 10) + (laychunk-1)*10;
startlay = layers(1);
stoplay  = layers(end);
fprintf(1,'laychunk = %2i : start/stop layers = %3i %3i \n',laychunk,startlay,stoplay);
  
useCO2ppm = 385;  %% mistakenly used this for first set of runs
useCO2ppm = 400;  %% let us fix this

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));
Stoffset = str2num(XJOB(8:9));    %Stt = Stoffset - 6;

%%% junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '.mat'];
junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '_laychunk_' num2str(laychunk) '.mat'];  %% should have been this, have to rename things

outputdir

if ~exist(output_dir5)
  output_dir5
  error('output_dir5 DNE')
end

if ~exist([output_dir5 '/' num2str(laychunk)])
  mker = ['!mkdir ' [output_dir5 '/' num2str(laychunk)]];
  eval(mker)
end

finalname = [output_dir5 '/' num2str(laychunk) '/std' junkstr];
if exist(finalname)
  fprintf(1,'%s already exists .. why bother running???? \n',finalname)
  error('file already exists')
end

layx = 0;
homedir = pwd;
for lay = startlay : stoplay
  layx = layx + 1;
   
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM
  cder = ['cd ' homedir];
  eval(cder)
  
  fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);
  fprintf(1,'  layer = %3i \n',lay)
  
  load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres(lay);
  pco2 = refpro.gpart(lay,2) * useCO2ppm/385;
  layT = refpro.mtemp(lay) + (Stoffset-6)*10;   %% note : F77 executable does NOT further adjust offset, whew ... except for output fname
  qamt = refpro.gamnt(lay,2) * useCO2ppm/385;   %% adjust ppmv
  fprintf(1,'  from refpro p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',ptot,pco2,layT,qamt)
  
  %cp /home/sergio/SPECTRA/IPFILES/std_gx2x_6 .
  xdata = load('std_gx2x_6');
  xdata = xdata(lay,:);
  xptot = xdata(2);
  xpco2 = xdata(3) * useCO2ppm/385;
  xlayT = xdata(4)  + (Stoffset-6)*10; %% note : F77 executable does NOT further adjust offset, whew ... except for output fname
  xqamt = xdata(5) * useCO2ppm/385;    %% adjust ppmv;
  fprintf(1,'  from std_gx2x_6 p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',xptot,xpco2,xlayT,xqamt)
  
  iNewOrOld = 2021;

  fname = ['inputparam_5pointboxcar' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  fprintf(1,'%s \n',fname);
  fid = fopen(fname,'w');

  if iNewOrOld < 2021
    fprintf(fid,'%5i \n',Schunk);
  else
    fprintf(fid,'%5i %5i %10.6f \n',Schunk,Schunk+25,0.0005);
  end
  fprintf(fid,'%10.6e %10.6e \n',ptot,pco2);  
  fprintf(fid,'%10.6f \n',layT);
  fprintf(fid,'%10.6e \n',qamt);
  fprintf(fid,'%2i %3i \n',lay,Stoffset);  
  fclose(fid);

  %cd /asl/data/hitran/H2016/LineMix
  cd /asl/data/hitran/H2016/LineMix_MainCode
  fullname = ['/home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/' fname];
  fullname = ['/home/sergio//HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/' fname];  
  junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];

  if iNewOrOld < 2021
    fortran_exec = 'lm_kcarta.x';                     %% at 0.0025 cm-1 res
    fortran_exec = 'lm_kcarta_5ptboxcar.x';
    fortran_exec = 'lm_kcarta_5ptboxcar_noWVbroad.x';
    fortran_exec = 'lm_kcarta_5ptboxcar_new.x';        %% Oct 2018, fixed Qtips, voigt vs loretz, line strength adjustment etc
    fortran_exec = 'lm_kcarta_5ptboxcar_new2.x';       %% Nov 2018, fixed Qtips, voigt vs loretz, line strength adjustment etc
    fortran_exec = 'lm_kcarta_5ptboxcar_new3.x';       %% Nov 2018, fixed Qtips, voigt vs loretz, line strength adjustment etc    
  elseif iNewOrOld == 2021
    fortran_exec = 'driver_lm0_gascell.x';             %% Mar 2021, approved by Iouli/Hashemi
  end

  lmer = ['!time ' fortran_exec ' < ' fullname]
  eval(lmer);
  
  rmer = ['!/bin/rm ' fullname];
  eval(rmer);
  
  outname  = [output_dir5 '/std' junkstr];  %% this is all in the executable of lm_kcarta.x
  lalaHI = load(outname);

  %% suppose you want to do the               655 : 0.0025 : 680 chunk
  %% the LM code that is called actually does 654 : 0.0005 : 681 chunk
  %% 655 is the 02001 st point (but you have to go 2 before for the 5pt box car integ)
  %% 680 is the 52001 st point (but you have to go 2 later  for the 5pt box car integ) 
  %lalaHI = lalaHI(1999:52003,:);
  lala = boxint_many(lalaHI(1999:52003,:),5);
  lala = lala';

  w = lala(1:10000,1);
  dvoigt(layx,:) = lala(1:10000,2);
  dfirst(layx,:) = lala(1:10000,3);
  dfull(layx,:)  = lala(1:10000,4);  
  rmer = ['!/bin/rm ' outname];
  eval(rmer);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saver = ['save ' finalname ' w dvoigt dfirst dfull laychunk layers'];
eval(saver)
fprintf(1,'saver = %s \n',saver);

disp('done .. now run runXtopts_mkgNvfiles_10layerchunks.m');
