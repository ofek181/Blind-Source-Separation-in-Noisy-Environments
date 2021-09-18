function [h1,h2] = rir_gen()
c = 340;                    % Sound velocity (m/s)
fs = 16000;                 % Sample frequency (samples/s)
r1 = [2.85,0,1];
r2 = [2.88,0,1];
r3 = [2.91,0,1];
r4 = [2.94,0,1];
r5 = [3.02,0,1];
r6 = [3.05,0,1];
r7 = [3.08,0,1];
r8 = [3.11,0,1];
r = [r1;r2;r3;r4;r5;r6;r7;r8];    % Receiver positions [x y z] (m)
s1 = [3-cos(pi/6) sin(pi/6) 1.7]; % Source position [x y z] (m)
s2 = [3+cos(pi/6) sin(pi/6) 1.7]; % Source position [x y z] (m)
L = [6 6 2.4];              % Room dimensions [x y z] (m)
beta = 0;                   % Reverberation time (s)
n = 200;                    % Number of samples
mtype = 'omnidirectional';  % Type of microphone
order = 0;                  % 0 equals no reflection 
dim = 3;                    % Room dimension
orientation = 0;            % Microphone orientation (rad)
hp_filter = 1;              % Enable high-pass filter
h1 = rir_generator(c, fs, r, s1, L, beta, n, mtype, order, dim, orientation, hp_filter);
h2 = rir_generator(c, fs, r, s2, L, beta, n, mtype, order, dim, orientation, hp_filter);
end

