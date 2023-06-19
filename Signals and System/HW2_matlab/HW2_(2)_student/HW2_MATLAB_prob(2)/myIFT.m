function img = myIFT(freq)
% Signals and Systems, Spring, 2023
%
% Original Source: LIST, Seoul National University
% http://list.snu.ac.kr
% Editor & Assignment Evaluator: Dongju Mun @ ICL, Seoul National University
% dongju1126@snu.ac.kr

% Implement the inverse Fourier transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = ifft2(ifftshift(ifftshift(freq,2),1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end