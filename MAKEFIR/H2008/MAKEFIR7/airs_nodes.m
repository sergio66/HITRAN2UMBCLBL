%script airs_nodes;

%%%%copied from /carrot/s1/strow/Run/get_runparams.m

%[s,hostname]=unix('printenv | grep HOSTNAME | cut -c10-');
%hostname = deblank(hostname);

[s,hostname]=unix('echo $HOSTNAME');
hostname = deblank(hostname);
fprintf(1,'hostname = %s \n',hostname);

switch hostname
 case{'airs1'}
  iNode = 1;
 
 case{'airs2'}
  iNode = 2;
 
 case{'airs3'}
  iNode = 3;
 
 case{'airs4'}
  iNode = 4;
 
 case{'airs5'}
  iNode = 5;
 
 case{'airs6'}
  iNode = 6;
 
 case{'airs7'}
  iNode = 7;
 
 case{'airs8'}
  iNode = 8;
 
 case{'airs9'}
  iNode = 9;
 
 case{'airs10'}
  iNode = 10;
 
 case{'airs11'}
  iNode = 11;
 
 case{'airs12'}
  iNode = 12;
 
 case{'airs13'}
  iNode = 13;
 
 case{'airs14'}
  iNode = 14;
 
 case{'airs15'}
  iNode = 15; 

 case{'airs16'}
   iNode = 16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case{'airs17'}
  iNode = 17;
 
 case{'airs18'}
  iNode = 18;
 
 case{'airs19'}
  iNode = 19;
 
 case{'airs20'}
  iNode = 20;
 
 case{'airs21'}
  iNode = 21;
 
 case{'airs22'}
  iNode = 22;
 
 case{'airs23'}
  iNode = 23;
 
 case{'airs24'}
  iNode = 24;
 
 case{'airs25'}
  iNode = 25;
 
 case{'airs26'}
  iNode = 26;
 
 case{'airs27'}
  iNode = 27;
 
 case{'airs28'}
  iNode = 28;
 
 case{'airs29'}
  iNode = 29;
 
 case{'airs30'}
  iNode = 30;
 
 case{'airs31'}
  iNode = 31; 

 case{'airs32'}
   iNode = 32;
  
 case{'asl'}
  iNode = 18;
  iNode = 17;

 case{'aux1'}
  iNode = 19;  

 case{'aux2'}
  iNode = 393939;  

 case{'aux3'}
  iNode = 20;
 
 case{'aux4'}
  iNode = 21;

 case{'chard'}
  iNode = 37;
  
 otherwise
  disp('You are not on air1-32, chard, asl or the aux nodes!');
  iNode = -1;
  error('BAH at airs_nodes')

end

iNode

%%% for testing on airs32
iUseNodes = 1;    %% there are this many script_find2d jobs to run
iNodeMin = 32;    %% start at this node
iNodeMax = 32;    %% end at this node

%%% for general stuff
iUseNodes = 16;   %% there are this many script_find2d jobs to run
iNodeMin = 17;    %% start at this node
iNodeMax = 32;    %% end at this node

%%% for using airs31,32 for iDoJob = 17,18
iUseNodes = 2;   %% there are this many script_find2d jobs to run
iNodeMin = 14;   %% start at this node
iNodeMax = 32;   %% end at this node

iNodeMin = 17;   %% start at this node
iNodeMax = 34;   %% end at this node

str = ['script to use airs nodes ' num2str(iNodeMin) ' to ' num2str(iNodeMax)];
if iNode < iNodeMin
  error(str)
elseif (iNode > iNodeMax)
  error(str)
else
  iDoJob = iNode - iNodeMin + 1
  pause((iDoJob-1)*1);
  end

