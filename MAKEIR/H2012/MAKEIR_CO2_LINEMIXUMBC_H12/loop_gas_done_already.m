clear freqchunk0 numchunk0 iCnt0 iDone0
if exist('numchunk')
  freqchunk0 = freqchunk;
  numchunk0  = numchunk;
  iCnt0      = iCnt;
  iDone0     = iDone;
end

[freqchunk, numchunk, iCnt, iDone] = gas_done_already(2);

figure(1); clf;
if exist('numchunk0')
  plot(freqchunk,numchunk0,'bx-',freqchunk,numchunk,'ro-');
  ylabel('prev done (b)  now done (r)');
else
  plot(freqchunk,numchunk,'ro-');
  ylabel('now done (r)');
end