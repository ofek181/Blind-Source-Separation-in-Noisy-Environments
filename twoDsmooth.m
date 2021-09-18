function smat = twoDsmooth (mat,ker)
%TWO2SMOOTH = Smooth 2D matrix.
if prod(size(ker))==1, %if ker is a scalar
    kmat = ones(ker,ker)/ker^2;
else
    kmat = ker;
end
% make kmat have odd dimensions
[kr kc] = size(kmat); if rem(kr,2)==0,
    kmat = conv2(kmat,ones(2,1))/2;
    kr = kr + 1;
end
if rem(kc,2)==0,
    kmat = conv2(kmat,ones(1,2))/2;
    kc = kc + 1;
end

[mr mc] = size(mat);
fkr = floor(kr/2);% number of rows to copy on top and bottom
fkc = floor (kc /2); % number of columns to copy on either side
smat = conv2(...
    [mat(1,1)*ones(fkr,fkc) ones(fkr,1)*mat(1,:)...
     mat(1,mc)*ones(fkr,fkc);
     mat(:,1)*ones(1,fkc) mat mat(:,mc)*ones(1,fkc)
     mat(mr,1)*ones(fkr,fkc) ones(fkr,1)*mat(mr,:)...
     mat(mr,mc)*ones(fkr,fkc)],...
     flipud(fliplr(kmat)),'valid');