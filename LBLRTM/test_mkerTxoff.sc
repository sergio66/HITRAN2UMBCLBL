# this is to automate
#mkdir Toff_01   mkdir Toff_02 ...  mkdir Toff_11
#mkdir Toff2_01  mkdir Toff2_02 ... mkdir Toff2_11

## simple 1 : notice the 01 automatically makes all dir names have the same padding dir01 dir02 .. dir11 dir12 ...
##            else they would be dir1 dir2 ... dir11 dir12 ...
for ii in {09..11}; do
  for jj in {01..05}; do
    mkdir -p junkToff${ii}_${jj}
  done
done

## more complicated, uses seq
x1=12;
x2=15;
seq -w $x1 $x2
for ii in $(seq -w $x1 $x2); do
  for jj in {01..05}; do
    echo "mkdir -p junkToff${ii}_${jj}"
  done
done
