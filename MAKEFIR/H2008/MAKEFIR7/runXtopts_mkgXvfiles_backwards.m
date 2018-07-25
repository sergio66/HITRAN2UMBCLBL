nbox = 5;
pointsPerChunk = 10000;
gases = [2 3 4 6 7 9];
gases = [2:32];
gases = [[2:42] [51:83]];

%load /home/sergio/abscmp/refproTRUE.mat
load /home/sergio/HITRAN2UMBCLBL/refproTRUE.mat

freq_boundaries

figure(1); clf
fmax = wn2 + dv;
while fmax >= wn1
  %topts = runXtopts_params_smart(fmin);
  fmin = fmax - dv;
  for gg = length(gases) : -1 : 1
    gasid = gases(gg);  
    iSave = -1;
    fr = [];
    k = zeros(10000,100,11);
    fout = [dirout '/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
    ee = exist(fout);
    for pp = -5 : +5
      fin =[dirout '/g' num2str(gasid) '/std' num2str(fmin)];
      fin = [fin '_' num2str(gasid) '_' num2str(pp+6) '.mat'];
      
      lser = dir(fin);
      if length(lser) >= 1 & ee == 0
        if lser.bytes > 5000000
          iSave = +1;
          fprintf(1,'gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
          loader = ['load ' fin ];
          eval(loader);
          fr = w;
          k(:,:,pp+6) = d';
          if pp == 0
            plot(fr,exp(-d(1,:))); 
            title(num2str(gasid)); pause(1); %hold on; pause(1)
            end
          end
        elseif length(lser) >= 1 & ee ~= 0
          fprintf(1,'file already concatted %s \n',fout);
         end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        gid = gasid;
        fout = [dirout '/abs.dat/g' num2str(gasid) 'v' num2str(fmin) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
        disp(' ')
      else
        fprintf(1,'small file : gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
        end  %% if
    end    %% loop over gasid

  disp(' ')
  fmax = fmax - dv;
  end                   %% loop over freq

