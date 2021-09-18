%% Check script for the entire code
%% Initialization check
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/Results/OfekMika/Ofek.wav');
s2 = audioread('Files/Results/OfekMika/Mika.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50); %%Generate environment
[Z,T,K,J,D] = Get_Input(s); %%Get TF input
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D); %Initialize
figure(9) %plots and sound
plot_h_in_time(h(:,1,:),h(:,2,:),h1,h2);
NFFT=512;R=NFFT/2;
T = (0:size(X,2))/fs*R;
F = (0:NFFT/2)*fs/2/(NFFT/2);
figure(2)
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
%% Estimation check
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/mtp/male/1/46BA010A.wav');
s2 = audioread('Files/mtp/female/1/46AA010A.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D);
[u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X);
%% Maximization check
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/mtp/male/1/46BA010A.wav');
s2 = audioread('Files/mtp/female/1/46AA010A.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D);
[u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X);
[p,Rv,h,X] = Maximization(Z,T,K,J,D,u,w);
%% SNR check
clear 
close all
signal = audioread('Files/mtp/female/2/46CA010B.wav'); 
noise = importdata('Files/noise/1m_270_ventilator.mat');
noise = noise.recording(1:length(signal),1); 
SNR = 10;
new_noise = my_SNR(signal,noise,SNR);
new_signal = signal + new_noise;
sound(new_signal , 16000);
%% STFT check
clear 
close all
[x,fs] = audioread('Files/Record.wav');
x = x(28000:130000,1)
NFFT = 512; R = NFFT/2;
S = stft(x,NFFT,0.5*NFFT,1,'Hamming');
T = (0:size(S,2))/fs*R;
F = (0:NFFT/2)*fs/2/(NFFT/2);
imagesc(T,F,20*log10(abs(S(:,:))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('mixture');
%% iSTFT check
clear 
close all
[x, fs] = audioread('Files/mtp/female/2/46CA010B.wav');
NFFT = 512; R = NFFT/2;
S = stft(x,NFFT,0.5*NFFT,1,'Hamming');
x_hat = istft(S,NFFT,0.5*NFFT,1,'Hamming');
figure()
subplot(2,1,1)
plot(x)
title('original signal')
subplot(2,1,2)
plot(x_hat)
title('iSTFT signal')
% sound(x,fs);
% pause(5);
% sound(x_hat,fs);
%% Generate Check
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/mtp/female/2/46CA010B.wav');
s2 = audioread('Files/mtp/male/1/46BA010B.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
soundsc(s(:,1),fs);
%% BSS eval
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/Results/OfekMika/Ofek.wav');
s2 = audioread('Files/Results/OfekMika/Mika.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D);
NFFT=512; R=NFFT/2;
duet_speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
duet_speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
x1 = x1(1:length(duet_speaker1),1); x2 = x2(1:length(duet_speaker2),1);
x11=x1./std(x1); 
x22=x2./std(x2);
x11_est_duet=duet_speaker1./std(duet_speaker1);
x22_est_duet=duet_speaker2./std(duet_speaker2);
MSE1_duet=mean((x11_est_duet-x11).^2);
MSE2_duet=mean((x22_est_duet-x22).^2);
estimated_duet_matrix = [duet_speaker1 duet_speaker2].';
matrix = [x1 x2].';
[SDR_duet,SIR_duet,SAR_duet,perm_duet] = bss_eval_sources(estimated_duet_matrix,matrix);
%% Old Intialization 
clear 
close all
t60 = '160';
[s1,fs] = audioread('Files/mtp/male/1/46BA010A.wav');
s2 = audioread('Files/mtp/female/1/46AA010A.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
[h,p,Rv,X] = Initialization2(Z,T,K,J,D);
NFFT=512;R=NFFT/2;
speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
soundsc(s(:,1),fs);
pause(5);
soundsc(speaker1,fs);
pause(5);
soundsc(speaker2,fs);