nbox = 5;
pointsPerChunk = 10000;
gases = [2];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

freq_boundaries

dirIN = dirout;

%fmin = 2805;
%fmin = 2780;

%% the files look like std605_2_11_55.mat = std605_2_pp_ll.mat

gg = 1;
gasid = gases(gg);  
gid = gasid;

figure(1); clf
fmin = fmax - dv;
fmin = 2805;
while fmin >= wn1
  eeX = -1;
  eeG = -1;
  eeV = -1;
  fmax = fmin + dv;
  fr = [];
  kid = zeros(100,11);
  k = zeros(10000,100,11);
  iSave = 0;
  fout = [dirout '_CO2/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
  ee = exist(fout);
  if ee ~= 0
    eeX = +1;
    fprintf(1,'lblumbc kdata files exist, but %s already made \n',fout);
    end
  for pp = -5 : +5   %% loop over temperature
    for ll = 1 : 100     %% loop over layer
      clear fr d0
      dirX = [dirIN '/g' num2str(gasid) '.dat/'];
      fin =[dirX '/std' num2str(fmin)];
      fin =[dirX '/std605'];
      fileG = [dirX  '/std' num2str(fmin) '_2_6voigtUMBC.mat'];
      fileV = [dirX  '/std' num2str(fmin) '_2_6vanhuberUMBC.mat'];
        eeG = dir(fileG);
        eeV = dir(fileV);
        if length(eeG) == 1 & eeG.bytes > 100000
          eeG = 1;
        else
          eeG = -1;
          end
        if length(eeV) == 1 & eeV.bytes > 100000
          eeV = 1;
        else
          eeV = -1;
          end
      fin = [fin '_' num2str(gasid) '_' num2str(pp+6) '_' num2str(ll) '.mat'];
      lser = dir(fin);
      if length(lser) >= 1
        if lser.bytes > 10000000 & ee == 0
          kid(ll,pp+6) = 1;
          iSave = iSave+1;
          if ll == 1 | ll == 51 | ll == 100
            fprintf(1,'gas freq pp ll = %3i %6i %3i %3i \n',gasid,fmin,pp,ll);
            end
          loader = ['load ' fin ];
          eval(loader);
          wonk = find(boxcar_jmh(:,1) >= fmin & boxcar_jmh(:,1) < fmax);
          fr = boxcar_jmh(wonk,1);
          d0 = boxcar_jmh(wonk,4);
          k(:,ll,pp+6) = d0';
          if pp == 0 & eeG > 0 & eeV > 0 & mod(ll,5) == 1
            eval(['load ' fileG]); dG = d;
            eval(['load ' fileV]); dV = d;
            figure(1)
              plot(fr,exp(-d0),'.-',fr,exp(-dG(ll,:)),fr,exp(-dV(ll,:)));
              title(num2str(ll)); 
            figure(2)
              plot(fr,exp(-dG(ll,:))./exp(-d0'),'g',...
                   fr,exp(-dV(ll,:))./exp(-d0'),'r');
              axis([min(fr) max(fr) 0.75 1.25])
              title(['G/H  (g) and V/H (r) ' num2str(ll)]); 
            pause(0.1); 
            end
          end
        end
      end               %% loop over layer
    end                 %% loop over temperature (1..11) pp

  if sum(kid(:)) ~= 1100 & eeX == -1
    imagesc(kid); colorbar; title(['layers/temp offsets : ' num2str(fmin)]);
    sum(kid(:))
    error('not all layers/temps found')
    end

  if iSave == 11*100 & ee == 0
    gid = gasid;
    fout = [dirout '/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
    saver = ['save ' fout ' fr gid k ' ];
    eval(saver);
    disp(' ')
  elseif iSave < 11 & ee == 0
    fprintf(1,'small file : gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
    end  %% if

  disp(' ')
  fmin = fmin - dv;
  end                   %% loop over freq

