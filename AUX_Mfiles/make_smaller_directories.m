%% /scratch/sergio/RUN8_NIRDATABASE/UV25000_45000  has  862 files
%% /scratch/sergio/RUN8_NIRDATABASE/VIS12000_25000 has 2578 files
%% /scratch/sergio/RUN8_NIRDATABASE/NIR8250_12550  has 1720 files
%% /scratch/sergio/RUN8_NIRDATABASE/NIR5550_8200   has 2622 files
%% /scratch/sergio/RUN8_NIRDATABASE/NIR3550_5550   has 3377 files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iDo = -1;

if iDo > 0
  cd /scratch/sergio/RUN8_NIRDATABASE/NIR2830_3330

  mker = ['!mkdir 2830onwards']; eval(mker)
  for ii = 2805 : 25 : 3080-25
    mver = ['!mv std' num2str(ii) '_*.mat 2830onwards/.'];
    eval(mver);
    end

  mker = ['!mkdir 3080onwards']; eval(mker);
  for ii = 3080 : 25 : 3630
    mver = ['!mv std' num2str(ii) '_*.mat 3080onwards/.'];
    eval(mver);
    end

  cd /home/sergio/HITRAN2UMBCLBL/
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iDo = +1;

if iDo > 0
  cd /scratch/sergio/RUN8_NIRDATABASE/IR_605_2830_H08

  mker = ['!mkdir 0605onwards']; eval(mker)
  for ii = 605 : 25 : 1105-25
    mver = ['!/bin/mv std' num2str(ii) '_*.mat 0605onwards/.']
    eval(mver);
    end

  mker = ['!mkdir 1105onwards']; eval(mker);
  for ii = 1105 : 25 : 1805-25
    mver = ['!/bin/mv std' num2str(ii) '_*.mat 1105onwards/.']
    eval(mver);
    end

  mker = ['!mkdir 1805onwards']; eval(mker);
  for ii = 1805 : 25 : 2305-25
    mver = ['!/bin/mv std' num2str(ii) '_*.mat 1805onwards/.']
    eval(mver);
    end

  mker = ['!mkdir 2305onwards']; eval(mker);
  for ii = 2305 : 25 : 2855-25
    mver = ['!/bin/mv std' num2str(ii) '_*.mat 2305onwards/.']
    eval(mver);
    end

  cd /home/sergio/HITRAN2UMBCLBL/
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iDo = -1;
iDo = -1;
iDo = -1;

if iDo > 0
  cd /scratch/sergio/RUN8_NIRDATABASE/IR_605_2830_H08

  for ii = 605 : 25 : 1080
    for gg = 2 : 63
      for tt = 1 : 11
        fname = ['std' num2str(ii) '_' num2str(gg) '_' num2str(tt) '.mat'];
        ee = exist(fname);
        if ee > 0
          fprintf(1,'%4i %4i %4i \n',ii,gg,tt);
          checker = ['!diff ' fname '  0605onwards/. >& ugh'];
          eval(checker);
          dada = dir('ugh');
          if dada.bytes > 0
            catter = ['!cat ugh']; eval(catter);
            disp('cat')
            dodo1 = dir(fname)
            dodo2 = dir(['0605onwards/' fname])
            rmer = ['delete ' fname]; eval(rmer);
            rmer = ['delete 0605onwards/' fname]; eval(rmer);
            pause
            end
          end
        end
      end
    end

  cd /home/sergio/HITRAN2UMBCLBL/
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% /scratch/sergio/RUN8_NIRDATABASE/IR_605_2830_H08_WV has about 4730 files
%% /scratch/sergio/RUN8_NIRDATABASE/FIR500_605 has about 1731 files
%% /scratch/sergio/RUN8_NIRDATABASE/FIR300_510 has about 4400 files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iDo = -1;

if iDo > 0
  cd /scratch/sergio/RUN8_NIRDATABASE/FIR140_310

  mker = ['!mkdir 140onwards']; eval(mker)
  for ii = 135 : 5 : 215
    mver = ['!mv std' num2str(ii) '_*.mat 140onwards/.'];
    eval(mver);
    end

  mker = ['!mkdir 220onwards']; eval(mker);
  for ii = 220 : 5 : 315
    mver = ['!mv std' num2str(ii) '_*.mat 220onwards/.'];
    eval(mver);
    end

  cd /home/sergio/HITRAN2UMBCLBL/
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iDo = -1;

if iDo > 0
  cd /scratch/sergio/RUN8_NIRDATABASE/FIR80_150

  mker = ['!mkdir 80onwards']; eval(mker)
  for ii = 77.5 : 2.5 : 120-2.5
    mver = ['!mv std' num2str(ii) '_*.mat 80onwards/.'];
    eval(mver);
    end

  mker = ['!mkdir 120onwards']; eval(mker);
  for ii = 120 : 2.5 : 160
    mver = ['!mv std' num2str(ii) '_*.mat 120onwards/.'];
    eval(mver);
    end

  cd /home/sergio/HITRAN2UMBCLBL/
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
