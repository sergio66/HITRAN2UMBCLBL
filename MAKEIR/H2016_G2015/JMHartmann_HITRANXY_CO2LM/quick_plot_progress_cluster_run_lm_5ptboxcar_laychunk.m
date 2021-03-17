outputdir

for laychunk = 1 : 10
  lser = ['!ls -lt ' output_dir5 '/' num2str(laychunk) '/*.mat | wc -l >& ugh'];
  eval(lser);
  thetotal(laychunk) = load('ugh');
end
figure(1); plot(1:10,thetotal,'o-',1:10,990*ones(size(1:10))); title('total number of files in layerchunks'); 
sum(thetotal)

laychunk = input('Enter laychunk (1..10 for 1=01-10, 2=11-20, ... 10=91-100) : ');
Stoffset = input('Enter Toffset -5:+5 : ');

%% see cluster_run_lm_5ptboxcar_laychunk.m
%% Sgid     = str2num(XJOB(1:2));
%% Schunk   = str2num(XJOB(3:7));
%% Stoffset = str2num(XJOB(8:9));    %Stt = Stoffset - 6;

Stoffset = Stoffset + 6;

Sgid = 2;
outdir = [output_dir5 '/' num2str(laychunk)];
ii = 0;

w = [];
od = [];

for Schunk = 605 : 25 : 2830
  ii = ii + 1;
  junkstr = [num2str(Schunk) '_2_' num2str(Stoffset) '_laychunk_' num2str(laychunk) '.mat'];  %% should have been this, have to rename things
  finalname = [output_dir5 '/' num2str(laychunk) '/std' junkstr];
  if exist(finalname)
    ee(ii) = 1;
    ff(ii) = Schunk;
    boo = load(finalname);
    w  = [w; boo.w];
    od = [od boo.dfull(1,:)]; 
  else
    ee(ii) = 0;
    ff(ii) = Schunk;
  end
end

figure(2); plot(ff,ee,'o-')
figure(3); plot(w,exp(-od));
