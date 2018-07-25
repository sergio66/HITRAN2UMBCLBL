%%% oops, I mistakenly kept adding in N2 for gasIDs 8-32 ... bah, redo 1955-2805

gid = 8:32;

%{
for ii = 1 : length(gid)
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid(ii)) '.dat/lblrtm2/std2[012345678]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)
end
%}

%{
for ii = 1 : length(gid)
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid(ii)) '.dat/lblrtm2/std19[58]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)
end
%}

for ii = 1 : length(gid)
  %% remove files where ODs are concatted together
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/lblrtm2/all/abs.dat/g' num2str(gid(ii)) 'v19[58]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/lblrtm2/all/abs.dat/g' num2str(gid(ii)) 'v2[012345678]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)

  %% remove the compressed files
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm2/all/kcomp/cg' num2str(gid(ii)) 'v19[58]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)
  rmer = ['!/bin/rm /asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830//lblrtm2/all/kcomp/cg' num2str(gid(ii)) 'v2[012345678]*.mat'];
  fprintf(1,'%s \n',rmer);
  eval(rmer)
end
