function freq_2 = cropBoundary(freq)
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Dongju Mun @ ICL, Seoul National University
% dongju1126@snu.ac.kr

% Implement the boundary cropping code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row_freq, col_freq] = size(freq);

% get center idx
row_start = floor(row_freq/4)+1;
row_end = floor(row_freq/4*3);
col_start = floor(col_freq/4)+1;
col_end = floor(col_freq/4*3);

% make center 0
freq_2 = freq;
freq_2(row_start:row_end, col_start:col_end) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end