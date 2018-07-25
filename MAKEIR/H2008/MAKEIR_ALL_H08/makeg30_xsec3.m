%% see /asl/data/hitran/HITRAN08_SERGIO/Xsec/SF6_IR00.xsc 

home = pwd;

addpath /home/sergio/SPECTRA
gasid = 30;

nbox = 5;
pointsPerChunk = 10000;
freq_boundaries

lines = show_vis_ir_lines_wavenumber_individualgas(2,gasid);

woof = find(lines.wnum >= 575 & lines.wnum <= 656);
ff = min(lines.wnum(woof)) : 0.025/10 : max(lines.wnum(woof));
[doink,I,J] = unique(lines.wnum(woof));
linestren = interp1(lines.wnum(woof(I)),lines.stren(woof(I)),ff,[],'extrap');
figure(2); plot(ff,linestren); 
figure(1); axis([575 660 0 1e-20]);

%% if you do
%% cd /asl/data/hitran/HITRAN08_SERGIO/Xsec
%% grep -in 'SF6' SF6_IR00.xsc
%%
%% you will notice that there are about 3000 points for 925.0012  955.0029
%% the pressures are in torr (760,440,452,355,287,331,190,170,133,100,78,41,20)
%% the temps are in K (295,273,245,233,225,216,200)

%% so in atm, the press are 
%% [1.0 0.58 0.46 0.37 0.43 0.25 0.22 0.18 0.13 0.12 0.05 0.02]

cd  /home/sergio/SPECTRA
ipname = '/home/sergio/SPECTRA/IPFILES/std_gx30_ref_3layers';
ipname = 'IPFILES/std_gx30_ref_3layers';
% 3 1.01458170 0.00000000 296.000 1.000e0
% 3 0.50000000 0.00000000 250.000 1.000e0
% 3 0.10000000 0.00000000 220.000 1.000e0
%T p  = [296 1.01458170*760      250 0.50*760   220  0.10*760] = 
%     = [296  771.1     250 380.0    220 076.0]

[w,d] = run8(30,574,657,ipname,topts);
figure(3); plot(w,d);
save /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08/std_gx30_ref_3layers.mat w d

%% see SPECTRA/DOC/lbl.pdf .... the output units of "d" are dimensionless, but
%% they are in terms of kilomoles = 6.023e26

w0 = 574 : 30/5000 : 657;
out_d = interp1(w,d',w0,[],'extrap');

cd /home/sergio/HITRAN2UMBCLBL/MAKEIR_ALL_H08

%% remember pressure needs to be in torr, while temperature is in K
line1 = '                SF6  574.0000  657.0000  13834 296.00 771.1 4.511E-17 0.03            SF6    air 15'
line2 = '                SF6  574.0000  657.0000  13834 250.00 380.0 4.511E-17 0.03            SF6    air 15'
line3 = '                SF6  574.0000  657.0000  13834 220.00  76.0 4.511E-17 0.03            SF6    air 15'
fid = fopen('ir_xsc30.txt','w');
for ll = 1 : 3
  liner = ['line = line' num2str(ll) ';'];
  eval(liner)
  fprintf(fid,'%s\n',line);
  donk = floor(length(w0)/10);
  for ii = 1 : donk
    jonk = (1:10) + (ii-1)*10;
    bonk = out_d(jonk,ll);
    fprintf(fid,' %9.3e %9.3e %9.3e %9.3e %9.3e %9.3e %9.3e %9.3e %9.3e %9.3e \n',bonk/6.023e26);
    end
  if donk < length(w0)/10
    jonk = max(jonk)+1 : length(w0);
    bonk = out_d(jonk,1);
    boof = [' fprintf(fid,'' '];
    for ii = 1 : length(jonk)
      boof = [boof '%9.3e '];
      end
    boof = [boof '\n'',bonk/6.023e26)'];
    eval(boof);
    end
  end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gas_done_already(30);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d0 = load('sf6_574_657_13834pts');  %% what I just made
d1 = load('sf6_925_955_2988pts');   %% from HITRAN
w1 = 925 : (955-925)/2988 : 956;
w0 = 574 : (657-574)/13834 : 658;

d0 = d0';                          
figure(3); plot(w0(1:13840),d0(:))

d1 = d1';                           
figure(3); plot(w0(1:13840),d0(:),w1(1:2990),d1(:))
figure(3); semilogy(w0(1:13840),d0(:),w1(1:2990),d1(:))    

figure(1); axis([570 1000 0 1e-20]) 

