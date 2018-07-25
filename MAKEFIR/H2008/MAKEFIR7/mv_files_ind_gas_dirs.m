for ii = 1 : 42
  thedir = ['g' num2str(ii)];
  ee = exist(thedir,'dir');
  if ee == 0
    mker = ['!/bin/mkdir g' num2str(ii)];
    eval(mker);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1 : 1
  filenames = ['std*_' num2str(ii) '_*_*.mat'];
  ee = dir(filenames);
  if length(ee) > 0
    ii
    mver = ['!/bin/mv ' filenames ' g' num2str(ii) '/.'];
    %eval(mver);
  end
end

for ii = 2 : 25
  filenames = ['std*_' num2str(ii) '_*.mat'];
  ee = dir(filenames);
  if length(ee) > 0
    ii
    mver = ['!/bin/mv ' filenames ' g' num2str(ii) '/.'];
    eval(mver);
  end
end
