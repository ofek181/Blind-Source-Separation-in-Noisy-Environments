%% Get record
clear 
close all
[s,fs] = audioread('OfekMika.wav');
[Z,T,K,J,D] = Get_Input(s);
%% EM algorithm live
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D);
NFFT=512;R=NFFT/2;
duet_speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
duet_speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
Iterations = 25;
for i = 1:Iterations
    [u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X);
    [p,Rv,h,X] = Maximization(Z,T,K,J,D,u,w);
    [h,X] = gain_ambguity(T,K,D,h,X);
end
%% Plots and sound
T = (0:size(X,2))/fs*R;
F = (0:NFFT/2)*fs/2/(NFFT/2);
figure(7)
imagesc(T,F,20*log10(abs(Z(:,:,1))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('Original signal');
figure(12)
subplot(2,1,1)
imagesc(T,F,20*log10(abs(X(:,:,1))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('1st speaker');
subplot(2,1,2)
imagesc(T,F,20*log10(abs(X(:,:,2))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('2nd speaker');
speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
soundsc(s(:,1),fs);
pause(8);
soundsc(speaker1,fs);
pause(8);
soundsc(speaker2,fs);