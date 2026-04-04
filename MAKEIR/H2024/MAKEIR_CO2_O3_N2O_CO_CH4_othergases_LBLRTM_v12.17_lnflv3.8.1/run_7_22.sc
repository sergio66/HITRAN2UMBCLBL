/bin/rm slurm*.out

## THIS IS OLD BAD CODE    clust_runXtopts_savegasN_file_N2O2only,clust_runXtopts_savegasN_file_N2O2only_2
# ## put O2 on Toffset/Toff_1,2,3,4,5,6,7,8,9,10,11
# sbatch --array=01-11 sergio_matlab_chip_jobB.sbatch 11
# 
# ## put N2 on Toffset/Toff2_1,2,3,4,5,6,7,8,9,10,11
# sbatch --array=12-22 sergio_matlab_chip_jobB.sbatch 12

########################################################################

## THIS IS NEW CODE  new_clust_runXtopts_savegasN_file_N2only, new_clust_runXtopts_savegasN_file_O2only
# ## put O2 on Toffset/Toff_1,2,3,4,5,6,7,8,9,10,11
sbatch --array=01-11 sergio_matlab_chip_jobB.sbatch 11
# 
# ## put N2 on Toffset/Toff2_1,2,3,4,5,6,7,8,9,10,11
sbatch --array=01-11 sergio_matlab_chip_jobB.sbatch 12

