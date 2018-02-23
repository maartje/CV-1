function G = gauss2D( sigma , kernel_size )
    %% solution
    G1d = gauss1D(sigma, kernel_size);
    G = G1d(:) * G1d;
end
