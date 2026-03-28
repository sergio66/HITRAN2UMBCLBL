# this is to automate
#mkdir ToffALL/ToffWV_01   mkdir ToffALL/ToffWV_02  ... mkdir ToffALL/ToffWV_11
#mkdir ToffALL/ToffWV2_01  mkdir ToffALL/ToffWV2_02 ... mkdir ToffALL/ToffWV2_11
#mkdir ToffALL/ToffWV3_01  mkdir ToffALL/ToffWV3_02 ... mkdir ToffALL/ToffWV3_11
#mkdir ToffALL/ToffWV4_01  mkdir ToffALL/ToffWV4_02 ... mkdir ToffALL/ToffWV4_11
#mkdir ToffALL/ToffWV5_01  mkdir ToffALL/ToffWV5_02 ... mkdir ToffALL/ToffWV5_11

## this makes ToffALL/ToffWV_01 ... ToffALL/ToffWV_11
for jj in {01..11}; do
  echo "mkdir -p ToffALL/ToffWV_${jj}"
  mkdir -p ToffALL/ToffWV_${jj}
done

## this makes ToffALL/ToffWV2_01 ... ToffALL/ToffWV2_11, ... , ToffALL/ToffWV5_01 ... ToffALL/ToffWV5_11
for ii in {2..5}; do
  for jj in {01..11}; do
    echo "mkdir -p ToffALL/ToffWV${ii}_${jj}"
    mkdir -p ToffALL/ToffWV${ii}_${jj}
  done
done

echo "now run copy_TOFFSETS_WV.sc"

