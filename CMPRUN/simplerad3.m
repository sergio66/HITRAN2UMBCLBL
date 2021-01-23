function r0 = simplerad1(fr,sec_theta,T,k0,iStartLay);

%% linear in tau layer T, pade 2

if iStartLay > 1
  r0 = ttorad(fr,(T(iStartLay-1)+T(iStartLay))/2)'; 
else
  r0 = ttorad(fr,T(iStartLay))'; 
end

for jj = iStartLay : 100; 
  raAbs = k0(:,jj)*sec_theta; 
  raTrans = exp(-raAbs);
  raIntenAvg = ttorad(fr,T(jj))'; 
  if jj < 100
    raIntenP1 = ttorad(fr,(T(jj)+T(jj+1))/2)'; 
  else
    raIntenP1 = ttorad(fr,T(jj))'; 
  end

  iPade = 1;
  iPade = 2;
  if (iPade == 1)
    %%% pade ONE
    raZeta = 0.2*raAbs;             %% pade one
    raFcn = (raIntenAvg + raZeta.*raIntenP1)./(1+raZeta);  %%% Eqn 15 JGR 1992
  elseif (iPade == 2)
    %%% pade TWO
    raZeta = 0.193*raAbs;           %% pade two
    raZeta2 = 0.013*raAbs.*raAbs;    %% pade two
    raFcn = (raIntenAvg + (raZeta + raZeta2).*raIntenP1)./(1+raZeta+raZeta2);   %%% Eqn 16 JGR 1992
  end

  r0 = r0.*raTrans + raFcn.*(1-raTrans); 
end

