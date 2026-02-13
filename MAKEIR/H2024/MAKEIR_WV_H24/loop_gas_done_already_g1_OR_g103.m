addpath /home/sergio/SPECTRA

iRmEmptyFiles = input('iRemoveEmptyFiles = -1/+1 (default = -1) : ');
if length(iRmEmptyFiles) == 0
  iRmEmptyFiles = -1;
end

iaG = [1 103 110];
iaG = [1 103    ];
for ii = 1 : length(iaG)
  %gas_done_already(ii);
  gas_done_already_g1_OR_g103(iaG(ii),iRmEmptyFiles);
  disp('ret to continue : '); pause
end
