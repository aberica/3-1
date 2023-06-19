function psnr_value=psnr(img1,img2)
    mse=mean((img1-img2).^2,'all');
    if mse==0
        psnr_value=Inf;
    else
        psnr_value=20*log10(255/sqrt(mse));
    end
end
    
