addpath /home/sergio/SPECTRA

iUsualORHigh = -1; %% high res
gid = 1;
nbox = 5;
pointsPerChunk = 10000;

iRemoveEmpty = input('Remove empty files? (-1/+1)   (-1 default) : ');
if length(iRemoveEmpty) == 0
  iRemoveEmpty = -1;
end

if exist('numfiles')
  numfiles0 = numfiles;
end

iUsualORHigh = input('Enter low or high res (default +1/ high -1/ very high -2/ or -3 ) : default +1 : ');
if length(iUsualORHigh) == 0
  iUsualORHigh = 1;
end

gid = input('Enter gid (default 2) : ');
if length(gid) == 0
  gid = 2;
end

freq_boundariesLBL
wn = wn1 : dv : wn2-dv;
wn = wn1 : dv : wn2;

thedir = dir([dirout '/*.mat']);
fprintf(1,'looking for files in %s \n',dirout);

jett = jet; jett(1,:) = 1;

iRemove = 0;
if gid ~= 1
  numfiles = zeros(length(wn),11);
  for nn = 1 : length(thedir)

    str = thedir(nn).name;
    thelen = thedir(nn).bytes;
    if thelen == 0 & iRemoveEmpty > 0
      rmer = ['!/bin/rm ' dirout '/' str];
      fprintf(1,'%s \n',rmer);
      eval(rmer);
      iRemove = iRemove + 1;
    elseif thelen == 0 & iRemoveEmpty < 0
      rmer = ['!/bin/rm ' dirout '/' str];
      fprintf(1,'%4i should be removed, empty file %s \n',nn,rmer);
      iRemove = iRemove + 1;
    end

    junk = findstr(str,'_');

    wnx  = str2num(str(4:junk(1)-1));
    wnx = (wnx-wn1)/dv + 1;

    offx = str2num(str(junk(2)+1:length(str)-4));

    numfiles(wnx,offx) = +1;
  end

  figure(1); pcolor(wn,1:11,numfiles'); colorbar; shading flat; title('files made'); colormap(jett);
  if exist('numfiles0')
    figure(2); plot(wn,sum(numfiles0'),'bo-',wn,sum(numfiles'),'rx-'); title('files made'); 
    figure(3); plot(1:11,sum(numfiles0),'bo-',1:11,sum(numfiles),'rx-'); title('files made, at Toffset'); 
    figure(4); plot(wn,sum(numfiles') - sum(numfiles0'),'k.-'); title('progress files made'); 
  else
    figure(2); plot(wn,sum(numfiles'),'rx-'); title('files made'); 
  end

elseif gid == 1
  numfiles = zeros(length(wn),11,5);
  for nn = 1 : length(thedir)

    str = thedir(nn).name;
    thelen = thedir(nn).bytes;
    if thelen == 0 & iRemoveEmpty > 0
      rmer = ['!/bin/rm ' dirout '/' str];
      fprintf(1,'%s \n',rmer);
      eval(rmer);
      iRemove = iRemove + 1;
    elseif thelen == 0 & iRemoveEmpty < 0
      rmer = ['!/bin/rm ' dirout '/' str];
      fprintf(1,'%4i should be removed, empty file %s \n',nn,rmer);
      iRemove = iRemove + 1;
    end

    junk = findstr(str,'_');

    wnx  = str2num(str(7:junk(1)-1));
    wnx = (wnx-wn1)/dv + 1;

    offx = str2num(str(junk(2)+1:junk(3)-1));
    
    poffx = str2num(str(junk(3)+1:length(str)-4));

    numfiles(wnx,offx,poffx) = +1;
  end

  for nn = 1 : 5
    zaza = squeeze(numfiles(:,:,nn)); figure(1); pcolor(wn,1:11,zaza'); shading flat; colorbar; 
    title(['files made poffset ' num2str(nn)]); colormap(jett);
    caxis([0 1]); shading flat; colorbar
    pause(1);
  end

  figure(2); clf; hold on;
  for nn = 1 : 5
    zaza = squeeze(numfiles(:,:,nn)); figure(2); plot(wn,sum(zaza'),'.'); 
  end
  hold off;

end

figure(1); caxis([0 1]); shading flat; colorbar
fprintf(1,'should remove/have removed  %4i of %4i files \n',iRemove,length(thedir))

if gid ~= 1
  fprintf(1,'expect %4i files spanning %4i to %4i at spacing %4i, found %4i \n',11*length(wn),wn(1),wn(end),dv,length(thedir))
  fprintf(1,' %8.6f done if you include empty files \n',100*length(thedir)/(11*length(wn)))
  fprintf(1,' %8.6f done if you remove  empty files \n',100*(length(thedir)-iRemove)/(11*length(wn)))
else
  fprintf(1,'expect %4i files spanning %4i to %4i at spacing %4i, found %4i \n',5*11*length(wn),wn(1),wn(end),dv,length(thedir))
  fprintf(1,' %8.6f done if you include empty files \n',100*length(thedir)/(5*11*length(wn)))
  fprintf(1,' %8.6f done if you remove  empty files \n',100*(length(thedir)-iRemove)/(5*11*length(wn)))
end
