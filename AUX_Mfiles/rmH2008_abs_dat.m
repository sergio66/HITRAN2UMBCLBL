%% since the files in eg 
%%    /asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/abs.dat
%% are simply concatted versions of whhat is in eg
%%   /asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g3.dat
%%   /asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g4.dat
%%   /asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/g5.dat
%% we can simply blow the files in abs.dat away

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08/abs.dat/';
for gg = 3 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_WV/abs.dat/';
for gg = 1 : 1
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_WV/abs_ALLISO.dat/';
for gg = 1 : 1
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

%{
fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/abs.dat/';
for gg = 2 : 2
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR15_30/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR30_50/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2008_RUN8_NIRDATABASE/FIR50_80/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR140_310/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR300_510/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/FIR500_605/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR2830_3330/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR3550_5550/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR5550_8200/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/NIR8250_122550/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/VIS12000_25000/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end

fdir = '/asl/s1/sergio/H2004_RUN8_NIRDATABASE/UV25000_45000/abs.dat/'
for gg = 1 : 99
  rmer = ['!/bin/rm ' fdir 'g' num2str(gg) 'v*.mat'];
  fprintf(1,'removing %s \n',rmer);
  eval(rmer);
end
