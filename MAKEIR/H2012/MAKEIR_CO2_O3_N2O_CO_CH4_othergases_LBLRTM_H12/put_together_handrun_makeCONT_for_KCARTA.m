dirCKD_KCARTA = '/asl/data/kcarta/ckd/';
dirCKD_KCARTA = '/asl/data/kcarta_sergio/KCDATA/General/CKDieee_le/';

w1 = [ 100  600 1100 1600 2100 2600];
w2 = [ 600 1100 1600 2100 2600 3001];

Tckd = 100 : 10 : 400;
mlaynum = 1 : length(Tckd);
mpres  = 1.0 * ones(size(mlaynum));
mppres = 0.1 * ones(size(mlaynum));
mgamnt = 1e-6 * ones(size(mlaynum));
profileALLT = [mlaynum; mpres; mppres; Tckd; mgamnt];

p   = profileALLT(2,:)*1013.25; %% p in atm --> mb
pp  = profileALLT(3,:)*1013.25; %% pp in atm --> mb
p   = profileALLT(2,:);         %% p in atm
pp  = profileALLT(3,:);         %% pp in atm
T   = profileALLT(4,:);         %% T in kelvin
amt = profileALLT(5,:);         %% amount in kilomoles/cm2
amt = amt * 6.022140857e26;    %% amount in molecules/cm2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gid = 101;
wall = [];
od = [];
fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g101.dat/lblrtm2/';
for ff = 1 : length(w1)
  if ff < length(w1)
    find = (1:500) + (ff-1)*500; 
  else
    find = (1:401) + (ff-1)*500;
  end
  findS(ff) = find(1);
  findE(ff) = find(end);  
  for lay = 1 : length(Tckd)
    fname = [fdir '/make_ckd_layer_' num2str(lay,'%03d') '_' num2str(w1(ff)) '_' num2str(w2(ff)) '_101.mat'];
    x = load(fname);
    od(find,lay) = x.d;
  end
  wall(find)  = x.w;
end

rConvFac = 1;               %% or 6.023e-23
kPlanck2 = 1.4387863;

if gid == 101
  mult = amt .* pp;
elseif gid == 102
  mult = amt .* (p-pp);
end
a1 = mult * 296 ./ T;
a2 = kPlanck2/2 ./T;
%% OD = rConvFac * CKD coeff * a1 .* wall .* tanh(a2*wall); %% to go from CKD coeff to OD
for lay = 1 : length(Tckd)
  ckd101(:,lay) = od(:,lay) ./ (rConvFac .* a1(lay) .* wall' .* tanh(a2(lay)*wall'));
end

if gid == 102
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor1.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor6.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor25.bin']);  
else
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf1.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf6.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf25.bin']);  
end

if abs(sum(Tckd-xTckd')) > eps
  error('Tckd incompatible')
end

if freq(1) > wall(1)
  for lay = 1 : length(Tckd)
    junkckd101(:,lay) = interp1(wall,ckd101(:,lay),freq);
  end
else
  junkckd101 = ckd101;
end

figure(1); clf; semilogy(freq,junkckd101,'r',freq,k,'b')
  title('SELF (b) : CKD 6 (r) CKD 2.7');
figure(2); clf; plot(freq,junkckd101 ./ k','b')
  title('SELF CKD 2.7 / CKD 6');

iWrite = input('write out file??? (-1/+1) : ');
if iWrite > 0
  write_ckd_lookup(dirCKD_KCARTA,27,wall,ckd101',-1);
end

disp('ret to continue '); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gid = 102;
wall = [];
od = [];
fdir = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g102.dat/lblrtm2/';
for ff = 1 : length(w1)
  if ff < length(w1)
    find = (1:500) + (ff-1)*500; 
  else
    find = (1:401) + (ff-1)*500;
  end
  findS(ff) = find(1);
  findE(ff) = find(end);  
  for lay = 1 : length(Tckd)
    fname = [fdir '/make_ckd_layer_' num2str(lay,'%03d') '_' num2str(w1(ff)) '_' num2str(w2(ff)) '_102.mat'];
    x = load(fname);
    od(find,lay) = x.d;
  end
  wall(find)  = x.w;
end

rConvFac = 1;               %% or 6.023e-23
kPlanck2 = 1.4387863;

if gid == 101
  mult = amt .* pp;
elseif gid == 102
  mult = amt .* (p-pp);
end
a1 = mult * 296 ./ T;
a2 = kPlanck2/2 ./T;
%% OD = rConvFac * CKD coeff * a1 .* wall .* tanh(a2*wall); %% to go from CKD coeff to OD
for lay = 1 : length(Tckd)
  ckd102(:,lay) = od(:,lay) ./ (rConvFac .* a1(lay) .* wall' .* tanh(a2(lay)*wall'));
end

if gid == 102
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor1.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor6.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDFor25.bin']);  
else
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf1.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf6.bin']);
  [k,freq,xTckd] = contread2([dirCKD_KCARTA 'CKDSelf25.bin']);  
end

if abs(sum(Tckd-xTckd')) > eps
  error('Tckd incompatible')
end

if freq(1) > wall(1)
  for lay = 1 : length(Tckd)
    junkckd102(:,lay) = interp1(wall,ckd102(:,lay),freq);
  end
else
  junkckd102 = ckd102;
end

figure(1); clf; semilogy(freq,junkckd102,'r',freq,k,'b')
  title('FORN (b) : CKD 6 (r) CKD 2.7');
figure(2); clf; plot(freq,junkckd102 ./ k','b')
  title('FORN CKD 2.7 / CKD 6');

iWrite = input('write out file??? (-1/+1) : ');
if iWrite > 0
  write_ckd_lookup(dirCKD_KCARTA,27,wall,ckd102',+1);
end
