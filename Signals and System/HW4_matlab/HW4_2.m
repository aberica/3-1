% MATLAB HW4
% Signals and Systems, Spring, 2023
%
% Original source : LIST, Seoul National University
% http://list.snu.ac.kr
% 
% Editor & Assignment Evaluator : Jiha Jang @ ICL, Seoul National University
% snu.icl.ta@snu.ac.kr

%% Introduction
% You will implement a system that denoises the corrupted image by
% applying low pass gaussian filter.
% 
% 1. Load an image
% 2. Add salt & pepper noise to your image
% 3. Get the frequency domain representation of the corrupted image, i.e. the Fourier transform of the image 
% 4. Implement gaussian low pass filter in spatial domain. 
%   - Get the frequency domain represesentation of filter and apply it to 3 using convolution theorem
% 5. Get the inverse Fourier transform of the output frequency 4.
% 6. Compare img and img_output_op3.

%% 1. Load an image and 2. add salt & pepper noise to your image
clc; clear all; close all;
clearvars;

load('cameraman.mat');          % Load the sample image.
img=imnoise(cameraman,'salt & pepper'); % Add salt & pepper noise to your image
img = padarray(img,[20 40]);
imshow(img) % Pad the sample image with 0.

%% 3. Get the frequency domain representation of the image, i.e. the Fourier transform of the image

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% Note that the zero frequency component is not centered if you just use "fft2" only.
% The frequency spectrum can be shifted by using "fftshift", to center the zero frequency component.

freq = fftshift(fft2(img));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 4. Implement gaussian low pass filter in spatial domain. 
% Implement gaussian low pass filter in spatial domain. 
% Then, get frequency domain represesentation of the filter and apply it to 3 using convolution theorem

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%

% Generate the gaussian filter in spatial domain
x = -0.2:0.1:0.2;
y = -0.2:0.1:0.2;
sigma = 1;
h = 1 / (2*pi*sigma^2) * exp(-1*(x.^2+y'.^2) / (2*sigma^2));
h = h / sum(h(:));
h_padded = padarray(h, size(img) - size(h), 'post');

% Get the frequency domain representation of the filter
H = fft2(h_padded);
H = fftshift(H);

% Get img_output by convolute freq and H
img_output_op3_freq = freq .* H;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 5. Get the inverse Fourier transform of the 4.

%%%%%%%%%%%% To do %%%%%%%%%%%%%%%
% Note that the zero frequency component should be moved to the first position of the frequency matrix.
% The frequency spectrum can be shifted by using "ifftshift", to move the zero frequency component.

img_output_op3 = ifft2(ifftshift(img_output_op3_freq));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 6. Compare img and img_output_op3
figure;
subplot(1,2,1);
imshow(img,[0 255]);
title('Input image');
subplot(1,2,2);
imshow(real(img_output_op3),[0 255]);
title('Output image');

