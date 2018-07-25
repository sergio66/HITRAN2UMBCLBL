clear all; 

addpath /home/sergio/SPECTRA

%{
gids = input('Enter gasID list (or -1 to prompt for start/stop gasID) : ');
if gids == -1
  iA = input('Enter Start and Stop gasIDs : ');
  gids = iA(1) : iA(2);
end
%}

gids = [3 4 5 6 9 12];
gids = [3 4 5 6 9];

for gg = 1 : length(gids)
  iaCnt(gg) = 0;

  gid = gids(gg);

  nbox = 5;
  pointsPerChunk = 10000;
  freq_boundaries

  diroutX = [dirout '/g' num2str(gid) '.dat/'];
  diroutX = dirout;

  thedir = dir([diroutX '/std*.mat']);

  numfiles(gg) = length(thedir);
  badfiles(gg) = length(thedir);

  if length(thedir) > 0
    clear lala

    for ii = 1 : length(thedir)
      lala(ii) = thedir(ii).bytes;
      if thedir(ii).bytes <= eps
        fname = [diroutX '/' thedir(ii).name];
        rmer = ['!/bin/rm ' fname];
        fprintf(1,'  >> rm %s \n',fname);
        eval(rmer);
	iaCnt(gg) = iaCnt(gg) + 1;
      end
    end

    plot(lala);
    oo = find(lala <= eps);
    badfiles(gg) = length(oo);
    fprintf(1,'gas %2i found %5i bad files out of %5i or %6.2f chunks \n',gid,length(oo),length(thedir),length(thedir)/11)
  else
    fprintf(1,'no files in %s \n',diroutX);
  end

  %disp('ret'); pause;
  pause(0.1)
end

disp(' ')
disp('gid   number of empty files')
disp('---------------------------')
[gids; iaCnt]'
disp('---------------------------')
disp('now run loop_filelist_gN_missing')

figure(1)
plot(gids,numfiles,'bo-',gids,badfiles,'rx-');
hl = legend('All files','Bad files'); set(hl,'fontsize',10); grid
