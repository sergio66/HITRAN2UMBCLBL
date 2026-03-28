/bin/rm slurm*.out

## put CO2 on Toffset/Toff_1,2,3,4,5,6,7,8,9,10,11
sbatch --array=01-11 sergio_matlab_chip_jobB.sbatch 1

## put CH4 on Toffset/Toff2_1,2,3,4,5,6,7,8,9,10,11
sbatch --array=12-22 sergio_matlab_chip_jobB.sbatch 2
