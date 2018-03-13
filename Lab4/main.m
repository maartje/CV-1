%run ../vlfeat0921/toolbox/vl_setup
close all
clear

demo_image_alignment();

function demo_image_alignment()

    boat1 = imread('boat1.pgm');
    boat2 = imread('boat2.pgm');

    [f1, f2, kpmatches] = keypoint_matching(boat1, boat2);
    [M, T] = ransac(f1, f2, kpmatches, 5, 4);
    
    boat1_trform = transform_image(boat1, M, T);
    % TODO: other way round

    % https://nl.mathworks.com/help/images/matrix-representation-of-geometric-transformations.html
    % transform using matlab functions
    A = zeros(3,3);
    A(3, 3) = 1;
    A(1:2, 1:2) = transpose(M);
    A(3, 1:2) = T;
    trform = affine2d(A);
    boat1_trform_mtl = imwarp(boat1, trform);

    % plot matlab transformation
    figure;
    subplot(2,2,1);
    imshow(boat1);
    subplot(2,2,2);
    imshow(boat2);
    subplot(2,2,3);
    imshow(boat1_trform);
    subplot(2,2,3);
    imshow(boat1_trform_mtl);

end

function I_transformed = transform_image(im, M, T)

    % transform to double values
    I = im2double(im);
    
    % create cartesian matrix with x columns: [x, y, im_value]
    [X, Y] = meshgrid(1:size(I, 2), 1:size(I, 1));
    I_xy = transpose([X(:),Y(:),I(:)]);
    
    % transform x,y coordinates of cartesian matrix
    M_im = zeros(3,3);
    M_im(1:2,1:2) = M;
    M_im(3,3) = 1;
    T_im = zeros(3,1);
    T_im(1:2) = T;
    I_xy_transformed = M_im * I_xy + T_im;
    
    % transose so that x and y coordinates are positive and start around one
    min_xy = floor(min(I_xy_transformed, [], 2));
    I_xy_transformed = I_xy_transformed - [min_xy(1); min_xy(2); 0];

    % build matrix with pointers to nearest neighbor index in I_xy_transformed 
    max_xy = floor(max(I_xy_transformed, [], 2));
    I_transformed_indices = zeros(max_xy(2), max_xy(1));
    for i = 1 : size(I_xy_transformed, 2)
        xy = I_xy_transformed(1:2,i);
        x_coordinate = min(max(round(xy(1)), 1), max_xy(1)); % round to int and fit in image range
        y_coordinate = min(max(round(xy(2)), 1), max_xy(2));
        nn_index = I_transformed_indices(y_coordinate, x_coordinate);
        if nn_index == 0
            I_transformed_indices(y_coordinate, x_coordinate) = i;
        else
            xy_coordinate = [x_coordinate; y_coordinate];
            xy_prev = I_xy_transformed(1:2, nn_index);
            distance_prev_sq = transpose(xy_prev - xy_coordinate) * (xy_prev - xy_coordinate);
            distance_current_sq = transpose(xy - xy_coordinate) * (xy - xy_coordinate);            
            if distance_current_sq > distance_prev_sq
                I_transformed_indices(y_coordinate, x_coordinate) = i;
            end
        end
    end
    
    

    I_transformed = zeros(size(I_transformed_indices));
    for x = 1 : size(I_transformed_indices, 2)
        for y = 1 : size(I_transformed_indices, 1)
            nn_index = I_transformed_indices(y,x);
            if nn_index
                I_transformed(y,x) = I_xy_transformed(3, nn_index);
            else
                % we assume that window 3x3 is enough to interpolate pixels in the middle
                neigbor_indices = I_transformed_indices(max(y-1,1) : min(y+1,size(I_transformed_indices, 1)), max(x-1,1) : min(x+1, size(I_transformed_indices, 2)));
                neigbor_indices = neigbor_indices(:);
                neigbor_indices = neigbor_indices(neigbor_indices > 0);
                if ~isempty(neigbor_indices)
                    % we are lazy and pick a random neighbor instead of figuring out the 
                    % nearest neighbor by comparing distances to neighboring points 
                    % in I_xy_transform
                    nn_index = neigbor_indices(1); 
                    I_transformed(y,x) = I_xy_transformed(3, nn_index);
                end
            end
        end
    end
    
    figure;
    imshow(I_transformed);

end