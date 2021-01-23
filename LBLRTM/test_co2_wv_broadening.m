%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% see lnfl/src/lnfl.F, line 4312
%%               ADDDATA(1,IND) = HW_CO2_H2O(IW)
%%               ADDDATA(2,IND) = TEMP_CO2_H2O(IW)
%%               ADDDATA(3,IND) = SHFT_CO2_H2O(IW)
%%
%% see lblrtm/src/oprop.f90 line 804, it reads in all the broadeners
%%   which includes WV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[w,~,dlblrtm_co2_wv] = driver_glab_lblrtm_forn_MANYLAY_WVeffects_noN2con(2,655,680,'/home/sergio/SPECTRA/IPFILES/std_co2',[],-1,-1,40,0.0005); %% co2+wv
[w,~,dlblrtm_co2only] = driver_glab_lblrtm_forn_MANYLAY_noN2con(2,655,680,'/home/sergio/SPECTRA/IPFILES/std_co2',-1,-1,40,0.0005); %% co2 only
[w,~,dlblrtm_wvonly]  = driver_glab_lblrtm_forn_MANYLAY_noN2con(1,655,680,'/home/sergio/SPECTRA/IPFILES/std_water',-1,-1,40,0.0005); %% water only

figure(1); plot(w,dlblrtm_co2_wv-dlblrtm_co2only,w,dlblrtm_wvonly,'r')

%% thus
dlblrtm_co2_true = dlblrtm_co2_wv - dlblrtm_wvonly;
figure(2); 
subplot(211); plot(w,dlblrtm_co2_true-dlblrtm_co2only)
subplot(212); plot(w,dlblrtm_co2_true./dlblrtm_co2only)
