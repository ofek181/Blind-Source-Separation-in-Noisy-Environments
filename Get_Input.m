function [Z,T,K,J,D] = Get_Input(x)
S1 = stft(x(:,1),512,256,1,'Hamming');
S2 = stft(x(:,2),512,256,1,'Hamming');
S3 = stft(x(:,3),512,256,1,'Hamming');
S4 = stft(x(:,4),512,256,1,'Hamming');
S5 = stft(x(:,5),512,256,1,'Hamming');
S6 = stft(x(:,6),512,256,1,'Hamming');
S7 = stft(x(:,7),512,256,1,'Hamming');
S8 = stft(x(:,8),512,256,1,'Hamming');
J = 8;
D = 2;
K = length(S1(:,1));
T = length(S1(1,:));
Z = zeros(K,T,J);
Z(:,:,1) = S1;
Z(:,:,2) = S2;
Z(:,:,3) = S3;
Z(:,:,4) = S4;
Z(:,:,5) = S5;
Z(:,:,6) = S6;
Z(:,:,7) = S7;
Z(:,:,8) = S8;
end

