JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 3;
end

cmprunIR_umbcLBL_all(JOB);
