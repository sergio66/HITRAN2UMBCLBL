%% make sure you do have directory [dirout /abs.dat] available
%% to save the concatted abs coeffs (biiiiiiiiiiiiiiig files)
%% after the compression, you may want to delete this [dirout /abs.dat] dir

nbox = 5;
pointsPerChunk = 10000;
gases = [2:32];
gases = [3 7 9 10 20];   %%%%%%% <<<<<<<< need to change this as needed!  
gases = [3];             %%%%%%% <<<<<<<< need to change this as needed!  
gases = [9];             %%%%%%% <<<<<<<< need to change this as needed!  

load /home/sergio/abscmp/refproTRUE.mat

freq_boundaries
fmin = wn1; 

fout = [dirout '/abs.dat'];
ee = exist(fout,'dir');
if ee == 0
  fprintf(1,'%s \n',fout);
  iAns = input('dir does not exist, do you want to make it? (+1 = Y) ');
  if iAns == 1
    mker = ['!mkdir ' fout];
    eval(mker);
  else
    error('cannot proceed');
    end
  end
  
figure(1); clf
while fmin <= wn2
  %topts = runXtopts_params_smart(fmin);
  fmax = fmin + dv;
  for gg = 1 : length(gases)
    gasid = gases(gg);
    iSave = 0;
    fr = [];
    k = zeros(10000,100,11);

    %% remove the 11x100x10000 files from dirout/abs.dat
    fout = [dirout '/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
    eeout = exist(fout);
    if eeout > 0
      rmer = ['!/bin/rm ' fout]; eval(rmer)
      end

    %% remove the compressed 11xNx10000 files from dirout/kcomp
    fkcomp = [dirout '/kcomp/cg' num2str(gasid) 'v' num2str(fmin) '.mat'];
    eeout = exist(fkcomp);
    if eeout > 0
      rmer = ['!/bin/rm ' fkcomp]; eval(rmer)
      end

    for pp = -5 : +5
      gasid = gases(gg);  

      fin =[dirout '/std' num2str(fmin)];
      fin = [fin '_' num2str(gasid) '_' num2str(pp+6) '.mat'];

      finx =[dirout '/std' num2str(fmin)];
      finx = [finx '_xsec_' num2str(gasid) '_' num2str(pp+6) '.mat'];
      
      lser  = dir(fin);
      lserx = dir(finx);

      ee  = exist(fin);
      eex = exist(finx);

      if length(lser) >= 1 | length(lserx) >= 1
        clear d0 dx dsum
        dsum = zeros(100,10000);
        if length(lser) == 1
          if lser.bytes > 10000
            iSave = iSave + 1;
            fprintf(1,'gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
            loader = ['load ' fin ];
            eval(loader);
            d0 = d;
            clear d
            dsum = dsum + d0;
            fr = w;
            end
          end
        if length(lserx) == 1
          if lserx.bytes > 10000
            iSave = iSave + 10;
            fprintf(1,'gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
            loader = ['load ' finx ];
            eval(loader);
            dx = d;
            clear d
            dsum = dsum + dx;
            fr = w;
            end
          end
        k(:,:,pp+6) = dsum';
        if pp == 0
          plot(fr,exp(-dsum(1,:))); 
          title(num2str(gasid)); pause(1); %hold on; pause(1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        gid = gasid;
        fout = [dirout '/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
        fprintf(1,'--->>> gid vv iSave = %3i %7i %3i \n',gasid,fmin,iSave);
      else
        fprintf(1,'small file : gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
        end  %% if
    end    %% loop over gasid

  disp(' ')
  fmin = fmin + dv;
  end                   %% loop over freq

