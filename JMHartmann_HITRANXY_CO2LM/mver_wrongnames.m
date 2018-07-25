for ff = 605 : 25 : 2830
  for kk = 1 : 11
    Schunk = ff;
    Stoffset = kk;

    junkstr = [num2str(Schunk,'%04d') '_2_' num2str(Stoffset,'%02d') '.mat'];
    fin = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/std' junkstr];

    junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '.mat'];  %% should have been this, have to rename things
    fout = ['/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM/std' junkstr];

    fprintf(1,'%s %s \n',fin,fout)
    if exist(fin) & length(fin) ~= length(fout)
      mver = ['!mv ' fin ' ' fout];
      eval(mver)
      %fprintf(1,'%s \n',mver)
    end
  end
end  