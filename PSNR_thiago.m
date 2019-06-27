function value = PSNR_thiago(iimg,qimg)

%iimg = imread(filename1);
%qimg = imread(filename2);

value = 10*log10((2^8 -1)^2/MSE(iimg,qimg));

end