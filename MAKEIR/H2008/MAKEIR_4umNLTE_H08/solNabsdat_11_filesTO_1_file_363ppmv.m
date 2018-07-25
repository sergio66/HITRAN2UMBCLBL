xstartup
addpath /home/sergio/KCARTA/MATLAB

%[d49,w49] = readkcstd('quickuseLTE.dat');

solangles = [0 40 60 80 85 90 120];
solangles = [0];

gid = 2;
for ss = 1 : length(solangles)
   cder = ['cd /asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/' num2str(solangles(ss))];
   cder = [cder '_363ppm/'];
   eval(cder);
   clear fr k planck

   for pp = 1:11
     ppstr = num2str(pp);
     fprintf(1,'reading files for SOL = %3i TOFFSET = %3i \n',solangles(ss),(pp-6)*10)

     %% upper atm ODs and rads [0.005mb 0.0005 mb]
     fUA     = ['std2205_2_' ppstr '.dat_UA'];
     [dua,w] = readkcUA(fUA);

     %% lower atm/upper atm  planck modifiers
     fPL         = ['std2205_2_' ppstr '.dat_PLANCK'];
     [dPlanck,w] = readkcPlanck(fPL);

     fD = ['std2205_2_' ppstr '.dat'];
     [d,w] = readkcstd(fD);

     %whos w d dPlanck dua
     %error('lkjgs')

     dOD = [d(:,1:100) dua(:,1:35)];
     %%%%%%%% NO NEED FIXED NO NEED 
     %%%%%%%% dPlanck = [ones(80000,3) dPlanck];   %% we only dumped layers 4-100,101-135

     figure(1); 
       semilogx(dPlanck(70001,1:132),1:132,'o-')
       title(['SOL = ' num2str(solangles(ss)) ' TOFF = ' num2str((pp-6)*10)])
     figure(2); 
       semilogx(dOD(70001,1:135),1:135,'o-')
       title(['SOL = ' num2str(solangles(ss)) ' TOFF = ' num2str((pp-6)*10)])
     pause(0.1)

     wx = 1:length(w);
     frx = w(1) + (wx-1)*0.0025;

     kx(:,:,pp) = dOD;
     planckx(:,:,pp) = dPlanck;

     whos dOD dPlanck
   end
   ret(0.1)

   disp('saving data chunks ....')   
   for iChunk = 1 : 8
     iaChunk = (1:10000) + (iChunk-1)*10000;
     fr     = frx(iaChunk)';
     k      = kx(iaChunk,:,:);
     planck = planckx(iaChunk,:,:);     

     %%%%%%%% NO NEED FIXED NO NEED 
%{     %%% NO LONGER NEED THIS AS WE DUMP OUT ALL ODs from 1--100
     clear lte_absdat ltefile
     %% lowest 3 layers need to be fixed, as I dumped ZEROS
     ltefile = ['/asl/s1/sergio/H2008_RUN8_NIRDATABASE/IR_605_2830_H08_CO2/abs.dat/'];
     ltefile = [ltefile '/g2v' num2str(fr(1)) '.mat'];
     lte_absdat = load(ltefile);
     k(:,1:3,:) = lte_absdat.k(:,1:3,:) * 385/370;
%}    %%%%%%%% NO NEED FIXED NO NEED 

     saver = ['save /asl/s1/sergio/H2008_RUN8_NIRDATABASE/4umNLTE/abs.dat/'];
     saver = [saver 'g2v' num2str(fr(1)) '_' num2str(solangles(ss)) '_363ppmv.mat '];
     saver = [saver ' gid k fr planck'];
     fprintf(1,'  saving SOL = %3i FREQ = %4i \n',solangles(ss),fr(1));
     whos fr k planck
     eval(saver);
   end
   ret(0.1)

end
