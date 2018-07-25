nbox = 5;
pointsPerChunk = 10000;
gases = [1];

%%%% to do things for MODIS vis
wnVIS = [4650 6095 8065 11550 15150 18150 20055 21250];
wnVIS = [4650 6095 8065 11550 15150 18150 20055 21250] - 12.5;
wnVIS1 = 4500;
wnVIS1 = 6050;
wnVIS2 = 22000;

%%% sims for testing things in NIR
wnVIS1 = 4250;
wnVIS2 = 4250;

load /home/sergio/abscmp/refproTRUE.mat
poffset = [0.1, 1.0, 3.3, 6.7, 10.0];

fmin = wnVIS1; 
topts = runXtopts_params_smart(fmin); 
dv = topts.ffin*nbox*pointsPerChunk;

while fmin <= wnVIS2
  topts = runXtopts_params_smart(fmin);
  dv = topts.ffin*nbox*pointsPerChunk;
  fmax = fmin + dv;
  gg = 1;   %%gasID = 1
  gid = gg;  

  iSave = -1;
  fr = [];
  k = zeros(10000,100,11);
  for mm = 1 : 5
    for pp = -5 : +5
      fin = ...
        ['/carrot/s1/sergio/RUN8_VISDATABASE/VIS4000_4500/std' num2str(fmin)];
      fin = [fin '_1_' num2str(pp+6) '_' num2str(mm) '.mat'];
      lser = dir(fin);
      if lser.bytes > 5000000
        iSave = +1;
        fprintf(1,'gas freq pp mm = %3i %6i %3i %3i \n',gg,fmin,pp,mm);

        loader = ['load ' fin ];
        eval(loader);

        fr = w;
        k(:,:,pp+6) = d';
        if pp == 0
          plot(fr,exp(-d(1,:)));   % disp('ret to continue');   
          title(num2str(mm));      pause(0.1)
          end
        end
      end                 %% loop over temperature (1..11) pp
      if iSave > 0
        fout = ['/carrot/s1/sergio/RUN8_VISDATABASE/VIS4000_4500/abs.dat/g'];
        fout = [fout '1v' num2str(fmin) 'p' num2str(mm) '.mat'];
        saver = ['save ' fout ' fr gid k ' ];
        eval(saver);
      else
        fprintf(1,'file too small : gas freq pp = %3i %6i %3i \n',gg,fmin,pp);
        end  %% if
    end                 %% loop over m
  fmin = fmin + dv;
  end                   %% loop over freq

