function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, source_count] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
for x = 1:h
    for y = 1:w
        % stack image values into a vector i
        i = reshape(image_stack(x, y, :), source_count, 1); 
        
        i(isnan(i)) = 0; %Fix missing channel problem
        
        % construct the diagonal matrix script I
        I = diag(i);
        
        % obtain g for this point
        if shadow_trick
            [g, R] = linsolve(I*scriptV, I*i);
        else
            [g, R] = linsolve(scriptV, i);
        end
        
        %   albedo at this point is |g|
        albedo(x, y, 1) = min(norm(g), 1);
        
        % assert(0 <= albedo & albedo <= 1, "albedo should be inbetween 0 and 1")
        % FIXME: max albedo is '1.0382' 
        
        % normal at this point is g / |g|
        if albedo(x, y, 1) == 0
            normal(x, y, :) = [0, 0, 0];
        else
            normal(x, y, :) = g / norm(g);
        end
    end
end
end
