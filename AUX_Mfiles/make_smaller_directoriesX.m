cd /scratch/sergio/RUN8_NIRDATABASE/FIR140_310

for ii = 220 : 5 : 315
  mver = ['!mv 140onwards/std' num2str(ii) '_*.mat 220onwards/.'];
  eval(mver);
  end

cd /home/sergio/HITRAN2UMBCLBL/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
