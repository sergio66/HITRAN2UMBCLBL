fprintf(1,'making output directories for gas %2i to %2i \n',gids(1),gids(end));

for ii = 1 : length(gids)
  gid = gids(ii);
  freq_boundaries

  % fdir = ['/asl/s1/sergio/H2020_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gid) '.dat'];
  fdir = dirout;
  
  ee = exist(fdir,'dir');
  if ee == 0
    fprintf(1,'%s does not exist \n',fdir);
    % iYes = input('make dir??? (-1/+1) : ');
    iYes = 1
    if iYes > 0
      mker = ['!mkdir ' fdir];
      eval(mker);
      fprintf(1,'just made %s \n',fdir)
    end
  end

end

