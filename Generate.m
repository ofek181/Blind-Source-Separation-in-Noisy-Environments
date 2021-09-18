function [signal,new_noise,h1,h2,x1,x2] = Generate(s1,s2,t60,mxe,SNR)
%%
fs=16000;
noise = importdata('Files/noise/1m_270_ventilator.mat');   %importing noise
Files = 'Files/';
folder1 = '/1m_030.mat';
folder2 = '/1m_270.mat';
path1 = strcat(Files , t60 , folder1);                     %location of file
path2 = strcat(Files , t60 , folder2);                     %location of file
sys1 = importdata(path1);
sys2 = importdata(path2);
h1 = sys1.impulse_response(1:fs,:);                        %taking 1:fs of system
h2 = sys2.impulse_response(1:fs,:);                        %no need for more than fs samples
min_len = min(length(s1)+fs-1,length(s2)+fs-1);            %minimum length of future convulotion
sig_no_noise = zeros(min_len,8);                           %preallocating
x1 = zeros(length(s1)+fs-1,8);                             %preallocating
x2 = zeros(length(s2)+fs-1,8);                             %preallocating
for i = 1:8
x1(:,i) = conv(s1,h1(:,i));                                %x1=s1*h1
x2(:,i) = conv(s2,h2(:,i));                                %x2=s2*h2
x2_mxe = delayseq(x2,mxe,fs);                              %delay using mxe
sig_no_noise(:,i) = x1(1:min_len,i) + x2_mxe(1:min_len,i); %signal without noise
end
noise = noise.recording(1:min_len,:);                      %noise becomes same size as signal
new_noise = my_SNR(sig_no_noise,noise,SNR);                %calculating the SNR based noise
signal = sig_no_noise + new_noise;                         %adding noise based on specified SNR
%%
% fs=16000;
% noise = importdata('Files/noise/1m_270_ventilator.mat');   %importing noise
% [h1,h2] = rir_gen();
% min_len = min(length(s1)+200-1,length(s2)+200-1);            %minimum length of future convulotion
% sig_no_noise = zeros(min_len,8);                            %preallocating
% x1 = zeros(length(s1)+200-1,8);                             %preallocating
% x2 = zeros(length(s2)+200-1,8);                             %preallocating
% for i = 1:8
% x1(:,i) = conv(s1,h1(i,:)');                                %x1=s1*h1
% x2(:,i) = conv(s2,h2(i,:)');                                %x2=s2*h2
% x2_mxe = delayseq(x2,mxe,fs);                               %delay using mxe
% sig_no_noise(:,i) = x1(1:min_len,i) + x2_mxe(1:min_len,i); %signal without noise
% end
% noise = noise.recording(1:min_len,:);                      %noise becomes same size as signal
% new_noise = my_SNR(sig_no_noise,noise,SNR);                %calculating the SNR based noise
% signal = sig_no_noise + new_noise;                         %adding noise based on specified SNR
end