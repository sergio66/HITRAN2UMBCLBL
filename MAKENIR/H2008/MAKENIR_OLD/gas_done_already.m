function  [freqchunk, numchunk] = gas_done_already(gasid);

figure(1); clf
%gasid = input('enter gas id : ');

lines = show_vis_ir_lines_wavenumber_individualgas(6,gasid);
if length(lines.iso) > 1
  figure(1);
  semilogy(lines.wnum,lines.stren);
  oo = find(lines.wnum >= 2805-25 &  lines.wnum <= 3555+25);
  if length(oo) > 0
    semilogy(lines.wnum(oo),lines.stren(oo));
    axis([2805-25 3555+25 min(lines.stren(oo)) max(lines.stren(oo))])
    fprintf(1,'found %5i lines between 2805 & 3555 cm-1 \n',length(oo))

    fchunk = 0;
    for ff = 2805 : 25 : 3555
      fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
      boof = find(lines.wnum >= ff-25 &  lines.wnum <= ff+25);
      hitlinesfound(fchunk) = length(boof);
      end
    end
  end

homedir = pwd;
dir0 = '/spinach/s6/sergio/RUN8_NIRDATABASE/NIR2830_3330/';
cder = ['cd ' dir0]; eval(cder);

clear foundname
jj = 0;

if gasid > 1
  fchunk = 0;
  for ff = 2805 : 25 : 3555
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      fname = ['std' num2str(ff) '_' num2str(gasid) '_' num2str(kk) '.mat'];
      dirr = dir(fname);
      if length(dirr) == 1
        jj = jj + 1;
        ifound = ifound + 1;
        foundname(jj).name = dirr.name;
        end
      end
    numchunk(fchunk) = ifound;
    end 
  end

if gasid == 1
  fchunk = 0;
  for ff = 2805 : 25 : 3555
    fchunk = fchunk + 1;  freqchunk(fchunk) = ff;
    ifound = 0;
    for kk = 1 : 11
      for pp =  1 : 5
        fname = ['std' num2str(ff) '_' num2str(gasid) '_' num2str(kk)];
        fname = [fname '_' num2str(pp) '.mat'];
        dirr = dir(fname);
        if length(dirr) == 1
          jj = jj + 1;
          ifound = ifound + 1;
          foundname(jj).name = dirr.name;
          end
        end
      end
    numchunk(fchunk) = ifound;
    end 
  end

cd /home/sergio/abscmp/MAKENIR
fprintf(1,'found %5i files for gasid %3i \n',jj,gasid);
if  jj > 0
  for kk = 1 : jj
    fprintf(1,'%4i  %3i %s \n',kk,gasid,foundname(kk).name);
    end
  disp('freqchunk hitlinesfound numchunk')
  [freqchunk; hitlinesfound; numchunk]'
  fprintf(1,'found %5i lines between 2805 & 3555 cm-1 \n',length(oo))
  figure(1); title(num2str(gasid));
  end