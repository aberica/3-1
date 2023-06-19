% MATLAB HW5
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr 
% Editor & Assignment Evaluator: Wongi Jeong @ ICL, Seoul National University
% snu.icl.ta@snu.ac.kr

%% Introduction
% In this assignment, you will implement sampling and interpolation using MATLAB. Follow the steps below.

%  1. (a) Determine the undersampling frequency (Fs_under)
%     (b) Describe the results of undersampled sound and suggest the reason why Mr. Kim's idea failed
%     (c) Suggest a way to remove the noise in the frequency domain
%     (d) Complete the missing lines below and plot the resulting frequency
%     spectrum. Then compare the music with those from part 1 and part 2 and discuss the results

%  2. (a) Implement zero order hold interpolator and display the frequency spectrum
%     (b) Implement linear interpolator and display the frequency spectrum
%     (c) Implement the sinc interpolator with a sinc function width of seven (i.e. use only 7 non-zero
%         points for interpolation) and display the frequency spectrum)
%     (d) Discuss the difference in the resulting sounds

%% Part 1. Frequency Spectrum

% Before you start, play the audio file using a music player like 'windows media player'.
clear all; close all; clc;

% In this example, you will examine a music sound
[audio_data Fs] = audioread('Audio.wav'); % This function read audio data 
                                          % Fs: sampling rate (# of samples/ 1sec) 

                                                 
 audio_out = audioplayer(audio_data, Fs, 16); % 16 means 16-bit quantization
 play(audio_out) % if the music sounds differently (i.e. if you hear noise) from the music played in the windows media player, 
                 % we recommed you to use another computer (this noise issue seems to be related with sound card problems in a few computers).
                 % BTW, this noise issue may not be critical for the last of the
                 % problems and it is ok stay with the current computer if you cannot find an alternative one.

% time domain plot
t = [1:400]/Fs; % scaling for real time 
figure(1)
plot(t,audio_data(1:400),'b')  % plot the music sound
xlabel('time (sec)') 



% Display frequency spectrum of the original sound 
figure(2)
ft = abs(fftshift(fft(audio_data))); % Fourier transform of the sound
freq = -Fs/2:Fs/length(audio_data):(Fs/2-Fs/length(audio_data)); % frequency domain scaling
plot(freq,ft) % plot frequency spectrum
grid on
title('Frequency spectrum')
xlabel('Frequency (Hz)')


%% Part 2. Undersampling data

% The music data is sampled at 88.2 kHz. However, the frequency range that we can hear is from 16 Hz to 20 kHz.
% Mr. Kim, who is an undergraduate student at SNU ECE, postulates that sampling the sound at 44.1 kHz is enough. 
% So he decided to undersample the data to reduce disk space.


audio_data_under = audio_data(1:2:end); % factor of 2 undersampling (i.e. sampling rate = 44.1 kHz)

% Problem 1-(a) fill in this line.
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
Fs_under = Fs/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
audio_out = audioplayer(audio_data_under, Fs_under, 16);
play(audio_out)




% Display frequency spectrum of the undersampled sound 
figure(3)
ft = abs(fftshift(fft(audio_data_under))); % Fourier transform of the sound
freq = -Fs_under/2:Fs_under/length(audio_data_under):(Fs_under/2-Fs_under/length(audio_data_under)); % frequency domain scaling
plot(freq,ft) % plot frequency spectrum
grid on
title('Frequency spectrum')
xlabel('Frequency (Hz)')

% Problem 1-(b) Describe the results of undersampled sound and suggest the reason why Mr. Kim's idea failed.  
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% 안티 엘리어싱을 하지 않아, 고주파신호가 미러링이되어 앨리어싱을 발생시켰기 때문이다.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part 3. An improved approach for undersampling

% Mr. Kim still wants to undersample the data at 44.1 kHz. 
% He knows the signal above the 22.1 kHz is noise. 
% Problem 1-(c) Suggest a way to remove the noise in the frequency domain
%               :LPF를 적용시켜 노이즈를 제거한다.
% Problem 1-(d) Complete the missing lines below and plot the resulting frequency spectrum. 
%               Compare the music with those from part 1 and part 2 and discuss the results.

clear audio_data_under

ft_audio = fftshift(fft(audio_data)); % This is Fourier Transform of audio_data
                                      % For inverse Fourier Transform of
                                      % x, use 'y=ifft(ifftshift(x))'
                                      
freq = -Fs/2:Fs/length(audio_data):(Fs/2-Fs/length(audio_data)); % frequency domain scaling
figure(4); plot(freq,abs(ft_audio))

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% LPF를 적용시켜 노이즈를 제거한다.
low_pass = (abs(freq)<=Fs_under/2);
ft_audio_filtered = ft_audio .* low_pass';
audio_data_filtered = ifft(ifftshift(ft_audio_filtered));
audio_data_under = audio_data_filtered(1:2:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

audio_out = audioplayer(audio_data_under, Fs_under, 16);
play(audio_out)


figure(5)
ft = abs(fftshift(fft(audio_data_under))); % Fourier transform of the sound
freq = -Fs_under/2:Fs_under/length(audio_data_under):(Fs_under/2-Fs_under/length(audio_data_under)); % frequency domain scaling
plot(freq,ft) % plot frequency spectrum
grid on
title('Corrected Frequency spectrum of Undersampling Data')
xlabel('Frequency (Hz)')

%% Part 4.Interpolation
  
% zero filling the undersampled data
audio_data_zero = zeros(size(audio_data_under));
audio_data_zero(1:2:end) = audio_data_under(1:2:end); 

figure(6)
subplot(1,2,1)
stem(abs(audio_data_under(1:50)),'r')
title('original data')
subplot(1,2,2)
stem(abs(audio_data_zero(1:50)))
title('zero filled data')

audio_out = audioplayer(audio_data_zero, Fs_under, 16);
play(audio_out)
 
figure(7)
ft = abs(fftshift(fft(audio_data_zero))); % Fourier transform of the music sound
freq = -Fs_under/2:Fs_under/length(audio_data_zero):(Fs_under/2-Fs_under/length(audio_data_zero)); % frequency domain scaling
plot(freq,ft) % plot frequency spectrum
grid on
title('Frequency spectrum')
xlabel('Frequency (Hz)')




% Music after the zero filling was disorted, so Mr. Kim decided to restore
% the zeros using interpolation.

% Problem 2-(a) Zero order hold interpolation
% Implement zero order hold interpolator and submit your code.
% Display the frequency spectrum. 
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
zero_filter = ones(2, 1); % Zero order hold kernel
audio_data_ZOH = conv(audio_data_zero, zero_filter, 'same');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Problem 2-(b) Linear interpolation
% Implement linear interpolator and submit your code.
% Display the frequency spectrum.
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
audio_data_lin = audio_data_zero;
audio_data_lin(2:2:end-1) = (audio_data_zero(1:2:end-2) + audio_data_zero(3:2:end))/2;
audio_data_lin(end) = audio_data_lin(end-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Problem 2-(c) Sinc interpolation 
% Implement the sinc interpolation code.
% Implement sinc interpolator with a sinc function width of seven (i.e. use only 7 non-zero points for interpolation) and submit your code.
% Display the frequency spectrum.
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
N = 7;
sinc_filter = sinc((-N:N).');
audio_data_sinc = conv(audio_data_under, sinc_filter, 'same');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Problem 2-(d) Discuss the difference in the resulting sounds.
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% zero hold, linear, sinc 순서대로 음질이 안좋-> 좋아진다. 
% 역순으로 비용이 많이 든다. sinc가 가장 많이, zoro hold가 가장 적게 든다.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% You can use the following code to plot the results
figure(8)

subplot(5,1,1)
plot(abs(audio_data_under(1:200)),'b')
title('original data')

subplot(5,1,2)
stem(abs(audio_data_zero(1:200)),'k')
title('zero filled data')

subplot(5,1,3)
stem(abs(audio_data_ZOH(1:200)),'m')
title('zero order hold interpolation data')

subplot(5,1,4)
plot(abs(audio_data_lin(1:200)),'g')
hold on
stem(abs(audio_data_zero(1:200)),'k')
title('linear interpoaltion data')

subplot(5,1,5)
plot(abs(audio_data_sinc(1:200)),'r')
hold on
stem(abs(audio_data_zero(1:200)),'k')
title('sinc interpolation data')



