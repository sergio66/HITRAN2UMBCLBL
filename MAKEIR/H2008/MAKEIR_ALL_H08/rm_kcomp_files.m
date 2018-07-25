dir0 = '/asl/s1/sergio/RUN8_NIRDATABASE/IR_605_2830_H08/kcomp/';

igas = [24 30 32:42 51:80];
for ii = 1 : length(igas)
  thedir = dir([dir0 'cg' num2str(igas(ii)) 'v*.mat']);
  if length(thedir) > 0
    for jj = 1 : length(thedir)
      thename = [dir0 thedir(jj).name];
      rmer = ['!/bin/rm ' thename]; eval(rmer)      
      end
    end
  end
