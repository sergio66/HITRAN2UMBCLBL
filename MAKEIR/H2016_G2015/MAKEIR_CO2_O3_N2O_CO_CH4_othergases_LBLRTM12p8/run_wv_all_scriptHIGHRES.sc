#  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo 'see /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LNFL2.6/aer_v_3.2/line_files_By_Molecule/01_H2O/Readme'

# %{
# >>> disp('qtips04.m : for water the isotopes are 161  181  171  162  182  172');
# lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl
# originally
# -rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
# -rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
# -rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
# -rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
# -rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
# -rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
# -rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
# -rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O
# 
# now
# lrwxrwxrwx 1 sergio pi_strow      15 Apr 28 12:03 01_H2O -> 01_h2o_162_excl
# -rw-r--r-x 1 sergio pi_strow   44464 Oct 22  2012 01_h2o_172_only
# -rw-r--r-x 1 sergio pi_strow 1586522 Oct 22  2012 01_h2o_181_only
# -rw-r--r-x 1 sergio pi_strow  275660 Oct 22  2012 01_h2o_182_only
# -rw-r--r-x 1 sergio pi_strow 1142001 Oct 22  2012 01_h2o_171_only
# -rw-r--r-x 1 sergio pi_strow 1910454 Oct 22  2012 01_h2o_162_only
# -rw-r--r-x 1 sergio pi_strow 8956941 Oct 22  2012 01_h2o_162_excl
# -rw-r--r-x 1 sergio pi_strow 5989739 Oct 22  2012 01_h2o_161_only
# -rw-r--r-x 1 sergio pi_strow 6807226 Oct 22  2012 01_H2O_use_this_for_all
# 
# ie (a) have moved 01_H2O to 01_H2O_use_this_for_all
#    (b) currently symbolically link          01_H2O  to  01_h2o_162_excl         which is everything but the HDO (isotope 4) database  (gas 1)
#    (c) after this is done symbolically link 01_H2O  to  01_h2o_162_only         which is ONLY the HDO isotope                         (gas 103)
#    (d) after this is done symbolically link 01_H2O  to  01_H2O_use_this_for_all which is default                                      (gas 110)
# %}
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/bin/rm slurm*.out; 
sbatch --exclude=cnode[225,267] --array=1-11    sergio_matlab_jobHighResWV.sbatch 1
sbatch --exclude=cnode[225,267] --array=12-22   sergio_matlab_jobHighResWV.sbatch 2
sbatch --exclude=cnode[225,267] --array=23-33   sergio_matlab_jobHighResWV.sbatch 3
sbatch --exclude=cnode[225,267] --array=34-44   sergio_matlab_jobHighResWV.sbatch 4
sbatch --exclude=cnode[225,267] --array=45-55   sergio_matlab_jobHighResWV.sbatch 5
