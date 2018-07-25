function mat2forWATER(GAS,FREQ)
%function mat2forOTHERS(GAS,FREQ)
% MATLAB to FORTRAN conversion of the compressed transmittance data for others
%GAS === iGasID, FREQ == Starting frequency

fstart=FREQ;
gasid=GAS;

npts=10000;
fstep=0.0025;
KTYPECODE=1;
if (GAS==2) 
  KTYPECODE=2;
  end

ntemp=11;
namebase=[int2str(fstart) '_g' int2str(gasid)];

cd /umbc/scratch/Strow/sergio/ATMOSCOMP/DATA/MatlabKfiles;
eval(['load t' namebase '.mat']);
cd /umbc/scratch/Strow/sergio/ATMOSCOMP/DATA/CompDataBase;

[nsing,nlay]=size(k_comp);
nlay=nlay/ntemp;

[npts,nk]=size(u);
%nk=NKMAX;
%u=u(:,1:nk);

km=ntemp;
kn=nlay;
um=npts;
un=nk;

% Variable "ktype" will say what type of commpression (1=k, 2=4th-root(k), etc)
%this is water ==> 4th root
ktype=KTYPECODE;

% Load up the temperature offsets (change code as needed).
if ntemp==11
   toff=-50.0:10.0:50.0;
else
   error('ERROR! unexpected number of temperature offsets')
end

fid=fopen(['r' namebase '.dat'],'w','ieee-be');
%
% Write header info
% header = gasid, fstart, freq spacing, npts, nlay, ktype, nk, km, kn, um, un
filemark= 4 + 8 + 8 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4;
fwrite(fid,filemark,'integer*4');
fwrite(fid,gasid,'integer*4');
fwrite(fid,[fstart,fstep],'real*8');
fwrite(fid,[npts,nlay,ktype,nk,km,kn,um,un],'integer*4');
fwrite(fid,filemark,'integer*4');

% Write the temperature offsets
filemark= 8 * ntemp;
fwrite(fid,filemark,'integer*4');
fwrite(fid,toff,'real*8');
fwrite(fid,filemark,'integer*4');

%Save the 5 k matrices sequentially
filemark= 8 * km * kn;
k=k_comp;
for i = 1:nk
  fwrite(fid,filemark,'integer*4');
  eval(['k' int2str(i) '=k(i,:);'])
  fwrite(fid,eval(['k' int2str(i)]),'real*8');
  fwrite(fid,filemark,'integer*4');
  end

% Loop over the kn columns of U
filemark= 8 * um;
for i = 1:un
   fwrite(fid,filemark,'integer*4');
   fwrite(fid,u(:,i),'real*8');
   fwrite(fid,filemark,'integer*4');
end

fclose(fid)

cd /umbc/scratch/Strow/sergio/MAT2FOR;
