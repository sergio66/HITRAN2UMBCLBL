%% this simply does all wavenumbers for g1

%% make sure you do have directory [diroutXN /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

addpath /home/sergio/SPECTRA
addpath /asl/matlib/aslutil
addpath /asl/matlib/science

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('see /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LNFL2.6/aer_v_3.2/line_files_By_Molecule/01_H2O/Readme')
%{
>>> disp('qtips04.m : for water the isotopes are 161  181  171  162  182  172');

lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl

originally
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O

now
lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
-rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
-rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
-rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
-rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
-rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
-rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
-rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O_use_this_for_all

ie (a) have moved 01_H2O to 01_H2O_use_this_for_all
   (b) currently symbolically link          01_H2O  to  01_h2o_162_excl         which is everything but the HDO (isotope 4) database  (gas 1)
   (c) after this is done symbolically link 01_H2O  to  01_h2o_162_only         which is ONLY the HDO isotope                         (gas 103)
   (d) after this is done symbolically link 01_H2O  to  01_H2O_use_this_for_all which is default                                      (gas 110)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

home = pwd;

JOB = 1;
gid = JOB;

if gid ~= 1
  error('for WV')
end

%{
%% in /home/sergio/HITRAN2UMBCLBL      refproTRUE.mat -> refprof_usstd16Aug2010_lbl.mat
%% load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat
%}

nbox = 5;
pointsPerChunk = 10000;

choose_usualORhighORveryhigh_freqres   %% iUsualORHigh = -1 or -2

figure(1); clf
addpath /home/sergio/SPECTRA
[iYes,line] = findlines_plot(wn1-dv,wn2+dv,gid);

if dv >= 25
  [iYes,line] = findlines_plot(fmin-dv,fmax+dv,gid);
else
  [iYes,line] = findlines_plot(fmin-25,fmax+dv+25,gid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
iCnt = 0;
for wn = wn1 : dv : wn2
  woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);

  if dv >= 25
    woo = find(line.wnum >= wn-dv & line.wnum <= wn+dv+dv);
  else
    woo = find(line.wnum >= wn-25 & line.wnum <= wn+dv+25);
  end

  dv2 = max(dv,25);
  woo = find(line.wnum >= wn-dv2 & line.wnum <= wn+dv+dv2);

  if length(woo) >= 1
    iCnt = iCnt + 1;
    iaChunk(iCnt) = wn;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%

cder = ['cd ' home]; eval(cder);

slash = findstr(dirout,'/');
if dirout(end) == '/'
  diroutXN = dirout(1:slash(end-1)-1);
else
  diroutXN = dirout(1:slash(end)-1);
end

%%% diroutXN = [dirout '/'];
%%% fout = [diroutXN '/abs.dat']

%% want to stop two slashes before
slash = findstr(dirout,'/');
diroutXN = [dirout(1:slash(6)) '/lblrtm12.8/WV/abs.dat'];

%% want to stop two slashes before
slash = findstr(dirout,'/');
if iUsualORHigh > 0
  diroutXN = [dirout(1:slash(6)) '/lblrtm12.8/WV/abs.dat'];
elseif iUsualORHigh == -1
  diroutXN = [dirout(1:slash(6)) '/lblrtm12.8/WV/abs.dat0.0005/'];
elseif iUsualORHigh == -2
  diroutXN = [dirout(1:slash(6)) '/lblrtm12.8/WV/abs.dat0.0001/'];
elseif iUsualORHigh == -3
  diroutXN = [dirout(1:slash(6)) '/lblrtm12.8/WV/abs.dat0.0002/'];
end

ee = exist(diroutXN,'dir');
if ee == 0
  fprintf(1,'%s \n',diroutXN);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  if iAns == 1
    mker = ['!mkdir -p ' diroutXN];
    eval(mker);
  else
    error('cannot proceed');
  end
end

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% need to subtract out N2/O2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirX = dirout;
boo = findstr('.dat/lblrtm/',dirX);
foo = findstr('_2830/g',dirX);
dirN2 = [dirX(1:foo+6) '22' dirX(boo:end)];
%%% need to subtract out N2/O2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

while fmin <= wn2
  fmin
  fmax = fmin + dv;
  gg = 1;   %%gasID = 1
  gid = gg;  

  iSave = -1;

  fr = [];
  k = zeros(10000,100,11);
  for mm = 1 : 5
    fout = [diroutXN '/g1v' num2str(fmin) 'p' num2str(mm) '.mat'];  %% really should have done g110v oh well
    if exist(fout) == 0
      for pp = -5 : +5
        fin = [dirout 'stdH2O' num2str(fmin)];
        fin = [fin '_1_' num2str(pp+6) '_' num2str(mm) '.mat'];
        lser = dir(fin);
        if lser.bytes > 500000
          iSave = +1;
          fprintf(1,'gas freq pp mm = %3i %6f %3i %3i \n',gg,fmin,pp,mm);

          loader = ['load ' fin ];
          eval(loader);
          %% need to transpose the LNLRTM wrapper output
	  d = d';
	  
          fr = w;
          k(:,:,pp+6) = d';
          if pp == 0
            plot(fr,exp(-d(1,:)));   % disp('ret to continue');   
            title(num2str(mm));      pause(0.1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
      else
        fprintf(1,'file too small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
      end    %% if iSave > 0
    else
      fprintf(1,'fout = %s already exists \n',fout);
    end      %% if exist
  end        %% loop over m
  fmin = fmin + dv;
end          %% loop over freq


