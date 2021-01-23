disp(' WARNING : this will ERASE all .mat files you have made!!!!')
disp(' WARNING : this will ERASE all .mat files you have made!!!!')
disp(' WARNING : this will ERASE all .mat files you have made!!!!')
disp(' WARNING : this will ERASE all .mat files you have made!!!!')

nbox = 5;
pointsPerChunk = 10000;
gid = 1;
  freq_boundaries

fprintf(1,'Will be removing files from eg %s \n',dirout);
iYes = input('Proceed anyway??? (-1/+1) ??? ');
if iYes < 0
  return
end

fprintf(1,'Will be removing files from eg %s \n',dirout);
iYes = input('Proceed anyway??? Yes (-1/+1) ??? ');
if iYes < 0
  return
end

fprintf(1,'Will be removing files from eg %s \n',dirout);
iYes = input('Proceed anyway??? Really (-1/+1) ??? ');
if iYes < 0
  return
end

fprintf(1,'Will be removing files from eg %s \n',dirout);
iYes = input('Proceed anyway??? Are you sure (-1/+1) ??? ');
if iYes < 0
  return
end

%% empty out individual dirs

for gid = 1 : 110
  freq_boundaries
  thedir = dir([dirout 'std*.mat']);
  if length(thedir) > 0
    fprintf(1,'emptying out dir for gasID %3i \n',gid);
    rmer = ['!/bin/rm ' dirout 'std*.mat'];
    eval(rmer);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now empty out the abs.dat dirs, which have the 1--11 toffsets in one big file

gid = 1;
  freq_boundaries
  thedir = dir([dirout '/abs.dat/*.mat']);
  if length(thedir) > 0
    fprintf(1,'emptying out ABS dir for gasID %3i \n',gid);
    rmer = ['!/bin/rm ' dirout '/abs.dat/*.mat'];
    eval(rmer);
  end

gid = 2;
  freq_boundaries
  dirout = dirout(1:end-8);
  thedir = dir([dirout '/abs.dat/*.mat']);
  if length(thedir) > 0
    fprintf(1,'emptying out ABS dir for gasID 2 - 81 \n');
    rmer = ['!/bin/rm ' dirout '/abs.dat/*.mat'];
    eval(rmer);
  end

