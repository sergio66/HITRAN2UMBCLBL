%% quick RT

addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/aslutil/

allf = [];
allr = [];
layer_rad = [];
figure(1); clf;
for wn = 605 : 25 : 830
  outname = ['mars_co2_ods_' num2str(wn) '.mat'];
  fprintf(1,'doing %3i chunk \n',wn)
  loader = ['load ' outname];
  eval(loader);
  Tav = data(:,4);
  rad = ttorad(outwave,Tav(1));
  for ii = 1 : length(Tav)
    od    = out_array(ii,:);
    trans = exp(-od);
    Temp  = Tav(ii);
    rad   = rad .* trans + ttorad(outwave,Temp) .* (1-trans);
    radsave(ii,:) = rad;
  end
  plot(outwave,rad2bt(outwave,rad)); hold on
  allf = [allf outwave];
  allr = [allr rad];
  layer_rad = [layer_rad radsave];
end

[fc,qc] = quickconvolve(allf,allr,0.5,0.5);
[fc2,qc2]    = quickconvolve(allf,allr,2,2);
[fc2,qclay2] = quickconvolve(allf,layer_rad,2,2);

plot(fc,rad2bt(fc,qc),'r',fc2,rad2bt(fc2,qc2),'k','linewidth',2);
hold off

figure(2); plot(fc2,rad2bt(fc2,qc2),'r');

figure(3);  semilogy(qclay2,data(:,2)); set(gca,'ydir','reverse'); xlabel('rad'); ylabel('p(atm)')
figure(3);  semilogy(rad2bt(fc2,qclay2),data(:,2)*1013.25); set(gca,'ydir','reverse'); xlabel('rad'); grid
  ylabel('p(mb)')
  %% things seem quiet by 10^-4 mb
  %% so do useful range (101 layers) from about 7 mb to 0.0001 mb

figure(4);  pcolor(fc2,log10(data(:,2)),qclay2'); set(gca,'ydir','reverse'); 
            shading flat; xlabel('freq'); ylabel('p (atm)')
figure(4);  pcolor(fc2,log10(data(:,2)),rad2bt(fc2,qclay2)'); set(gca,'ydir','reverse'); 
            shading flat; xlabel('freq'); ylabel('p (atm)'); colorbar
figure(4);  pcolor(fc2,log10(data(:,2)),log10(rad2bt(fc2,qclay2)')); set(gca,'ydir','reverse'); 
            shading flat; xlabel('freq'); ylabel('p (atm)'); colorbar
figure(4);  pcolor(fc2,log10(data(:,2)*1013.25),log10(rad2bt(fc2,qclay2)')); set(gca,'ydir','reverse'); 
            shading flat; xlabel('freq'); ylabel('p (mb)'); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error('produce_kcarta_paramfiles')

produce_kcarta_paramfiles
