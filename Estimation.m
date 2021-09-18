function [u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X)
%%
u = zeros(J,D,K); 
w = zeros(K,T,D+1);
Z = permute(Z,[3,1,2]); %[j,k,t]
%%
for k = 1:K
    inv_Rv = eye(J)/(Rv(:,:,k)+eye(J)*trace(Rv(:,:,k))*1e-4); %inverse of Rv
    for d = 1:D
        u(:,d,k) = (inv_Rv*h(:,d,k))/(h(:,d,k)'*inv_Rv*h(:,d,k)); %u
    end
    for t = 1:T
        ztk = Z(:,k,t);
        h1x1 = h(:,1,k)*X(k,t,1); %hdxd calc
        h2x2 = h(:,2,k)*X(k,t,2); %hdxd calc
        numerator1 = p(1,k)*NC(ztk,h1x1,Rv(:,:,k)); %1st speaker
        numerator2 = p(2,k)*NC(ztk,h2x2,Rv(:,:,k)); %2nd speaker
        numerator3 = p(3,k)*NC(ztk,0,Rv(:,:,k)); %silence
        w(k,t,1) = max(numerator1/(numerator3+numerator1+numerator2),1e-3);
        w(k,t,2) = max(numerator2/(numerator3+numerator1+numerator2),1e-3);
        w(k,t,3) = max(numerator3/(numerator3+numerator1+numerator2),1e-3);
    end
end
end
