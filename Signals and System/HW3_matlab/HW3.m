% MATLAB HW3
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Gwanghyun Kim @ ICL, Seoul National University
% snu.icl.ta@snu.ac.kr

%% Introduction

% In this assignment, you will implement a Discrete Time Fourier Transfrom
% (DTFT). However, Fourier representation of the discrete time signal is in
% the continuous domain. To implement DTFT in MATLAB, we will divide the
% continuous frequency domain into a series of intervals.
% Now, you will do the 5 steps below.
% 1. Load a discrete-time signal (=signal)
% 2. Compute the Fourier transform of the signal (=freq) 
% - divide the frequency range from -2 to 2 into equally distributed 300 points.
% 3. Plot the signal and freq 
% 4. Create new signal by multiplying -1 to every even component (=signal2)
% 5. Repeat Step 2~3 steps with "signal2"
% 6. Repeat Step 2~5 steps with 30 and 3000 points (Step 2) and generate plots respectively.

%% 1. Load a discrete-time signal (=signal)
% The signal exists from n=-15 to 15 where n is an integer.
% Variable 'n' represents the x-axis index of the signal.
clearvars;
load('signal.mat');

% stem(n,signal) %% plotting signal.

%% 2. Compute the Fourier transform of the signal (=freq)
%%%%%% Implement Fourier transform of discrete-time signal %%%%%%
% You will compute the Fourier transform of the signal in only discrete
% points. Please note that this is a numerical approximation of the DTFT.
% First, you divide the frequency range from -2 to 2 into equally
% distributed 30/300/3000 points (using "linspace" function of MATLAB).
% Next, compute the frequency representation on 30/300/3000 points. (See Textbook
% Chapter 5)
% Finally, you will get an approximated Fourier representation of the
% signal, which is a 30/300/3000-length vector.
% In this assignment, we recommend you use matrix multiplication, instead
% of for loop.

%%%%%%%%% implement Here! %%%%%%%%%
num=300;
freq_x=linspace(-2, 2, num);
freq=signal*exp(-1i*2*pi*n'*freq_x);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 3. Plot the signal and freq 
% plotting the discrete-time signal and the magnitude of the Fourier
% transform of the signal.
figure;
subplot(2,1,1);
stem(n, signal)
ylim([-1,1]);
title('discrete-time signal');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal - n=', num2str(num)]);

%% 4. Create new signal by multiplying -1 to every even component (=signal2)
% Create a new signal (=signal2) as follows
% signal2 = signal in odd n
% signal2 = -signal in even n
clearvars;
load('signal.mat');

%%%%%%%%% implement Here! %%%%%%%%%
signal2 = signal;
signal2(2:2:end) = -signal2(2:2:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 5. Repeat Step 2~3 step with "signal2".

%%%%%%%%% implement Here! %%%%%%%%% (Step 2.)
num=300;
freq_x=linspace(-2, 2, num);
freq=signal2*exp(-1i*2*pi*n'*freq_x);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
subplot(2,1,1);
stem(n, signal2)
ylim([-1,1]);
title('discrete-time signal2');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal2 - n=', num2str(num)]);

%% 6. Repeat Step 2~5 steps with 30 and 3000 points (Step 2) and generate plots respectively.
clearvars;
load('signal.mat');
num=30;
freq_x=linspace(-2, 2, num);
freq=signal*exp(-1i*2*pi*n'*freq_x);
figure;
subplot(2,1,1);
stem(n, signal)
ylim([-1,1]);
title('discrete-time signal');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal - n=', num2str(num)]);

clearvars;
load('signal.mat');
signal2 = signal;
signal2(2:2:end) = -signal2(2:2:end);
num=30; 
freq_x=linspace(-2, 2, num);
freq=signal2*exp(-1i*2*pi*n'*freq_x);
figure;
subplot(2,1,1);
stem(n, signal2)
ylim([-1,1]);
title('discrete-time signal2');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal2 - n=', num2str(num)]);


clearvars;
load('signal.mat');
num=3000;
freq_x=linspace(-2, 2, num);
freq=signal*exp(-1i*2*pi*n'*freq_x);
figure;
subplot(2,1,1);
stem(n, signal)
ylim([-1,1]);
title('discrete-time signal');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal - n=', num2str(num)]);

clearvars;
load('signal.mat');
signal2 = signal;
signal2(2:2:end) = -signal2(2:2:end);
num=3000;
freq_x=linspace(-2, 2, num);
freq=signal2*exp(-1i*2*pi*n'*freq_x);
figure;
subplot(2,1,1);
stem(n, signal2)
ylim([-1,1]);
title('discrete-time signal2');
subplot(2,1,2);
plot(linspace(-2,2,num), abs(freq));
title(['Fourier transfrom of signal2 - n=', num2str(num)]);