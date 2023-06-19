% MATLAB HW4
% Signals and Systems, Spring, 2023
%
% Original source : LIST, Seoul National University
% http://list.snu.ac.kr
% 
% Editor & Assignment Evaluator : Jiha Jang @ ICL, Seoul National University
% snu.icl.ta@snu.ac.kr

%% Introduction
% In this assignment, you will implement
% (1) System that shifts an input image by 100 pixels in column direction
% (2) Ideal low-pass, high-pass filter in frequency domain and apply them
% to input images

% You will do this by
% 1. Load an image
% 2. Get the frequency domain representation of the image, i.e. the Fourier transform of the image 
% 3. Implement (1)~(2) and apply them to your input image
%   (1) Shifting system
%   (2) Ideal Low pass filter, High pass filter
% 4. Get the inverse Fourier transform of 3. (=img_output)
% 5. Compare img and img_output_op1,img_output_op2_LPF, img_output_op2_HPF

%% 1. Load an image
clc; clear all; close all;
clearvars;

load('cameraman.mat');          % Load the sample image.
img = double(cameraman);        % Cast to double type.
img = padarray(img,[20 40]);    % Pad the sample image with 0.
%% 2. Get the frequency domain representation of the image, i.e. the Fourier transform of the image

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% Note that the zero frequency component is not centered if you just use "fft2" only.
% The frequency spectrum can be shifted by using "fftshift", to center the zero frequency component.

freq = fftshift(fft2(img));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 3-(1) Operation 1 : shifting system

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% Requirements
%
% The shifting system should be represented as a complex exponential
% function in the frequency domain. Multiply 2. and a complex exponetial function

% 
% Hints
%
% If the image column length is L, the discrete frequency in the column
% direction can be represented as a vector, fx = [0, 1/L, 2/L, ... ,
% (L-1)/L]. Furthermore, the frequency should be zero-centered, in
% accordance with the zero-centered frequency representation of the image
% matrix (final output of step2). Therefore, you should use fftshift in order to
% zero-center the frequency vector, "fx".

% Gererate fx, the frequncy vector
shift_amount = 100;
[L, ~] = size(img);
fx = 0:1/L:1-1/L;
fx=fx-0.5;

% Get img_output_op1_freq by multiplying freq and shift_function by elementwise
shift_function = exp(-1i * 2 * pi * fx.' * shift_amount);
img_output_op1_freq = freq .* shift_function;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% 3-(2) operation 2
% Implement ideal low-pass and ideal high-pass filter then apply them to
% the input image
%%%%%%%%%%%% To do %%%%%%%%%%%%%%%

% Define the cutoff frequency
cutoff_freq = 0.03;

% Generate Frequency vectors
[L, M] = size(freq);  % L: row size, M: column size
fx = 0:1/L:1-1/L;  % row
fy = 0:1/M:1-1/M;  % column

fx=fx-0.5;
fy=fy-0.5;

[Fx, Fy] = meshgrid(fy, fx);

% Generate distance array from centor
D = sqrt(Fx.^2 + Fy.^2);
LPF = double(D <= cutoff_freq); % if the distance is less tan cutoff_freq, LPF<-1, else 0.
HPF = 1 - LPF;

% Low-pass filter
img_output_op2_LPF_freq = freq .* LPF;

% High-pass filter
img_output_op2_HPF_freq = freq .* HPF;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 4. Get the inverse Fourier transform of the 3.

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% Note that the zero frequency component should be moved to the first position of the frequency matrix.
% The frequency spectrum can be shifted by using "ifftshift", to move the zero frequency component.

img_output_op1 = ifft2(ifftshift(img_output_op1_freq));
img_output_op2_LPF = ifft2(ifftshift(img_output_op2_LPF_freq));
img_output_op2_HPF = ifft2(ifftshift(img_output_op2_HPF_freq));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 5. Compare img and img_output

figure;
subplot(1,2,1);
imshow(img,[0 255]);
title('Input image');
subplot(1,2,2);
imshow(real(img_output_op1),[0 255]);
title('Output image');

figure;
subplot(1,2,1);
imshow(img,[0 255]);
title('Input image');
subplot(1,2,2);
imshow(real(img_output_op2_LPF),[0 255]);
title('Output image');

figure;
subplot(1,2,1);
imshow(img,[0 255]);
title('Input image');
subplot(1,2,2);
imshow(real(img_output_op2_HPF),[0 255]);
title('Output image');