function [h,p,Rv,X] = Initialization(Z,signal,T,K,J,D)
h = zeros(J,D,K); 
p = zeros(D+1,K); 
Rv = zeros(J,J,K);
for k = 1:K
    Rv(:,:,k) = eye(J); 
end
p(:,:) = 1;
[speaker1,speaker2] = duet(signal);
X(:,:,1) = stft(speaker1.',512,256,1,'Hamming');
X(:,:,2) = stft(speaker2.',512,256,1,'Hamming');
for k = 1:K
    num1 = zeros(J,1); num2 = zeros(J,1);
    den1 = 0; den2 = 0;
    for t = 1:T
        Sx1x1 = X(k,t,1)*X(k,t,1)';
        Sx2x2 = X(k,t,2)*X(k,t,2)';
        ztk = permute(Z(k,t,:),[3 2 1]);
        Szx1 = ztk*X(k,t,1)'; 
        Szx2 = ztk*X(k,t,2)'; 
        num1 = num1 + Szx1;
        num2 = num2 + Szx2;
        den1 = den1 + Sx1x1;
        den2 = den2 + Sx2x2;
    end
    h(:,1,k) = num1/den1;
    h(:,2,k) = num2/den2;
end
end

