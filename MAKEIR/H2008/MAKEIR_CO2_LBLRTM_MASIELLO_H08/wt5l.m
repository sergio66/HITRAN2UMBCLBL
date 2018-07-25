% function wt5l(imol,dt,rw,V1,V2)
function wt5l(imol,dt,rw,V1,V2)
idt=(dt/10);
if imol>1
    rw=1.0; 
end
title='                                  ';
name(1,1:4)='H2O ';
name(2,1:4)='CO2 ';
name(3,1:4)='O3  ';
name(4,1:4)='N2O ';
name(5,1:4)='CO  ';
name(6,1:4)='CH4 ';
name(7,1:4)='MGAS';
title=['$ Input for ' name(imol,1:4) ', DT= ' num2str(dt,'%3i') ', RW= ' num2str(rw,'%3.1f')];
disp(title)
nmol=28;
dv1=0.0002;dv2=0.001;
tb=288.20;
ipath=1;
iform=1;
angle=0;
ityl='   ';
ixmols=3;
load atmos_data3;
a=size(data.wkl);
data.pave=reshape(data.pave(:,6),a(1),1);
data.tave=reshape(data.tave(:,6),a(1),1);
data.rhoave=reshape(data.rhoave(:,6),a(1),1);
data.wbroadl=reshape(data.wbroadl(:,6),a(1),1);
data.wkl=reshape(data.wkl(:,6,:),a(1),a(3));
data.wkl_mr=reshape(data.wkl_mr(:,6,:),a(1),a(3));
data.xs_col=reshape(data.xs_col(:,6,:),a(1),3);
data.pz=reshape(data.pz(:,6),a(1)+1,1);
data.tz=reshape(data.tz(:,6),a(1)+1,1);
rda=1.;
secntk=ones(size(data.pave));
molecule=zeros(size(data.wkl));
molecule(:,imol)=data.wkl(:,imol).*rw.*data.rhoave./(data.rhoave+data.wkl(:,1).*(rw-1));
if imol==7
    for mol=imol+1:nmol
        molecule(:,mol)=data.wkl(:,mol).*rda;
    end
    for mol=1:3
        xs_col(:,mol)=data.xs_col(:,mol).*rda;
    end
end
% molecule(:,:)=data.wkl(:,:);
% for i=1:60
%      molecule(i,9)=0.0;
% end
if rw==1/5 
    iw=1;
elseif rw==1
    iw=2;
elseif rw==2.5
    iw=3;
elseif rw==4
    iw=4;
end
fid=fopen(['T5'  num2str(imol) num2str(fix((dt./10+5))) num2str(iw)],'w');
%fid=fopen(['t5\TAPE5_ALL-SO2.gm'],'w');
fprintf(fid,'%30s\n',[title(1:length(title))]);
if imol==7
    fprintf(fid,' HI=1 F4=1 CN=0 AE=0 EM=1 SC=3 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=2 XS=1   00   00\n',[]);
elseif imol==2
    fprintf(fid,' HI=1 F4=1 CN=6 AE=0 EM=1 SC=3 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=2 XS=0   00   00\n',[]);
    fprintf(fid,' 0 0 1 0 0 0 0\n',[]);
else
    fprintf(fid,' HI=1 F4=1 CN=0 AE=0 EM=1 SC=3 FI=0 PL=0 TS=0 AM=0 MG=1 LA=0 OD=2 XS=0   00   00\n',[]);
end
fprintf(fid,'%10.3f%10.3f                                        %10.4f%10.4f\n',[V1 V2 dv1 dv2]);
fprintf(fid,'%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f%10.3f\n',...
    [tb+dt data.altz(1) data.altz(1) data.altz(1) data.altz(1) data.altz(1) data.altz(1)]);
fprintf(fid,' %1i%3i%5i                              %8.2f    %8.2f     %8.3f\n',...
    [iform length(data.rhoave) nmol data.altz(61) data.altz(1) angle]);
for i=1:length(data.wkl)
    for j=1:28
        str(j,1:15)='               ';
        if molecule(i,j)==0
            str(j,3:15)='0.0000000E+00';
        else 
            str(j,3:15)=[num2str(abs(molecule(i,j))/10^floor(log10(abs(molecule(i,j)))),'%9.7f'),...
                         'E' num2str(floor(log10(abs(molecule(i,j)))),'%+03i')];
        end
        if molecule(i,j)<0
            str(2,j)='-';
        end
        str1((j-1)*15+1:j*15)=str(j,:);
    end
    str1(121:435)=str1(106:420);
    str1(106:120)='               ';
    x=max(1,data.rhoave(i)-sum(molecule(i,:)));
    str1(108:120)=[num2str(abs(x)/10.^floor(log10(abs(x))),'%9.7f'),'E' num2str(floor(log10(abs(x))),'%+03i')];
    fprintf(fid,'%15.7f%10.4f%10.4f   %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f\n',...
        [data.pave(i) data.tave(i)+dt secntk(i) ipath data.altz(i) data.pz(i)...
         data.tz(i)+dt data.altz(i+1) data.pz(i+1) data.tz(i+1)+dt]);
    fprintf(fid,'%120s\n',...
        [str1(1:120)]);
    fprintf(fid,'%120s\n',...
        [str1(121:240)]);
    fprintf(fid,'%120s\n',...
        [str1(241:360)]);
    fprintf(fid,'%75s\n',...
        [str1(361:435)]);
end
if(imol==7)
    fprintf(fid,'%5i     %5i\n',...
        [ixmols 0.]);
    fprintf(fid,'%23s\n','CCL4      F11       F12');
    fprintf(fid,' %1i%3i%5i%10.2f\n',[1 length(data.wkl) 3 0.]);
    for i=1:length(data.wkl)
        for j=1:3
            str(j,1:15)='               ';
            if data.xs_col(i,j)==0
                str(j,3:15)='0.0000000E+00';
            else 
                str(j,3:15)=[num2str(abs(xs_col(i,j))/10.^floor(log10(abs(xs_col(i,j)))),'%9.7f'),...
                             'E' num2str(floor(log10(abs(xs_col(i,j)))),'%+03i')];
            end
            if xs_col(i,j)<0
                str(2,j)='-';
            end
            str2((j-1)*15+1:j*15)=str(j,:);
        end
        str2(46:60)='               ';
        x=max(1,data.rhoave(i)-sum(molecule(i,:)));
        str2(48:60)=[num2str(abs(x)/10^floor(log10(abs(x))),'%9.7f'),'E' num2str(floor(log10(abs(x))),'%+03i')];
        fprintf(fid,'%15.7f%10.4f%10.4f   %2i %7.2f%8.3f%7.2f%7.2f%8.3f%7.2f\n',...
            [data.pave(i) data.tave(i)+dt secntk(i) ipath data.altz(i) data.pz(i) data.tz(i)+dt ...
                                                          data.altz(i+1) data.pz(i+1) data.tz(i+1)+dt]);
        fprintf(fid,'%60s\n',[str2(1:60)]);
    end
end
fprintf(fid,'%5s\n',['  -1.']);
fprintf(fid,'%5s\n',['%%%%%']);
fclose all;
return
