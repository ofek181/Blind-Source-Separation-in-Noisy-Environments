%% Generate
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/Results/OfekMika/Ofek.wav');
s2 = audioread('Files/Results/OfekMika/Mika.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
%% EM algorithm
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D); %Generate environement
% [h,p,Rv,X] = Initialization2(Z,T,K,J,D);
NFFT=512;R=NFFT/2;
duet_speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
duet_speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
Iterations = 20; 
for i = 1:Iterations
    [u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X);
    [p,Rv,h,X] = Maximization(Z,T,K,J,D,u,w);
    [h,X] = gain_ambguity(T,K,D,h,X);
end
%% Plots and sound
T = (0:size(X,2))/fs*R;
F = (0:NFFT/2)*fs/2/(NFFT/2);
figure(12)
subplot(2,1,1)
imagesc(T,F,20*log10(abs(X(:,:,1))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
subplot(2,1,2)
imagesc(T,F,20*log10(abs(X(:,:,2))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
soundsc(s(:,1),fs);
pause(8);
soundsc(speaker1,fs);
pause(8);
soundsc(speaker2,fs);
%% BSS eval
x1 = x1(1:length(speaker1),1); x2 = x2(1:length(speaker2),1);
x11=x1./std(x1); 
x22=x2./std(x2);
x11_est_EM=speaker1./std(speaker1);
x22_est_EM=speaker2./std(speaker2);
x11_est_duet=duet_speaker1./std(duet_speaker1);
x22_est_duet=duet_speaker2./std(duet_speaker2);
MSE1_duet=mean((x11_est_duet-x11).^2);
MSE2_duet=mean((x22_est_duet-x22).^2);
MSE1_EM=mean((x11_est_EM-x11).^2);
MSE2_EM=mean((x22_est_EM-x22).^2);
estimated_EM_matrix = [speaker1 speaker2].';
estimated_duet_matrix = [duet_speaker1 duet_speaker2].';
matrix = [x1 x2].';
[SDR_EM,SIR_EM,SAR_EM,perm_EM] = bss_eval_sources(estimated_EM_matrix,matrix);
[SDR_duet,SIR_duet,SAR_duet,perm_duet] = bss_eval_sources(estimated_duet_matrix,matrix);