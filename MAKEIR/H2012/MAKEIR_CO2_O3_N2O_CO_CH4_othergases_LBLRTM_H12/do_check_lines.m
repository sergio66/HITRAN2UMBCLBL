%% loop over check(ggg,vstep) = findlines_plot(vmin-dv,vmax+dv,gg);

dv = 25;
v = 605 : dv : 2805;
v0 = 605 : 2830;

addpath /home/sergio/SPECTRA

if iCheckLines > 0 & ~exist('check.mat','file')
  bonk = find(gid < 51);
  for ggg = 1 : length(bonk)
    gg = gid(ggg);    
    [iyes,lines] = findlines_plot(min(v0)-dv,max(v0)+dv,gg);
    for vstep = 1 : length(v)
      vmin = v(vstep);
      vmax = vmin + 25;
      boo = find(lines.wnum >= vmin-dv & lines.wnum <= vmax+dv);
      if length(boo) > 0
        check(ggg,vstep) = 1;
      else
        check(ggg,vstep) = -1;
      end
    end
  end
  save check.mat check v gid
  pcolor(v,gid(1:length(bonk)),check); colormap jet; colorbar
  set(gca,'fontsize',10)
else
  bonk = find(gid < 51);
  if exist('check.mat')
    aa = load('check.mat');  
    [Y,iA,iB] = intersect(gid(bonk),aa.gid);
    check = aa.check(iB,:);
    pcolor(v,gid(1:length(bonk)),check); colormap jet; colorbar    
    set(gca,'fontsize',10)
  end
end
