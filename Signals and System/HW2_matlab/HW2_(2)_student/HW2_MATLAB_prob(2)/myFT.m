function freq = myFT(img)
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Dongju Mun @ ICL, Seoul National University
% dongju1126@snu.ac.kr

    
    freq = fftshift(fftshift(fft2(img),1),2);
    
end