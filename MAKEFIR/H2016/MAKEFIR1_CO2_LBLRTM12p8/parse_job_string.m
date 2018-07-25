%%% OLD WAY
%{
%% test eg JOB='020223005'; clust_runXtopts_savegasN_file
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
JOB = getenv('SLURM_ARRAY_TASK_ID');
Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% to see what chunks should be made, check out
%% PARAMETER (kCompParamFile = 
%%     /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC/PARAM_TEMP/testH2012_oldCO2

%%% NEW WAY gids to do == [[4] [7:47]] = [4 7 8 9 10 11 12 13 14 15 16 ...]
%% file will contain AB CDEFG HI  which are gasID, wavenumber, temp offset   
%%                   12 34567 89
%% where gasID = 01 .. 99,   HI = 1 .. 11 (for Toff = -5 : +5) and wavenumber = 00050:99999
%% JOB = '630060506'    is what the entries in file_parallelprocess_allgases.txt look like

%% see do_make_gas_freq_list_for_cluster.m
%thefile = load('file_parallelprocess_allgases.txt');  %%% 297 entries in there
%thefile = load('file_parallelprocess_gas_2_6.txt');   %%% 22 entries in there
thefile = load('file_parallelprocess_CO2.txt');       %%% 11 entries in there
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));

% JOB = 10*11 + 5;
% JOB = 3*11 + 5;  %% so this is (third+1) gas == gas  9, offset 5
% JOB = 6*11 + 5;  %% so this is (sixth+1) gas == gas 12, offset 5
% JOB = 10*11 + 5; %% so this is (tenth+1) gas == gas 16, offset 5

JOB = thefile(JOB);
JOB = num2str(JOB,'%09d');

Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;
