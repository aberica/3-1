function freq_1 = cropCenter(freq)
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Dongju Mun @ ICL, Seoul National University
% dongju1126@snu.ac.kr

%implemnet the center copping code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row_freq, col_freq] = size(freq);

% get center idx
row_start = floor(row_freq/4)+1;
row_end = floor(row_freq/4*3);
col_start = floor(col_freq/4)+1;
col_end = floor(col_freq/4*3);

% remain only center
freq_1 = zeros(row_freq, col_freq);
freq_1(row_start:row_end, col_start:col_end) = freq(row_start:row_end, col_start:col_end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end