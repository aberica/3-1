function reconstructed_image = reconstruct(y)
    reconstructed_image = abs(ifft2(y));
end
