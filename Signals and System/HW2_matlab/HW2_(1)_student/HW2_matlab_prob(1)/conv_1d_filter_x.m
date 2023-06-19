function result_im = conv_1d_filter_x(original_im, filter)

% Implementation of 2D convolution with 1D filter
% !!!! without any for loops !!!!
% you may be better to refer the code in Example section
%
% Inputs
% original_im: 2D input image
% filter: 1D filter size = (N,1)
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
[row_im, col_im] = size(original_im);

% zero-pad the original signal
original_im_pad = zeros(row_im+size(filter,1)-1, col_im);
original_im_pad((size(filter,1)-1)/2+1:(size(filter,1)-1)/2+row_im, :) = original_im;

% flip the convolution filter
filter = filter(end:-1:1);

% make convolution matrix
H_row = [filter', zeros(1,size(original_im_pad,1)-size(filter,1)+1)];
H_rep = repmat(H_row,1,size(original_im_pad,1));
H = reshape(H_rep,size(original_im_pad,1),[]);
H = H(:,1:row_im);

% perform 1D convolution
result_im = (original_im_pad' * H)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

