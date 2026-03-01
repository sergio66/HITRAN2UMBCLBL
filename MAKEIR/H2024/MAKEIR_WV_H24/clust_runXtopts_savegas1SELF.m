% run this with     sbatch --array=1-90 --output='/dev/null' sergio_matlab_chip_makegas1_103.sbatch 7 for SELF

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 58;
  JOB = 65;
  JOB = 69;    
end

runXtopts_savegas1SELF
