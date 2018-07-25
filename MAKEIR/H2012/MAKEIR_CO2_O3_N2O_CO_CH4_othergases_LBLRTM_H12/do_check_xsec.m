check_xsec = load('check_xsec.txt');

ii = find(check_xsec(:,1) >= 51 & check_xsec(:,1) <= 81);
check_xsec = check_xsec(ii,:);

ii = find(check_xsec(:,2) >= 605 & check_xsec(:,2) <= 2830);
check_xsec = check_xsec(ii,:);

ii = find(check_xsec(:,3) >= 605 & check_xsec(:,3) <= 2830);
check_xsec = check_xsec(ii,:);

clear xsec_expect
for ii = 51 : 81
  jj = find(check_xsec(:,1) == ii);
  zaa = check_xsec(jj,:);
  xsec_expect(ii-51+1) = 0;
  v1 = [];
  for kk = 1 : length(jj)
    v1 = [v1  zaa(kk,2) : 25 : zaa(kk,3)];
    xsec_expect(ii-51+1) = xsec_expect(ii-51+1) + round((zaa(kk,3)-zaa(kk,2))/25);
  end
end