## see sergio_matlab_chip_makegas3_42.sbatch

## see gN_ir_list.txt : gas 7 is from 3202 to 3454. Run first into a slurm file, others into dev null
sbatch --array=3202                           sergio_matlab_chip_makegas3_42.sbatch
sbatch --array=3203-3454 --output='/dev/null' sergio_matlab_chip_makegas3_42.sbatch

## see gN_ir_list.txt : gas 22 is from 14653 to 15093. Run first into a slurm file, others into dev null
sbatch --array=14653                            sergio_matlab_chip_makegas3_42.sbatch
sbatch --array=14654-15093 --output='/dev/null' sergio_matlab_chip_makegas3_42.sbatch
