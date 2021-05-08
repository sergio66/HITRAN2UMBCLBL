function out = lm_gas_cell(Schunk1,Schunk2,ptot,pco2,layT,qamt)

%% Enter TOTAL and CO2 partial pressure in atm :  ptot,pco2
%% Enter T in K : layT
%% Enter layer CO2  amount in kilomoles/cm2 : qamt

Stoffset = 0;
lay = 1;

addpath /home/sergio/SPECTRA

disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
    
%% all this needs to be set by the driver .. see eg
%% /asl/data/hitran/H2016/LineMix/CrIS_Data/do_run8_run8co2_lblrtm_lm.m
  
cd /home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/

iNewOrOld = 2021;
  
fname = ['gascell_inputparam_5pointboxcar' num2str(Schunk1,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
fprintf(1,'%s \n',fname);
fid = fopen(fname,'w');
if iNewOrOld < 2021
  fprintf(fid,'%5i \n',Schunk1);
else
  fprintf(fid,'%5i %5i %10.6f \n',Schunk1,Schunk2,0.0005);
end
fprintf(fid,'%10.6e %10.6e \n',ptot,pco2);  
fprintf(fid,'%10.6f \n',layT);
fprintf(fid,'%10.6e \n',qamt);
fprintf(fid,'%2i %3i \n',lay,Stoffset);  
fclose(fid);

fullname = ['/home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/' fname];
junkstr = [num2str(Schunk1,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];

%cd /asl/data/hitran/H2016/LineMix/
cd /asl/data/hitran/H2016/LineMix_MainCode
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

lmer = ['!time ' fortran_exec ' < ' fullname];  
eval(lmer);
  
rmer = ['!/bin/rm ' fullname];
eval(rmer);

cd ~/HITRAN2UMBCLBL/MAKEIR/H2016_G2015/JMHartmann_HITRANXY_CO2LM/
outputdir                                  %%% NEED THIS TO SET THE DIRS
outname  = [output_dir5 '/std' junkstr];   %% this is all in the executable of lm_kcarta.x
lalaHI = load(outname);

%% suppose you want to do the               655 : 0.0025 : 680 chunk
%% the LM code that is called actually does 654 : 0.0005 : 681 chunk
%% 655 is the 02001 st point (but you have to go 2 before for the 5pt box car integ)
%% 680 is the 52001 st point (but you have to go 2 later  for the 5pt box car integ) 
%lalaHI = lalaHI(1999:52003,:);

span = (Schunk2-Schunk1)/0.0005;
lala = boxint_many(lalaHI(1999:1999+span+4,:),5);
lala = lala';

iaInd = 1:(Schunk2-Schunk1)/0.0025;
out.w = lala(iaInd,1);
out.dvoigt = lala(iaInd,2);
out.dfirst = lala(iaInd,3);
out.dfull  = lala(iaInd,4);  

rmer = ['!/bin/rm ' outname];
eval(rmer);
