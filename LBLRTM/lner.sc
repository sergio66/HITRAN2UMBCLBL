## this is called by copy_TOFFSETS.sc at each subdir that it goes and cleans/creates

/bin/rm TAPE3 lblrtm xs FSCDXS slblrtm

dovers=122
dovers=124
dovers=128

compiler=20  ## pgi   sgl
compiler=21  ## pgi   dbl  gives EXIT error and does not work well with Matlab

compiler=01  ## gnu   dbl/sng

compiler=11  ## intel dbl
compiler=10  ## intel dbl,gnu sgl

if [ $dovers -eq 122 ]
then
### v12.2
  echo 'see lner.sc .... linking to LBLRTM 12.2'
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/run_examples/TAPE3_files/TAPE3_aer_v_3.2_ex_little_endian    TAPE3
  #ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/lblrtm_v12.2_linux_pgi_dbl                                  lblrtm
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/lblrtm_v12.2_linux_intel_dbl                                 lblrtm
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/xs_files/xs                                                  xs
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.2/lblrtm/xs_files/FSCDXS                                              FSCDXS
elif [ $dovers -eq 124 ]
then
### v12.4 from LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/run_examples/ Apr/May 2016
#  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/run_examples/TAPE3_files/TAPE3_aer_v_3.4_ex_little_endian    TAPE3
#  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/run_examples/xs_files_v3.4/xs                                xs
#  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/run_examples/xs_files_v3.4/FSCDXS                            FSCDXS

### v12.4 from what I downloaded from AER in June 2016
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LNFL/run_examples/run_example_infrared_sergio/TAPE3_aer_v_3.4              TAPE3
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LINEDATAFILE/aer_v_3.4/xs_files_v3.4/xs                                    xs
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LINEDATAFILE/aer_v_3.4/xs_files_v3.4/FSCDXS                                FSCDXS 

  if [ $compiler -eq 01 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.4 ...gnu dbl sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_gnu_dbl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_gnu_sgl                                  slblrtm
  elif [ $compiler -eq 11 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.4 ...intel ifort dbl / gnu sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_intel_dbl                                lblrtm
    #ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_intel_sgl                                slblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_gnu_sgl                                  slblrtm    
  elif [ $compiler -eq 21 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.4 ...pgf dbl gnu sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_pgi_dbl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_gnu_sgl                                  slblrtm    
  elif [ $compiler -eq 20 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.4 ...pgf sgl gnu sgl'      
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_pgi_sgl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.4/LBLRTM/lblrtm/lblrtm_v12.4_linux_gnu_sgl                                  slblrtm    
  else
    echo 'see lner.sc .... linking to LBLRTM 12.4 ...incorrect compiler option'
  fi    

elif [ $dovers -eq 128 ]
then

### v12.8 from what I downloaded from AER in June 2016
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LNFL/lnfl/run_examples/run_example_infrared_sergio/TAPE3_aer_v_3.6         TAPE3
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LINEDATAFILE/aer_v_3.6/xs_files_v3.6/xs                                    xs
  ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LINEDATAFILE/aer_v_3.6/xs_files_v3.6/FSCDXS                                FSCDXS 

  if [ $compiler -eq 01 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...gnu dbl sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_dbl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_sgl                                  slblrtm
  elif [ $compiler -eq 10 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...intel ifort sgl and dbl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_intel_dbl                                lblrtm
    #ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_intel_sgl                                slblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_sgl                                  slblrtm    
  elif [ $compiler -eq 11 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...intel ifort dbl / gnu sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_intel_dbl                                lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_sgl                                  slblrtm    
  elif [ $compiler -eq 21 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...pgf dbl gnu sgl'
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_pgi_dbl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_sgl                                  slblrtm    
  elif [ $compiler -eq 20 ]
  then
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...pgf sgl gnu sgl'      
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_pgi_sgl                                  lblrtm
    ln -s /home/sergio/IR_NIR_VIS_UV_RTcodes/LBLRTM/LBLRTM12.8/LBLRTM/lblrtm/lblrtm_v12.8_linux_gnu_sgl                                  slblrtm    
  else
    echo 'see lner.sc .... linking to LBLRTM 12.8 ...incorrect compiler option'
  fi    

else
  echo 'lner.sc  ...incorrect LBLRTM version'
fi
