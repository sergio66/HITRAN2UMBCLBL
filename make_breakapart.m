cd /asl/data/hitran/2012

fdir0 = ['../h12.by.gas/'];
if ~exist(fdir0,'dir')
  mker = ['!mkdir -p ' fdir0];
  eval(mker)
end

fTAPE7 = '57e00072.par'; %% downloaded from HITRAN website

for ii = 1 : 47
  fprintf(1,' making file %2i \n',ii)
  fOUT = ['../h12.by.gas/g' num2str(ii) '.dat'];  
  
  if ii < 10
    grepper = ['!grep "^ ' num2str(ii) '[1-9]" ' fTAPE7 ' > junk.lines'];
  else
    grepper = ['!grep "^'  num2str(ii) '[1-9]" ' fTAPE7 ' > junk.lines'];
  end
  eval(grepper)

  %% remove junk chars 
  trer = ['!tr -d ''\015\032'' < junk.lines  > ' fOUT];
  eval(trer);
end