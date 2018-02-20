function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        height_map = construct_surface_column_path(p, q);

       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        
        height_map = construct_surface_row_path(p, q);
        

        % =================================================================
          
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE
        height_map_col = construct_surface_column_path(p, q);        
        height_map_row = construct_surface_row_path(p, q);
        
        height_map = 0.5 * (height_map_col + height_map_row);
        
        % =================================================================
end


end

function [ height_map ] = construct_surface_column_path( p, q )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   height_map: the surface to be reconstructed

[h, w] = size(p);
height_map = zeros(h, w);

% top left corner of height_map is zero
% for each pixel in the left column of height_map
%   height_value = previous_height_value + corresponding_q_value

height_map(2:end, 1) = cumsum(q(2:end, 1, 1));


% for each row
%   for each element of the row except for leftmost
%       height_value = previous_height_value + corresponding_p_value
height_map(:,2:end) = cumsum(p(:,2:end,1), 2) + height_map(:, 1);

end

function [ height_map ] = construct_surface_row_path( p, q )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   height_map: the surface to be reconstructed

[h, w] = size(p);
height_map = zeros(h, w);

height_map(1, 2:end) = cumsum(p(1, 2:end, 1));
height_map(2:end, :) = cumsum(q(2:end, :, 1)) + height_map(1, :);
height_map = -1 .* height_map;
end