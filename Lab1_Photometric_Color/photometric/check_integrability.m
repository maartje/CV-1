function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
[h, w, ~] = size(normals);
p = zeros(h, w, 1);
q = zeros(h, w, 1);
SE = zeros(h, w, 1);

% p = zeros(size(normals));
% q = zeros(size(normals));
% SE = zeros(size(normals));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy

p = normals(:, :, 1) ./ normals(:, :, 3); 
q = normals(:, :, 2) ./ normals(:, :, 3); 


% ========================================================================



p(isnan(p)) = 0;
q(isnan(q)) = 0;



% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE

ddxdy = diff(p,1,2);
ddxdy(:, end+1, :) = ddxdy(:, end, :); % fix dim, add derivative for right edge
ddydx = diff(q,1,1);
ddydx(end + 1, :, :) = ddydx(end, :, :); % fix dim, add derivative for bottom edge

SE = (ddxdy - ddydx).^2;

% ========================================================================




end

