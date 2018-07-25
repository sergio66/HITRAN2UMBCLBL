% TAPE7 READ
% Questa routine legge il TAPE7 di LBLRTM
%function [t7] = tape7_read(filename);
function [t7] = tape7_read(filename);
fid=fopen(filename,'r');
header='';
s = fscanf(fid,'%s',[1]);
header=[header ' ' s];
while (s(1) ~= 'L') & (s(end) ~= 'M')
    s = fscanf(fid,'%s',[1]);
    header=[header ' ' s];
end
dum=fscanf(fid,'%s',[1]);
if(length(dum)<2)
   nlayer=str2num(fscanf(fid,'%s',[1]));
else
   nlayer=str2num(dum(2:end));
end
nmol=str2num(fscanf(fid,'%s',[1]));
dum=fscanf(fid,'%s',[1]);
while (dum(end) ~= '=')
    dum=fscanf(fid,'%s',[1]);
end
H1=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
H2=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
ANG=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
LEN=fscanf(fid,'%s',[1]);
for layer=1:nlayer
    pbar(layer)=str2num(fscanf(fid,'%s',[1]));
    tbar(layer)=str2num(fscanf(fid,'%s',[1]));
    dum=str2num(fscanf(fid,'%s',[1]));
    if layer==1
        h(layer)=str2num(fscanf(fid,'%s',[1]));
        p(layer)=str2num(fscanf(fid,'%s',[1]));
        t(layer)=str2num(fscanf(fid,'%s',[1]));
    end
    ss=fscanf(fid,'%s',[1]);
    ii=(find(ss=='.'));
    if length(ii)>1
       h(layer+1)=str2num(ss(1:ii(2)-2));
       p(layer+1)=str2num(ss(ii(2)-1:end));
    else
       h(layer+1)=str2num(ss);
       p(layer+1)=str2num(fscanf(fid,'%s',[1]));
    end
    t(layer+1)=str2num(fscanf(fid,'%s',[1]));
    for mol=1:7
        wbar(layer,mol)=str2num(fscanf(fid,'%s',[1]));
    end
    wbroad(layer)=str2num(fscanf(fid,'%s',[1]));
    for mol=8:nmol
        wbar(layer,mol)=str2num(fscanf(fid,'%s',[1]));
    end
end
rhoair=sum(wbar')'+wbroad';
dryair=rhoair-wbar(:,1);
for mol=1:nmol;
    mr(:,mol)=wbar(:,mol)./dryair;
end
mr(:,1)=mr(:,1)./1.6077e-3;
t7.header=header;
t7.H1=str2num(H1);
t7.H2=str2num(H2);
t7.ANG=str2num(ANG);
t7.LEN=str2num(LEN);
t7.nlayer=nlayer;
t7.nmol=nmol;
nxs=str2num(fscanf(fid,'%s',[1]));
dum=fscanf(fid,'%s',[6]);
for ixs=1:nxs
    xsname{ixs}=fscanf(fid,'%s',[1]);
end
dum=fscanf(fid,'%s',[1]);

dum=fscanf(fid,'%s',[1]);
if length(dum)>1
nlayer=str2num(dum(2:end));
else
nlayer=str2num(fscanf(fid,'%s',[1]));
end
nxs=str2num(fscanf(fid,'%s',[1]));
dum=fscanf(fid,'%s',[1]);

while (dum(end) ~= '=')
    dum=fscanf(fid,'%s',[1]);
end
H1=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
H2=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
ang=fscanf(fid,'%s',[1]);
dum=fscanf(fid,'%s',[1]);
len=fscanf(fid,'%s',[1]);
t7.xs.H1=str2num(H1);
t7.xs.H2=str2num(H2);
t7.xs.ANG=str2num(ANG);
t7.xs.LEN=str2num(LEN);
t7.xs.nlayer=nlayer;
t7.xs.nmol=nxs;
for layer=1:nlayer
    pbarxs(layer)=str2num(fscanf(fid,'%s',[1]));
    tbarxs(layer)=str2num(fscanf(fid,'%s',[1]));
    dum=str2num(fscanf(fid,'%s',[1]));
    if layer==1
        hxs(layer)=str2num(fscanf(fid,'%s',[1]));
        pxs(layer)=str2num(fscanf(fid,'%s',[1]));
        txs(layer)=str2num(fscanf(fid,'%s',[1]));
    end
    ss=fscanf(fid,'%s',[1]);
    ii=(find(ss=='.'));
    if length(ii)>1
       hxs(layer+1)=str2num(ss(1:ii(2)-2));
       pxs(layer+1)=str2num(ss(ii(2)-1:end));
    else
       hxs(layer+1)=str2num(ss);
       pxs(layer+1)=str2num(fscanf(fid,'%s',[1]));
    end
    txs(layer+1)=str2num(fscanf(fid,'%s',[1]));
    for mol=1:7
        wxs(layer,mol)=str2num(fscanf(fid,'%s',[1]));
    end
    wbroadxs(layer)=str2num(fscanf(fid,'%s',[1]));
end
wxs=wxs(:,1:nxs);
for mol=1:nxs
   mrxs(:,mol)=wxs(:,mol)./dryair;
end 
t7.pz=p';
t7.alt=h';
t7.tz=t';
t7.pbar=pbar';
t7.tbar=tbar';
t7.wkl=wbar;
t7.wbroadl=wbroad';
t7.rhoair=rhoair;
t7.mr=mr;
t7.xs.xsname=xsname;
t7.xs.pz=pxs';
t7.xs.alt=hxs';
t7.xs.tz=txs';
t7.xs.pbar=pbarxs';
t7.xs.tbar=tbarxs';
t7.xs.wkl=wxs;
t7.xs.mr=mrxs;
fclose(fid);
return


