function [p,Rv,h,X] = Maximization(Z,T,K,J,D,u,w)
p = zeros(D+1,K);
h = zeros(J,D,K);
Rv = zeros(J,J,K);
X = zeros(K,T,D);
Z = permute(Z,[3,1,2]); %[j,k,t]
%%
for k = 1:K
        for t = 1:T
            ztk = Z(:,k,t);
            for d = 1:D
                X(k,t,d) = w(k,t,d)*u(:,d,k)'*ztk;
            end
        end
        for d = 1:D+1
            w_sum = 0;
            for t = 1:T 
                w_sum = w_sum + w(k,t,d);
            end
            p(d,k) = (1/T)*w_sum; %normalize
        end
        numerator = zeros(J,D); %initialization for summation
        denominator = zeros(D); %initialization for summation
        num = zeros(J,D); den = zeros(D);
        for t = 1:T %sum over all time blocks
            ztk = Z(:,k,t); % BUG: ztk = permute(Z(k,t,:),[3 2 1])
            for d = 1:D
                num(:,d) = ztk*conj(X(k,t,d));%ww(k,t,d)*ztk*conj(X(k,t,d)); %sum variable numerator
                den(d) = real(X(k,t,d)*conj(X(k,t,d)));%ww(k,t,d)*(abs(X(k,t,d)))^2; % BUG:X(k,t,1)
                numerator(:,d) = numerator(:,d) + num(:,d); %BUG: numerator
                denominator(d) = denominator(d) + den(d); %summation for denominator
            end
        end
        for d = 1:D
            h(:,d,k) = numerator(:,d)/denominator(d); %h
        end
end
%%
for k = 1:K
    sum0=zeros(J,J);sum1=zeros(J,J);sum2=zeros(J,J);%sum initialize
    for t = 1:T %sum over all time blocks
        ztk = Z(:,k,t); 
        h1x1 = h(:,1,k)*X(k,t,1); %hdxd calc
        h2x2 = h(:,2,k)*X(k,t,2); %hdxd calc
        e0e0H = ztk*ztk';
        e1e1H = ztk*ztk' -2*real(h1x1*ztk') + (abs(X(k,t,1))^2)*h(:,1,k)*h(:,1,k)';
        e2e2H = ztk*ztk' -2*real(h2x2*ztk') + (abs(X(k,t,2))^2)*h(:,2,k)*h(:,2,k)';
        sum0 = sum0 + w(k,t,3)*e0e0H;
        sum1 = sum1 + w(k,t,1)*e1e1H;
        sum2 = sum2 + w(k,t,2)*e2e2H;
    end
    Rv(:,:,k) = (1/T)*(sum0+sum1+sum2); %Rv is the sum of the two speakers
end
end
