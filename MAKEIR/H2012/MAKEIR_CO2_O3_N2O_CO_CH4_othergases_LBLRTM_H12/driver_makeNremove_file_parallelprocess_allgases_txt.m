%% https://rc.fas.harvard.edu/resources/documentation/convenient-slurm-commands/
%% To cancel all the pending jobs for a user:
%% scancel -t PENDING -u <username>
%%
%% or scancel -u sergio -q medium

%% http://www.brightcomputing.com/Blog/bid/174099/Slurm-101-Basic-Slurm-Usage-for-Linux-Clusters fpor SINGLETON delay

gid = 13:32;
gid = [[4] [7:32]];
gid = 2:32;
gid = [[4] [7:29] 31 32];

gid = [[8:29] [31 32]];            %%% fix mistake in molgas 2005-2805 cm-1
gid = [[2:29] [31 32] [51:63]];    %%% make all v12.2
gid = [[2:47]  [51:63]];    %%% make all v12.4

gid = [[2:29] [31:34] [36:41] [43:47]];            %%% make mlolgas v12.4
gid = [[2:29] [31:34] [36:41] [43:47] [51:81]];    %%% make all v12.4

figure(1); clf
iCheckLines = +1;
if iCheckLines > 0
  do_check_lines    %% loop over check(ggg,vstep) = findlines_plot(vmin-dv,vmax+dv,gg);
end

iMake = +1;
if iMake == 1
  fmin = 2005; %% oops, made a mistake for gases 8-32 (kept adding in N2 lines, which start at 1960
  fmin = 1955; %% oops, made a mistake for gases 8-32 (kept adding in N2 lines, which start at 1960
  fmin = 605;  %% start from the beginning  
  fminSTR = num2str(fmin,'%05d');
  do_make_gas_freq_list_for_cluster   %% make file_parallelprocess_allgases.txt plus script files
end

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