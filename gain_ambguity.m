function [h,X] = gain_ambguity(T,K,D,h,X)
%h is divided by its first for every speaker and every frequency (d,k)
%x is multiplied by that h for every (d,k)
% X=permute(X,[3,1,2]);
for k = 1:K
    for d = 1:D
        hkd = h(:,d,k); hkd1 = hkd(1);
        h(:,d,k) = hkd/hkd1;
        for t = 1:T
            X(k,t,d) = X(k,t,d)*hkd1;
        end
    end
end
end

