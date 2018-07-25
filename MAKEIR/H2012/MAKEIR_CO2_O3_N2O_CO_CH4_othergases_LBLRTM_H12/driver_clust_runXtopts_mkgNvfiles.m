xgid = [[2:32] [51:63]];
for loopJOB = 1 : length(xgid)
  JOB = xgid(loopJOB);
  figure(1); clf
  figure(2); clf
  clust_runXtopts_mkgNvfiles
end
