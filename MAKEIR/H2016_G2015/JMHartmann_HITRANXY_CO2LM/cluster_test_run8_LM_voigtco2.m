%% recall for any layer pp V = n R T ==> L n/V = q = L pp/RT
%% now for run8 we keep changing the temp (T = T0(i) + (offset*10))  but keep q the same 
%% L0/T0 = Lx/Tx ==> Lx = L0/T0 * Tx ~ Tx/T0

addpath /home/sergio/SPECTRA/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 083   %% do the 780 cm-1 chunk      %% 6 + (7*11) = 83

%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset
%%                   12 34567 89
%% where gasID = 02 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999

gasIDlist = load('g2_ir_list_FIR.txt');
gasIDlist = load('g2_ir_list.txt');
XJOB = num2str(gasIDlist(JOB));
if length(XJOB) == 8
  XJOB = ['0' num2str(gasIDlist(JOB))];
end

useCO2ppm = 385;  %% mistakenly used this for first set of runs
useCO2ppm = 400;  %% not yet done

Sgid     = str2num(XJOB(1:2));
Schunk   = str2num(XJOB(3:7));
Schunk   = str2num(XJOB(3:7));
Stoffset = str2num(XJOB(8:9));    %Stt = Stoffset - 6;

%%% junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '.mat'];
junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '.mat'];  %% should have been this, have to rename things
outputdir
finalname = [output_dirRUN8 '/sampleT_' junkstr];
if exist(finalname)
  fprintf(1,'%s already exists .. why bother running???? \n',finalname)
  disp('file already exists')
  return
end

homedir = pwd;
for lay = 1 : 7
  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM
  cder = ['cd ' homedir];
  eval(cder)
  fprintf(1,'JOB String = %s    parsed to gid = %2i chunk = %5i Stoffset = %2i \n',XJOB,Sgid,Schunk,Stoffset);
  fprintf(1,'  layer = %3i \n',lay)
  
  load /home/sergio/HITRAN2UMBCLBL/REFPROF/refproTRUE.mat         %% symbolic link
  ptot = refpro.mpres(5);
  pco2 = refpro.gpart(5,2)  * useCO2ppm/385;
  layT = 200 + (lay-1)*20;
  qamt = refpro.gamnt(5,2)  * useCO2ppm/385;
  fprintf(1,'  from refpro p/pp/T/q = %8.6f %8.6f %8.6f %8.6e \n',ptot,pco2,layT,qamt)
  
  fname = ['inputparam_' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  fid = fopen(fname,'w');
  fprintf(fid,'%4i %10.6e %10.6e %10.6f %10.6e \n',lay,ptot,pco2,layT,qamt); 
			       %% see also /asl/data/hitran/H2016/LineMix/LM_calc_CO2_2017_kcarta.for
  fclose(fid);
  fullname = ['/home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/' fname];

  %%%%%%%%%%%%%%%%%%%%%%%%%
  cd /home/sergio/SPECTRA
  topts.xfar = 0250;
  topts.xfar = 0500;
  topts.xfar = 1250;
  topts.xfar = 2500;    

% real      fstep          wide mesh width size (cm-1)           1.0
% real      xnear          near wing distance(cm-1)              1.0
% real      xmed           med wing distance(cm-1)               2.0
% real      xfar           far wing distance(cm-1)               25.0

  %%% this is default for 605-2830 cm-1
  topts.fstep = 1;
  topts.xnear = 1;
  topts.xmed = 2;

  %% new for /asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_run8_H2016params_400ppm_tsp0/ checking how things look WITH NO PRESSURE SHIFT, ORIG HITRAN2016 params
  %topts.tsp_mult = 0; %% new
  topts.HITRAN   = '/asl/data/hitran/h16.by.gas';   %% for these tests just run H2016 ... could be running H2018
  topts.LVG = 'GH';                                 %% humlicek voigt, default is voivec vanhuber
  [wout,dout] = run8(2,Schunk,Schunk+25,fullname,topts);
  
  w = wout;
  d(lay,:) = dout;
  rmer = ['!/bin/rm ' fullname];
  eval(rmer);
  %%%%%%%%%%%%%%%%%%%%%%%%%

  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM

  %%%%%%%%%%%%%%%%%%%%%%%%%

  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM
  fname = ['inputparam_5pointboxcar' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
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
  fullname = ['/home/sergio//HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/' fname];  
  junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];

  fortran_exec = 'lm_kcarta.x';                     %% at 0.0025 cm-1 res
  fortran_exec = 'lm_kcarta_5ptboxcar.x';
  fortran_exec = 'lm_kcarta_5ptboxcar_noWVbroad.x';
  fortran_exec = 'lm_kcarta_5ptboxcar_new.x';       %% Oct 2018`

  outname  = [output_dir5 '/std' junkstr];  %% this is all in the executable of lm_kcarta.x
  if exist(outname)
    rmer = ['!/bin/rm ' outname];
    eval(rmer)
  end
  
  lmer = ['!time ' fortran_exec ' < ' fullname];  
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
  dvoigt(lay,:) = lala(1:10000,2);
  dfirst(lay,:) = lala(1:10000,3);
  dfull(lay,:)  = lala(1:10000,4);  
  rmer = ['!/bin/rm ' outname];
  eval(rmer);

  %%%%%%%%%%%%%%%%%%%%%%%%%

  cd /home/sergio/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM

  %%%%%%%%%%%%%%%%%%%%%%%%%

  %saver = ['save ' finalname ' w d '];
  saver = ['save ' finalname ' wout d    w dvoigt dfirst dfull topts'];
  eval(saver)

end

%% now run compare_run8_LM_voigtco2.m

%saver = ['save ' finalname ' w d '];
saver = ['save ' finalname ' wout d    w dvoigt dfirst dfull topts'];
eval(saver)
fprintf(1,'saver = %s \n',saver);

disp('done');

plot(w,d./dvoigt)
plot(w,d(1,:),w,dvoigt(1,:)); hl = legend('UMBC','LM Voigt');
 
ix = find(w >= 800.75,1);
plot(200:20:320,dvoigt(:,ix)./d(:,ix),'o-'); hl = legend(num2str((200:20:320)'));
P = polyfit(200:20:320,dvoigt(:,ix)'./d(:,ix)',1);
%% now find T where the ratio = 1    y = mx+c ==> x = (y-c)/m
(1-P(2))/P(1)

T0 = refpro.mtemp(5);
factor = (200:20:320)/T0;

wahfactor = dvoigt(:,ix)./d(:,ix);

[factor; wahfactor'; factor.*wahfactor']

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
plot_test_run8_LM_voigtco2
%}
