% MATLAB HW6
% Signals and Systems, Spring, 2023
%
% Original source : ICL, Seoul National University
% 
% Editor & Assignment Evaluator : HaeChang Lee @ ICL, Seoul National University
% snu.icl.ta@snu.ac.kr

%% Introduction
% You will explore and understand the various techniques and strategies
% employed for undersampling in the frequency domain.

% The objective of this assignment is to undersample 160x160 human face
% images in the frequency domain by a factor of 4 while maximizing the peak
% signal-to-noise-ratio (PSNR).

% For training purposes, you will be provided with a set of 10 images, and
% for validation, one image will be given. Please note that test images
% will not be made available.

% Using the provided training and validation images, your task is to submit
% a 160x160 undrsampling mask. 
% 
% The mask should be a binary 2D matrix of size 160x160, with exactly one-fourth(1/4) of the entries being 1, and
% the remaining three-fourths(3/4) being 0.

clc; clear all; close all;
clearvars;

%% 1. Load images into array

% Load 10 images of train dataset in 'image_train' using
% 'load_images_to_array' function.

path_train='dataset/train/';
image_train=load_images_to_array(path_train, 160);

% visualize the sample image
figure;
sample_img=squeeze(image_train(10,:,:));
imshow(sample_img,'DisplayRange',[0, 255]);

%% 2. 1/4 Undersample reconstruction of the validation (you) and test data(TA)

path_val='dataset/val/';
image_val=load_images_to_array(path_val,160);

% Move the image to frequency domain
kspace_val=fftshift(fft2(squeeze(image_val)));
figure;
imshow(20*log(abs(kspace_val)),[0,255]);

%% 3. Optimize the mask 

% The mask below is an example provided by the TA.
% You should optimize your own mask, but the mask should strictly meet
% requirements below.

% Requirements :
% The mask should be a binary 2D matrix of size 160x160, with exactly one-fourth(1/4) of the entries being 1, and
% the remaining three-fourths(3/4) being 0.

% In optimization process, it is highly recommended that you try sample and
% reconstruct images in train dataset with various types of mask multiple
% times

% TA will use the test images that demonstrate similar patterns to the
% training images

% The higher the PSNR value, the higher the score for your assignment!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define mask
mask = zeros(160, 160);
M = 6400;

% The center of the image will contain low-frequency components, thus we sample more from the center
mid = 160 / 2;
radius = sqrt(M / pi);

% Construct mask that keeps low-frequency components and discards high-frequency components
num = 0;
for i = 1:160
    for j = 1:160
        if ((i - mid)^2 + (j - mid)^2 <= radius^2 + 4 && num < M)
            mask(i, j) = 1;
            num = num + 1;
        end
    end
end

disp("sum : "+ sum(mask, 'all')+", and it should be "+M);

figure;
imshow(mask,'Colormap',gray);
assert(sum(mask,'all')==M);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 4. Reconstruct images with sampled frequency
sampled_freq=kspace_val.*mask;
recon_val=reconstruct(sampled_freq);

figure;
display(psnr(squeeze(image_val),recon_val));
imshow(recon_val,[]);


%% FUNCTION
function [m_mask, rnd_index] = make_Mask(m_weight, m_M, m_changing_rate, m_type) 
    % Flatten
    flattened_weight = m_weight(:);
    
    % Sort in descending order and get indices
    [~, sorted_indices] = sort(flattened_weight, 'descend');

    if (m_type == 1)
        det_index = sorted_indices(1:m_M*(1-m_changing_rate));
        rnd_index = sorted_indices(m_M*(1-m_changing_rate)+1:m_M);
    end
    if (m_type == 2)
        det_index = sorted_indices(randperm(m_M, m_M*(1-m_changing_rate)));
        rnd_index = sorted_indices(randperm(size(flattened_weight, 1)-m_M, m_M*m_changing_rate)+m_M);
    end 

    flattened_mask = zeros(size(flattened_weight));
    flattened_mask(det_index) = 1;
    flattened_mask(rnd_index) = 1;

    m_mask = reshape(flattened_mask, size(m_weight));
end