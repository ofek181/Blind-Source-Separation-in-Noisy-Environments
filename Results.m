%% Generate
clear 
close all
t60 = '610';
[s1,fs] = audioread('Files/mtp/male/1/46BA010A.wav');
s2 = audioread('Files/mtp/female/2/46CA010C.wav');
[s,v,h1,h2,x1,x2] = Generate(s1,s2,t60,0,50);
[Z,T,K,J,D] = Get_Input(s);
%% Get results from the EM algorithm
[h,p,Rv,X] = Initialization(Z,s,T,K,J,D);
NFFT=512;R=NFFT/2;
duet_speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
duet_speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
x1 = x1(1:length(duet_speaker1),1); x2 = x2(1:length(duet_speaker2),1);
matrix = [x1 x2].';
estimated_duet_matrix = [duet_speaker1 duet_speaker2].';
[SDR_duet,SIR_duet,SAR_duet,perm_duet] = bss_eval_sources(estimated_duet_matrix,matrix);
duet_avg_SDR = (SDR_duet(1)+SDR_duet(2))/2; 
duet_avg_SIR = (SIR_duet(1)+SIR_duet(2))/2; 
duet_avg_SAR = (SAR_duet(1)+SAR_duet(2))/2; 
Iterations = 20; 
results_SIR = zeros(Iterations,3);
results_SDR = zeros(Iterations,3);
results_SAR = zeros(Iterations,3);
results_MSE = zeros(Iterations,3);
for i = 1:Iterations
    [u,w] = Estimation(Z,T,K,J,D,h,p,Rv,X);
    [p,Rv,h,X] = Maximization(Z,T,K,J,D,u,w);
    [h,X] = gain_ambguity(T,K,D,h,X);
    speaker1 = istft(X(:,:,1),NFFT,0.5*NFFT,1,'Hamming');
    speaker2 = istft(X(:,:,2),NFFT,0.5*NFFT,1,'Hamming');
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
    [SDR_EM,SIR_EM,SAR_EM,perm_EM] = bss_eval_sources(estimated_EM_matrix,matrix);
    results_SIR(i,1:2) = SIR_EM; results_SIR(i,3) = (results_SIR(i,1)+results_SIR(i,2))/2;
    results_SDR(i,1:2) = SDR_EM; results_SDR(i,3) = (results_SDR(i,1)+results_SDR(i,2))/2;
    results_SAR(i,1:2) = SAR_EM; results_SAR(i,3) = (results_SAR(i,1)+results_SAR(i,2))/2;
    results_MSE(i,1) = MSE1_EM; results_MSE(i,2) = MSE2_EM;
    results_MSE(i,3) = (results_MSE(i,1)+results_MSE(i,2))/2;
end
duet_avg_MSE = (MSE1_duet+MSE2_duet)/2;
%% Graphs
T = (0:size(X,2))/fs*R;
F = (0:NFFT/2)*fs/2/(NFFT/2);
figure(1)
imagesc(T,F,20*log10(abs(X(:,:,1))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('STFT of the 1st speaker');
figure(2)
imagesc(T,F,20*log10(abs(X(:,:,2))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('STFT of the 2nd speaker');
x_axis = linspace(1,Iterations,Iterations)';
y_axis_MSE = results_MSE(:,3);
figure(3)
plot(x_axis,y_axis_MSE,'-o')
xlabel('Iterations of the EM algorithm');
ylabel('Average MSE of the speakers');
title('Average MSE vs iterations');
hold on
yline(duet_avg_MSE,'-r','duet');
hold off
y_axis_SAR = results_SAR(:,3);
figure(4)
plot(x_axis,y_axis_SAR,'-o')
xlabel('Iterations of the EM algorithm');
ylabel('Average SAR of the speakers');
title('Average SAR vs iterations');
hold on
yline(duet_avg_SAR,'-r','duet');
hold off
y_axis_SDR = results_SDR(:,3);
figure(5)
plot(x_axis,y_axis_SDR,'-o')
xlabel('Iterations of the EM algorithm');
ylabel('Average SDR of the speakers');
title('Average SDR vs iterations');
hold on
yline(duet_avg_SDR,'-r','duet');
hold off
y_axis_SIR = results_SIR(:,3);
figure(6)
plot(x_axis,y_axis_SIR,'-o')
xlabel('Iterations of the EM algorithm');
ylabel('Average SIR of the speakers');
title('Average SIR vs iterations');
hold on
yline(duet_avg_SIR,'-r','duet');
hold off
figure(7)
imagesc(T,F,20*log10(abs(Z(:,:,1))))
axis xy
xlabel('Time[Sec]','fontsize',14);
ylabel('Frequency[Hz]','fontsize',14);
set(gca,'fontsize',14);
colorbar
title('STFT of the signal');
%% Audio
soundsc(s(:,1),fs);
pause(5);
soundsc(speaker1,fs);
pause(5);
soundsc(speaker2,fs);
%% Write audio files
audiowrite('Signal.wav',s(:,1),fs)
audiowrite('1st_speaker.wav',speaker1,fs)
audiowrite('2nd_speaker.wav',speaker2,fs)
audiowrite('duet1.wav',duet_speaker1,fs)
audiowrite('duet2.wav',duet_speaker2,fs)