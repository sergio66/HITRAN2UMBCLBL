function fxout = dowrite_n2_or_o2_new(fid,gid,ll,fmin,fmax,JOBB,Pall,Tall,PPall,LenCell);

fxout = ['output_gid_' num2str(gid) '_JOBB_' num2str(JOBB) '_fmin_' num2str(fmin) '_ll_' num2str(ll)];
fxout = mktempS(fxout);
fxout = strip(fxout);

fprintf(fid,'''%s'' \n',fxout);                      %% name of output file
fprintf(fid,'%12.5f \n',Pall(ll));               %% pave (mb)
fprintf(fid,'%12.5f \n',Tall(ll));               %% tave
fprintf(fid,'%12.5f \n',LenCell(ll));            %% cm
fprintf(fid,'%12.5f \n',0.0);                    %% VMR WV
if gid == 22
  fprintf(fid,'%12.5f \n',PPall(ll)/Pall(ll));   %% VMR N2
  fprintf(fid,'%12.5f \n',0.0);                  %% VMR 02
elseif gid == 7
  fprintf(fid,'%12.5f \n',0.0);                  %% VMR N2
  fprintf(fid,'%12.5f \n',PPall(ll)/Pall(ll));   %% VMR 02
else
  gid
  error('need gid == 7 or 22')
end

%disp('dowrite_n2_or_o2_new.m assumes fmax = fmin+25; and dv = 0.0025')
%dv = 0.0025;
%fprintf(fid,'%12.5f %12.5f %12.5f \n',fmin,fmin+25-dv+dv/10,0.005);

disp('dowrite_n2_or_o2_new.m assumes CKD4.3 code handles max 5000 points')
dv = (ceil(fmax)-floor(fmin))/5000;   %% since the code assumes 5050 points at most
fprintf(fid,'%12.5f %12.5f %12.5f \n',fmin,fmax,dv*10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%% see ~/SPECTRA/CKDLINUX/MT_CKD-4.3/run_example/n2_input or o2_input or wv_input

N2              O2             WV
----------------------------------
' '           ' '             ' '
1013.0        1013.0          1013.0
296.0         296.0           296.0
1.0           1.0             1.0
0.0           0.0             0.1
1.00          0.00            0.78
0.00          1.00            0.21
-1 -1 -1      -1 -1 -1        -1 -1 -1      

% 1900.0 2900.0 0.2

  read: output file name  if blank or starts with x use default value (CNTNM.OPTDPT)
  read: pressure (mb)  if negative use default values
  read:   temperature (K)
  read:   path length (cm)
  read:   vmr h2o
% Pressure (mb), Temperature (K), Path Length (cm),    VMR H2O
%   1013.000000         296.0000            1.0000  0.00000000
  read:   N2 (typically 0.78)
  read:   O2 (typically 0.21)
% v1abs,v2abs,dvabs
%   0.0000000000000000        19900.000000000000        10.000000000000000
  read: start/stop/dv wavenumber  if negative use default values
%}
