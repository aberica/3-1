% MATLAB HW2_2
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Dongju Mun @ ICL, Seoul National University
% dongju1126@snu.ac.kr
%
% In this assignment, you will
% 1. Load an image (=img)
% 2. Get the frequency domain representation of the image, i.e. the Fourier transform of the image (=freq)
% 3. Crop the center portion of the frequency domain (=freq_1)
% 4. Crop the boundary portion of the frequency domain (=freq_2)
% 5. Get the inverse Fourier transform of the cropped frequency (=img_approx_1 & img_approx_2)
% 6. Compare img, img_approx_1 and img_approx_2

%% 1. Load an image (=img)
clc; clear all;
clearvars;

load('cameraman.mat'); % Load the sample image.
img = double(cameraman); % Cast to double type.

%% 2. Get the frequency domain representation of the image, i.e. the Fourier transform of the image (=freq)

%%%%%%%% Implement myFT.m %%%%%%%%
% Hints
% Use fft2 and fftshift.
% Note that the zero frequency component is not centered if you just use "fft2" only.
% The frequency spectrum can be shifted by using "fftshift", to center the zero frequency component.

% The myFT function is already implemented and provided with this file.
% You can either implement myFT.m yourself or just use provided file.
% However, you are required to implement myIFT.m yourself.
% It'll be helpful to find a implementation of a function

freq = myFT(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Crop the center portion of the frequency domain (=freq_1) 

%%%%%%%% Implement cropCenter.m %%%%%%%%
% Requirements
% 
% The function cropCenter should preserve the center part (32X32) of the input
% matrix and make remaining part to be zero. The size of the output matrix
% should be the same size of the input matrix.
%
% e.g. ones(8,8) "cropCenter" with the center portion (4X4) will become
%
% 0 0 0 0 0 0 0 0
% 0 0 0 0 0 0 0 0
% 0 0 1 1 1 1 0 0
% 0 0 1 1 1 1 0 0
% 0 0 1 1 1 1 0 0
% 0 0 1 1 1 1 0 0
% 0 0 0 0 0 0 0 0
% 0 0 0 0 0 0 0 0
%

freq_1 = cropCenter(freq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 4. Crop the boundary portion of the frequency domain (=freq_2)

%%%%%%%% Implement cropBoundary.m %%%%%%%%
% Requirements
% 
% The function cropBoundary should make the center part (32X32) of the input
% matrix to be zero and preserve the remaining part. The size of the output matrix
% should be the same size of the input matrix.
%
% e.g. ones(8,8) "cropBoundary" with the center portion (4X4) will become
%
% 1 1 1 1 1 1 1 1
% 1 1 1 1 1 1 1 1
% 1 1 0 0 0 0 1 1
% 1 1 0 0 0 0 1 1
% 1 1 0 0 0 0 1 1
% 1 1 0 0 0 0 1 1
% 1 1 1 1 1 1 1 1
% 1 1 1 1 1 1 1 1
%

freq_2 = cropBoundary(freq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 5. Get the inverse Fourier transform of the cropped frequency (=img_approx_1 & img_approx_2)

%%%%%%%% Implement myIFTm.m %%%%%%%%
% Hints
% Use ifft2 and ifftshift.
% Note that the zero frequency component should be moved to the first position of the frequency matrix.
% The frequency spectrum can be shifted by using "ifftshift", to move the zero frequency component.

img_approx_1 = myIFT(freq_1);
img_approx_2 = myIFT(freq_2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 6. Compare img, img_approx_1 and img_approx_2

figure;
subplot(2,3,1);
imshow(img,[0 255]);
subplot(2,3,2);
imshow(real(img_approx_1),[0 255]);
subplot(2,3,3);
imshow(real(img_approx_2),[0 255]);
subplot(2,3,4);
imshow(abs(freq),[0 50000]);
subplot(2,3,5);
imshow(abs(freq_1),[0 50000]);
subplot(2,3,6);
imshow(abs(freq_2),[0 50000]);
