function plot_h_in_time(h1,h2,h1_ori,h2_ori)
h1 = h1(:,:); h2 = h2(:,:);
K = length(h1(1,:));
h1_f=[h1 conj(fliplr(h1(:,2:K-1)))];
h2_f=[h2 conj(fliplr(h2(:,2:K-1)))];
% h1_time=h1_time;h2_time=h2_time;
h1_t=ifft(h1_f);h2_t=ifft(h2_f);
h1_time=ifftshift(h1_t);h2_time=ifftshift(h2_t);
figure(9);
subplot(4,1,1);plot(1:length(h1_ori),h1_ori);title('h1');subplot(4,1,2);plot(1:length(h1_time),h1_time); 
subplot(4,1,3);plot(1:length(h2_ori),h2_ori);title('h2');subplot(4,1,4);plot(1:length(h2_time),h2_time);
end

