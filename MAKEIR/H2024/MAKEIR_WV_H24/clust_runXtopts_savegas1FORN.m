% run this with     sbatch --array=1-90 --output='/dev/null' sergio_matlab_chip_makegas1_103.sbatch 8 for FORN

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 1;
end

runXtopts_savegas1FORN
