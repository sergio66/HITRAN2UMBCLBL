%% usual res
usual2 = load('/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat/abs.dat/g1v780p2.mat');
usual5 = load('/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830/g1.dat/abs.dat/g1v780p5.mat');
od_usual2 = squeeze(usual2.k(:,:,6));
od_usual5 = squeeze(usual5.k(:,:,6));
plot(usual2.fr,sum(od_usual2'),usual2.fr,sum(od_usual5'))
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% high res
hi2 = load('/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/WV/abs.dat0.0005//g1v795p2.mat');
hi5 = load('/asl/s1/sergio/H2016_RUN8_NIRDATABASE/IR_605_2830//lblrtm12.8/WV/abs.dat0.0005//g1v795p5.mat');
od_hi2 = squeeze(hi2.k(:,:,6));
od_hi5 = squeeze(hi5.k(:,:,6));
plot(hi2.fr,sum(od_hi2'),hi2.fr,sum(od_hi5'))
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(hi2.fr,sum(od_hi2'),'b',hi2.fr,sum(od_hi5'),'r',usual2.fr,sum(od_usual2'),'c',usual2.fr,sum(od_usual5'),'m')
axis([797.5 799.5 0 40]); grid
