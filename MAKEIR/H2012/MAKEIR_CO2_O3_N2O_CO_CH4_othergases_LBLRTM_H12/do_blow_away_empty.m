clear allfile badfile
for ggg = 1 : length(gid);
  gg = gid(ggg);
  iCnt = 0;
  dirx = ['/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g' num2str(gg) '.dat/lblrtm2/'];
  thedir = dir([dirx '*.mat']);
  allfile(ggg) = length(thedir);
  badfile(ggg) = 0;
  for ii = 1 : length(thedir)
    sze = thedir(ii).bytes;
    if sze < 28000
      iCnt = iCnt+1;      
      rmer = ['!/bin/rm ' dirx thedir(ii).name];
      if iBlowAway > 0
        eval(rmer);
      end
    end
    badfile(ggg) = iCnt;
  end
end
figure(2); clf; plot(gid,badfile./allfile,'o-'); grid; ylabel('fraction of incomplete files'); title('badfile/allfile'); xlabel('gid')
figure(3); clf; plot(gid,allfile,'o-'); grid; title('allfile'); xlabel('gid'); ylabel('files made so far')

if exist('check','var')
  do_check_xsec
  ii = find(gid >= 51 & gid <= 63);
  [Y2,iA2,~] = intersect(gid,51:63);
  checknan = check; checknan(checknan <= 0) = nan;
  if length(iA2 > 0)
  %  checksum = [nansum(checknan,2); xsec_expect(iA2)'];;
    checksum = [nansum(checknan,2); xsec_expect'];;
  else
    checksum = [nansum(checknan,2);];;
  end
  figure(4); clf; plot(gid,allfile/11,'o-',gid,checksum,'rx-','linewidth',2);
    grid; title('allfile/11'); xlabel('gid'); ylabel('num chunks')
    hl= legend('done so far','expected'); set(hl,'fontsize',10)
end
