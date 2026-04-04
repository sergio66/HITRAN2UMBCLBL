%{
%% see /home/sergio/SPECTRA/n2_o2_continuum_range_ckd3p2_ckd4p3.m
%% this is for CKD 4.3
o2range = [1280        1840];  %% CKD continuum dies at 1350 cm-1, but HITRAN2024 says there are weak lines at 1290 cm-1

n2range = [1997.790    2900];
n2range = [1930.00     2900];  %% CKD continuum dies at 1997 cm-1, but HITRAN2024 says there are weak lines at 1930 cm-1
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Toff = input('Enter Toffset (1:11, 6 is default) : ');
if length(Toff) == 0
  Toff = 6;
end

figure(1); clf; hold on
figure(2); clf; hold on
for ff = 1280 : 25 : 1830
  driver_compare_newVSold_N2_O2(7,ff,Toff);
end   
figure(1); hold off
figure(2); hold off

figure(1); ylim([0.999 1.005])
figure(2); title('O2')

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; hold on
figure(2); clf; hold on
for ff = 1930 : 25 : 2830
  driver_compare_newVSold_N2_O2(22,ff,Toff);
end   
figure(1); hold off
figure(2); hold off

figure(1); ylim([0.999 1.05])
figure(2); title('N2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
