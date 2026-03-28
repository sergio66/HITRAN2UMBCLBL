%%% OLD WAY
%{
%% test eg JOB='0102230054'; clust_runXtopts_savegasN_file
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
JOB = getenv('SLURM_ARRAY_TASK_ID');
Sgid     = str2num(JOB(1:2));                        %% should be 1
Schunk   = str2num(JOB(3:7));                        %% for IR 605 : 25 : 2805
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;    %% should be 1 - 11 ---> -5 : +5
Sppmult  = str2num(JOB(10));                         %% should be 1 - 5
%}

%% to see what chunks should be made, check out
%% PARAMETER (kCompParamFile = 
%%     /home/sergio/KCARTA/SCRIPTS/MAKE_COMP_HTXY_PARAM_SC/PARAM_TEMP/testH2012_oldCO2

%%% NEW WAY gids to do == 
thefile = load('file_parallelprocess_wv.txt');   %%% 297 entries in there

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 1;
end
% JOB = 3*11 + 5;  %% so this is (third+1) gas == gas  1, offset 5, pp(1)
% JOB = 1*11 + 5;  %% so this is (sixth+1) gas == gas 12, offset 5

JOB = thefile(JOB);
JOB = num2str(JOB,'%010d');
Sgid     = str2num(JOB(1:2));
Schunk   = str2num(JOB(3:7));  
Stoffset = str2num(JOB(8:9)); Stt = Stoffset - 6;
Sppmult  = str2num(JOB(10));
