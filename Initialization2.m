function [h,p,Rv,X] = Initialization2(Z,T,K,J,D)
h = zeros(J,D,K); 
p = zeros(D+1,K); 
Rv = zeros(J,J,K);
Z = permute(Z,[3,1,2]);
p(:,:) = 1;
w = zeros(K,T,D+1);
sum_var = zeros(J,J,K);
R = zeros(J,J,K);
u = zeros(J,D,K); 
X = zeros(K,T,D);
for k = 1:K
    Rv(:,:,k) = eye(J); 
    for t = 1:T
        ztk = Z(:,k,t);
        sum_var(:,:,k) = sum_var(:,:,k) + ztk*ztk'; %initialization of R
    end
    R(:,:,k) = (1/T)*sum_var(:,:,k);
    [V,D1] = eig(R(:,:,k));
    [d1,ind] = sort(diag(D1),'descend');
    Ds = D1(ind,ind);
    Vs = V(:,ind);
%     [V,D1] = eig(R(:,:,k)); %calculating eigen vectors and values
%     e_vec = fliplr(V); %eigen vectors in descending order
%     e_val = sort(diag(D1),'descend'); %eigen values in descending order
    h(:,1,k) = (Vs(:,1)+Vs(:,2))/sqrt(d1(1)+d1(2));
    h(:,2,k) = (Vs(:,1)-Vs(:,2))/sqrt(d1(1)+d1(2));
    for t = 1:T
        ztk = Z(:,k,t);
        numerator1 = p(1,k)*NC(ztk,0,h(:,1,k)*h(:,1,k)'+Rv(:,:,k)); %1st speaker
        numerator2 = p(2,k)*NC(ztk,0,h(:,2,k)*h(:,2,k)'+Rv(:,:,k)); %2nd speaker
        numerator3 = p(3,k)*NC(ztk,0,Rv(:,:,k)); %silence
        l1 = max(numerator1/(numerator3+numerator1+numerator2),1e-3);
        l2 = max(numerator2/(numerator3+numerator1+numerator2),1e-3);
        l3 = max(numerator3/(numerator3+numerator1+numerator2),1e-3);
        w(k,t,1) = l1;
        w(k,t,2) = l2;
        w(k,t,3) = l3;
    end
    for d = 1:D
        ll =  h(:,d,k)/(h(:,d,k)'*h(:,d,k));
        u(:,d,k) = ll; %u
    end
    for t = 1:T
        ztk = Z(:,k,t);
        for d = 1:D
            X(k,t,d) = w(k,t,d)*u(:,d,k)'*ztk;
        end
    end
end
end

