function r0 = simplerad1(fr,sec_theta,T,k0,iStartLay);

%% constant layer T

if iStartLay > 1
  r0 = ttorad(fr,(T(iStartLay-1)+T(iStartLay))/2)'; 
else
  r0 = ttorad(fr,T(iStartLay))'; 
end

for jj = iStartLay : 100; 
  kjunk = k0(:,jj)*sec_theta; 
  tjunk = exp(-kjunk); 
  rjunk = ttorad(fr,T(jj))'; 
  r0 = r0.*tjunk + rjunk.*(1-tjunk); 
end

