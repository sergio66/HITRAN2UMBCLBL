rmer = ['!/bin/rm slurm*.out ']; eval(rmer);
gid = input('Enter gid (2:47) : ');

iN = (1:11) + (gid-1-1)*11;
iN1 = iN(1); iN2 = iN(end);

batcher1 = ['!sbatch --array=' num2str(iN1) '-' num2str(iN2) ' sergio_matlab_jobB.sbatch '];
batcher2 = ['!sbatch --array=' num2str(iN1) '-' num2str(iN2) ' sergio_matlab_jobB_2.sbatch '];
batcher3 = ['!sbatch --array=' num2str(iN1) '-' num2str(iN2) ' sergio_matlab_jobB_3.sbatch '];
batcher4 = ['!sbatch --array=' num2str(iN1) '-' num2str(iN2) ' sergio_matlab_jobB_4.sbatch '];

eval(batcher1)
eval(batcher2)
eval(batcher3)
eval(batcher4)

%{
/bin/rm slurm*.out; 
sbatch --array=463-473 sergio_matlab_jobB.sbatch 
sbatch --array=452-462 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=441-451 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=430-440 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=419-429 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=408-418 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=397-407 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=386-396 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=375-385 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=364-374 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=353-363 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=342-352 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=331-341 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=320-330 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=309-319 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=298-308 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=287-297 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=276-286 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=265-275 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=254-264 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=243-253 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=232-242 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=221-231 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=210-220 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=199-209 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=188-198 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=177-187 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=166-176 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=155-165 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=144-154 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=133-143 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=122-132 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=111-121 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=100-110 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=89-99 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=78-88 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=67-77 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=56-66 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=45-55 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=34-44 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=23-33 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=12-22 -d singleton sergio_matlab_jobB.sbatch 
sbatch --array=1-11 -d singleton sergio_matlab_jobB.sbatch 

sbatch --array=463-473 sergio_matlab_jobB_2.sbatch 
sbatch --array=452-462 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=441-451 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=430-440 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=419-429 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=408-418 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=397-407 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=386-396 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=375-385 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=364-374 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=353-363 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=342-352 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=331-341 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=320-330 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=309-319 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=298-308 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=287-297 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=276-286 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=265-275 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=254-264 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=243-253 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=232-242 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=221-231 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=210-220 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=199-209 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=188-198 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=177-187 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=166-176 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=155-165 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=144-154 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=133-143 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=122-132 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=111-121 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=100-110 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=89-99 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=78-88 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=67-77 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=56-66 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=45-55 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=34-44 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=23-33 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=12-22 -d singleton sergio_matlab_jobB_2.sbatch 
sbatch --array=1-11 -d singleton sergio_matlab_jobB_2.sbatch 

sbatch --array=1-11   sergio_matlab_jobB_3.sbatch 
sbatch --array=12-22 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=23-33 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=34-44 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=45-55 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=56-66 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=67-77 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=78-88 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=89-99 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=100-110 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=111-121 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=122-132 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=133-143 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=144-154 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=155-165 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=166-176 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=177-187 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=188-198 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=199-209 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=210-220 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=221-231 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=232-242 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=243-253 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=254-264 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=265-275 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=276-286 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=287-297 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=298-308 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=309-319 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=320-330 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=331-341 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=342-352 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=353-363 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=364-374 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=375-385 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=386-396 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=397-407 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=408-418 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=419-429 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=430-440 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=441-451 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=452-462 -d singleton sergio_matlab_jobB_3.sbatch 
sbatch --array=463-473 -d singleton sergio_matlab_jobB_3.sbatch 

sbatch --array=1-11   sergio_matlab_jobB_4.sbatch 
sbatch --array=12-22 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=23-33 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=34-44 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=45-55 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=56-66 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=67-77 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=78-88 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=89-99 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=100-110 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=111-121 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=122-132 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=133-143 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=144-154 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=155-165 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=166-176 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=177-187 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=188-198 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=199-209 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=210-220 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=221-231 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=232-242 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=243-253 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=254-264 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=265-275 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=276-286 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=287-297 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=298-308 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=309-319 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=320-330 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=331-341 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=342-352 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=353-363 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=364-374 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=375-385 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=386-396 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=397-407 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=408-418 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=419-429 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=430-440 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=441-451 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=452-462 -d singleton sergio_matlab_jobB_4.sbatch 
sbatch --array=463-473 -d singleton sergio_matlab_jobB_4.sbatch 
%}