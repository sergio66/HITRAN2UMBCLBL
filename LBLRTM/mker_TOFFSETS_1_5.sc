# this is to automate
#mkdir ToffALL/Toff_01   mkdir ToffALL/Toff_02  ... mkdir ToffALL/Toff_11
#mkdir ToffALL/Toff2_01  mkdir ToffALL/Toff2_02 ... mkdir ToffALL/Toff2_11
#mkdir ToffALL/Toff3_01  mkdir ToffALL/Toff3_02 ... mkdir ToffALL/Toff3_11
#mkdir ToffALL/Toff4_01  mkdir ToffALL/Toff4_02 ... mkdir ToffALL/Toff4_11
#mkdir ToffALL/Toff5_01  mkdir ToffALL/Toff5_02 ... mkdir ToffALL/Toff5_11

## this makes ToffALL/Toff_01 ... ToffALL/Toff_11
for jj in {01..11}; do
  echo "mkdir -p ToffALL/Toff_${jj}"
  mkdir -p ToffALL/Toff_${jj}
done

## this makes ToffALL/Toff2_01 ... ToffALL/Toff2_11, ... , ToffALL/Toff5_01 ... ToffALL/Toff5_11
for ii in {2..5}; do
  for jj in {01..11}; do
    echo "mkdir -p ToffALL/Toff${ii}_${jj}"
    mkdir -p ToffALL/Toff${ii}_${jj}
  done
done

echo "now run copy_TOFFSETS_1_5.sc"
