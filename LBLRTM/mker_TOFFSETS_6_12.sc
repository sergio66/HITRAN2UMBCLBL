# this is to automate
#mkdir ToffALL/Toff6_01   mkdir ToffALL/Toff6_02  ... mkdir ToffALL/Toff6_11
#mkdir ToffALL/Toff7_01   mkdir ToffALL/Toff7_02  ... mkdir ToffALL/Toff7_11
#mkdir ToffALL/Toff8_01   mkdir ToffALL/Toff8_02  ... mkdir ToffALL/Toff8_11
#mkdir ToffALL/Toff9_01   mkdir ToffALL/Toff9_02  ... mkdir ToffALL/Toff9_11
#mkdir ToffALL/Toff10_01  mkdir ToffALL/Toff10_02 ... mkdir ToffALL/Toff10_11
#mkdir ToffALL/Toff11_01  mkdir ToffALL/Toff11_02 ... mkdir ToffALL/Toff11_11
#mkdir ToffALL/Toff12_01  mkdir ToffALL/Toff12_02 ... mkdir ToffALL/Toff12_11

## this makes ToffALL/Toff6_01 ... ToffALL/Toff6_11, ... , ToffALL/Toff12_01 ... ToffALL/Toff12_11
for ii in {6..12}; do
  for jj in {01..11}; do
    echo "mkdir -p ToffALL/Toff${ii}_${jj}"
    mkdir -p ToffALL/Toff${ii}_${jj}
  done
done

echo "now run copy_TOFFSETS_6_12.sc"
