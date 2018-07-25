clear all
figure(1); clf

tt0 = 6;  %% temp offset (out of 11)
dirx = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/';
iCnt = 0;
for ff = 605 : 25 : 2805
  iCnt = iCnt + 1;
  for tt = tt0
    fname = ['std' num2str(ff) '_2_' num2str(tt) '.mat'];
    ee = exist([dirx fname]);
    if ee > 0
      loader = ['load ' dirx fname];
      eval(loader);
      ind = 0;
      for ll = 1 : 100
        dx = d(ll,:);
        oo = find(isnan(dx));
        if length(oo) > 0
          ind = ind + 1;
          bad(iCnt).lay(ind) = ll;
          plot(ff,ll,'o'); hold on
        end  %%% found a bad un
      end    %%% loop over 100 layers
    end      %%% if file found
  end        %%% loop over temp offsets
end          %%% loop over wavenumbers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('RET to continue');
pause

figure(1); clf
figure(2); clf

clear all
dirx = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcomp/';
dirZ = '/asl/s1/sergio/H2012_RUN8_NIRDATABASE/IR_605_2830/g2.dat/linemixUMBC/kcompNOZEROS/';
iCnt = 0;
for ff = 605 : 25 : 2805
  iCnt = iCnt + 1;
  fname = ['cg2v' num2str(ff) '.mat'];
  ee = exist([dirx fname]);
  if ee > 0
    fnameZ = [dirZ fname];
    fname  = [dirx fname];
    loader = ['a = load(''' fname ''');'];
    eval(loader);
    oo = find(isnan(a.B));
    if length(oo) > 0
      badB(iCnt) = 1;
    end

    z = a;
    oo = find(isnan(z.kcomp));
    z.kcomp(oo) = 0;    

    kcomp6  = squeeze(a.kcomp(:,:,6));
    kcomp6z = squeeze(z.kcomp(:,:,6));

    ind = 0;
    for ll = 1 : 100
      dx = kcomp6(:,ll);
      oo = find(isnan(dx));
      if length(oo) > 0
        ind = ind + 1;
        badkcomp6(iCnt).lay(ind) = ll;
        figure(2); plot(ff,ll,'o'); hold on
      end  %%% found a bad un

      dz = kcomp6z(:,ll);
      oo = find(isnan(dz));
      if length(oo) > 0
        ind = ind + 1;
        badzcomp6(iCnt).lay(ind) = ll;
        figure(2); plot(ff,ll,'rx'); hold on
      end  %%% found a bad un

    end    %%% loop over 100 layers

  saver = ['save ' fnameZ ' z']; 
  saver = ['save(''' fnameZ, ''',' '''-struct''', ',' '''z''' ');'];
  eval(saver)

  end      %%% if file found
end        %%% loop over wavenumbers


