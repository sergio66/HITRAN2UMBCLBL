function out = lm_gas_cell(Schunk,ptot,pco2,layT,qamt,Stoffset,lay);

addpath /home/sergio/SPECTRA

  disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
  disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
  disp('PLEASE MAKE SURE no other copies of lm_kcarta_5ptboxcar_noWVbroad.x are running, else you will step on the output')
    
  %% all this needs to be set by the driver .. see eg
  %% /asl/data/hitran/H2016/LineMix/CrIS_Data/do_run8_run8co2_lblrtm_lm.m
  if ~exist('Schunk')
    error('make sure driver file sets Schunk')
  end    
  if ~exist('ptot')
    error('make sure driver file sets ptot')
  end    
  if ~exist('pco2')
    error('make sure driver file sets pco2')
  end
  if ~exist('layT')
    error('make sure driver file sets layT')
  end
  if ~exist('qamt')
    error('make sure driver file sets qamt')
  end
  if ~exist('Stoffset')
    error('make sure driver file sets Stoffset')
  end      
  if ~exist('lay')
    error('make sure driver file sets lay')
  end
  
  cd /home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/
  outputdir
  
  fname = ['gascell_inputparam_5pointboxcar' num2str(Schunk,'%04d') '_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];
  fprintf(1,'%s \n',fname);
  fid = fopen(fname,'w');
  fprintf(fid,'%5i \n',Schunk);
  fprintf(fid,'%10.6e %10.6e \n',ptot,pco2);  
  fprintf(fid,'%10.6f \n',layT);
  fprintf(fid,'%10.6e \n',qamt);
  fprintf(fid,'%2i %3i \n',lay,Stoffset);  
  fclose(fid);

  fullname = ['/home/sergio/HITRAN2UMBCLBL/JMHartmann_HITRANXY_CO2LM/' fname];
  junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '_' num2str(lay,'%03d')];

  cd /asl/data/hitran/H2016/LineMix/
  fortran_exec = 'lm_kcarta.x';  %% at 0.0025 cm-1 res
  fortran_exec = 'lm_kcarta_5ptboxcar_noWVbroad.x';    %% this is garbage
  fortran_exec = 'lm_kcarta_5ptboxcar.x';
  lmer = ['!' fortran_exec ' < ' fullname];  
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

  out.w = lala(1:10000,1);
  out.dvoigt = lala(1:10000,2);
  out.dfirst = lala(1:10000,3);
  out.dfull  = lala(1:10000,4);  
  rmer = ['!/bin/rm ' outname];
  eval(rmer);
