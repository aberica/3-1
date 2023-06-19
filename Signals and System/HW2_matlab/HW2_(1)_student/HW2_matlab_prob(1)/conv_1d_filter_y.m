function result_im = conv_1d_filter_y(original_im, filter)

% Implementation of 2D convolution with 1D filter
% !!!! without any for loops !!!!
% you may be better to refer the code in Example section
%
% Inputs
% original_im: 2D input image
% filter: 1D filter size = (1,N)
%
% Outputs
% result_im: 2D output image after convolution
%
% Note: the image size doesn't change after convolution
% you have to use zero padding
% reference: https://www.divilabs.com/2014/12/padding-borders-of-image-with-zeros-or.html
%
% Note: the convoltuion must works even the filter size is changed
% and the origianl image size is changed

%%%%%%% implement 2D convoultion using 1D filter without any for loops %%%%

% rot 90d egress
original_im_rot = rot90(original_im, 1);
filter_rot = rot90(filter, 1);

% function reuse
result_im_rot = conv_1d_filter_x(original_im_rot, filter_rot);

% rot 90 degress
result_im = rot90(result_im_rot, -1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

