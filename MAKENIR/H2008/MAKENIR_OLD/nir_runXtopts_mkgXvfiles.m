nbox = 5;
pointsPerChunk = 10000;
gases = [2:32];

wnNIR1 = 2805;
wnNIR2 = 3330 - 25;

wnNIR1 = 3305;
wnNIR2 = 3580 - 25;

load /home/sergio/abscmp/refproTRUE.mat

fmin = wnNIR1; 
topts = runXtopts_params_smart(fmin); 
dv = topts.ffin*nbox*pointsPerChunk;

dv = 25;

while fmin <= wnNIR2
  %topts = runXtopts_params_smart(fmin);
  fmax = fmin + dv;
  for gg = 1 : length(gases)
    iSave = -1;
    fr = [];
    k = zeros(10000,100,11);
    for pp = -5 : +5
      gasid = gases(gg);  

      fin = ...
        ['/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/std' num2str(fmin)];
      fin = [fin '_' num2str(gasid) '_' num2str(pp+6) '.mat'];
      lser = dir(fin);
      if length(lser) >= 1
        if lser.bytes > 5000000
          iSave = +1;
          fprintf(1,'gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
          loader = ['load ' fin ];
          eval(loader);
          fr = w;
          k(:,:,pp+6) = d';
          if pp == 0
            plot(fr,exp(-d(1,:))); 
            title(num2str(gasid)); pause(1)
            end
         end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        gid = gasid;
        fout = ['/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/abs.dat/g'];
        fout = [fout num2str(gasid) 'v' num2str(fmin) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
        disp(' ')
      else
        fprintf(1,'file too small : gas freq pp = %3i %6i %3i \n',gasid,fmin,pp);
        end  %% if
    end    %% loop over gasid

  disp(' ')
  fmin = fmin + dv;
  end                   %% loop over freq

