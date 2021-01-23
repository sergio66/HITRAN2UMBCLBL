%% https://rc.fas.harvard.edu/resources/documentation/convenient-slurm-commands/
%% To cancel all the pending jobs for a user:
%% scancel -t PENDING -u <username>
%%
%% or scancel -u sergio -q medium

%% http://www.brightcomputing.com/Blog/bid/174099/Slurm-101-Basic-Slurm-Usage-for-Linux-Clusters fpor SINGLETON delay

gid = 1;

iMake = +1
if iMake == 1
  do_make_WV_freq_list_for_cluster   %% make file_parallelprocess_allgases.txt plus script files
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iBlowAway = input('Blowaway (-1) none, do nothing (0) look at what is done, leave things alone (+1) look at done, blow away empty files : ');
if iBlowAway >= 0
  do_blow_away_empty
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iBlowAwayAll = input('Blow away all??? (-1/+1) : ');
if iBlowAwayAll > 0
  iBlowAwayAll = input('are you sure (-1/+1) : ');
end
if iBlowAwayAll > 0
  iBlowAwayAll = input('are you really sure (-1/+1) : ');
end
if iBlowAwayAll > 0
  for ggg = 1 : length(gid);
    gg = gid(ggg);
    iCnt = 0;    
    dirx = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gg) '.dat/lblrtm2/*.mat'];
    rmer = ['!/bin/rm ' dirx ];
    eval(rmer);
  end
end