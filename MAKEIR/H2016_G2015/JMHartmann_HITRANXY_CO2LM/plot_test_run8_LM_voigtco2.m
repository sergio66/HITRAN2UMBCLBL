%% comes from special run of LM.x debug code
%% LM_calc_CO2_2017_kcarta_5ptboxcar_newdirDEBUG.for
wah = load('/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g2.dat_LM5ptbox_newOct18_400ppm/std0655_2_06_010')
wah = boxint_many(wah(1999:52003,:),5); wah = wah(:,1:10000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[w,dall] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% d is umbc VHH
topts.strongestline = 1;  %% VHH
[w,d] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot',topts);

topts.strongestline = 1; topts.LVG = 'G';
[w,dG] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot',topts);

topts.strongestline = 1; topts.LVG = 'GH';
[w,dGH] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot',topts);

topts.strongestline = 1; topts.LVG = 'GH'; topts.tsp_mult = 0.0;
[w,dGH0] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot',topts);

figure(1); plot(w,wah(2,:)./d,'b',w,wah(2,:)./dG,'r'); legend('LM Voigt/UMBC VH','LM Voigt/UMC Voigt'); grid

%% d is umbc VHH
mah = find(d == max(d),1)
clear nah; zah = d(1:mah-1); nah(1:mah) = d(1:mah); whos nah zah; nah(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah = nah(1:10000);
plot(w,d,w,nah)
semilogy(w,d,'b.-',w,nah,'r')

%% dG is umbc Voigt
mah = find(dG == max(dG),1)
clear nah; zah = dG(1:mah-1); nah(1:mah) = dG(1:mah); whos nah zah; nah(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah = nah(1:10000);
plot(w,dG,w,nah)
semilogy(w,dG,'b.-',w,nah,'r')
plot(w,dG./nah)

topts.strongestline = 1; topts.LVG = 'GH'; topts.tsp_mult = 0.0;  %% plus now the line center is rounded to nearest int
[w,dGH0] = run8(2,655,680,'/home/sergio/SPECTRA/IPFILES/co2one_hot',topts);
mah = find(dGH0 == max(dGH0),1);
mah = find(w >= 668-eps,1); w(mah)
clear nah; zah = dGH0(1:mah-1); nah(1:mah) = dGH0(1:mah); whos nah zah; nah(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah = nah(1:10000);
plot(w,dGH0,w,nah)
semilogy(w,dGH0,'b.-',w,nah,'r')
plot(w,dGH0./nah)

%% dvoigt = wah2(,:) from LM, and line center is rounded
lah = wah(2,:);
mah = find(lah == max(lah),1);
mah = find(w >= 668-eps,1); w(mah)
clear nah2; zah = lah(1:mah-1); nah2(1:mah) = lah(1:mah); whos nah2 zah; nah2(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah2 = nah2(1:10000);
plot(w,lah,w,nah2)
semilogy(w,lah,'b.-',w,nah2,'r')
plot(w,lah./nah2)

wahxx = wahx';
wahxx = wahxx(:,1:54000);
lah = wahxx(2,:);
mah = find(lah == max(lah),1);
mah = find(wahxx(1,:) >= 668-eps,1); wahxx(1,mah)
clear nah2; zah = lah(1:mah-1); nah2(1:mah) = lah(1:mah); whos nah2 zah; nah2(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah2 = nah2(1:54000);
plot(wahxx(1,:),lah,wahxx(1,:),nah2)
semilogy(wahxx(1,:),lah,'b.-',wahxx(1,:),nah2,'r')
plot(wahxx(1,:),lah./nah2)


%{
%%% this is from LM_calc_CO2_2017_kcarta_5ptboxcar_newdirDEBUG.for
ugh = load('/asl/data/hitran/H2016/LineMix/ugh');
wahxx = ugh';
wahxx10000 = boxint_many(wahxx(7,1999:52003),5); wahxx10000 = wahxx10000(1:10000);
wahxx = wahxx(:,1:54000);
lah = wahxx(7,:);
mah = find(lah == max(lah),1);
mah = find(wahxx(4,:) >= 668-eps,1); wahxx(4,mah)
clear nah2; zah = lah(1:mah-1); nah2(1:mah) = lah(1:mah); whos nah2 zah; nah2(mah+1:(mah+1)+(mah-1)-1) = fliplr(zah); nah2 = nah2(1:54000);
plot(wahxx(4,:),lah,wahxx(4,:),nah2)
semilogy(wahxx(4,:),lah,'b.-',wahxx(4,:),nah2,'r')
plot(wahxx(4,:),lah./nah2)
%}

figure(1); plot(w,dGH0./nah,w,lah./nah2)
figure(2); semilogy(w,dGH0,'b',w,nah,'c',w,lah,'r',w,nah2,'m'); grid
