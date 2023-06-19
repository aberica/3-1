function result_im = conv_2d_filter(original_im, filter)

% Implmentation of 2D convolution using 2D filter
%
% Inputs
% origianl_im: image before convolution
% filter: 2D symmetric filter with size of (odd number x odd number)
% (e.g., Gaussian filter of size 3x3, 5x5, 7x7...)
%
% Outputs
% result_im: image after convolution
%
% Note: the image size doesn't change after convolution
% you have to use zero padding
% reference: https://www.divilabs.com/2014/12/padding-borders-of-image-with-zeros-or.html
%
% Note: the convoltuion must works even the filter size is changed
% and the origianl image size is changed

%%%%%%%%% implement 2D convolution using 4 nested for loops %%%%%%%%%%%%%%%
[row_im, col_im] = size(original_im);
[row_fil, col_fil] = size(filter);

% zero-pad the original signal
original_im_pad = zeros(row_im+row_fil-1, col_im+col_fil-1);
original_im_pad((row_fil-1)/2+1:(row_fil-1)/2+row_im, (col_fil-1)/2+1:(col_fil-1)/2+col_im) = original_im;

% result_im size alloc
result_im = zeros(row_im, col_im);

% get convolution by 4 for-loops
for i = 1:row_im   
    for j = 1:col_im
        sum = 0;
        for m = 1:row_fil
            for n = 1:col_fil
                sum = sum + original_im_pad(i+m-1, j+n-1)*filter(m, n);
            end
        end
        result_im(i, j) = sum;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

