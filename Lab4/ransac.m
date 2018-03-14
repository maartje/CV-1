function [M, T] = ransac(f1, f2, matches, n, p, im1, im2)
    
    % pixel coordinates (x,y) for matchpoints
    % in first image (mp_1) and second image (mp_2)
    mp1 = f1(1:2, matches(1,:));
    mp2 = f2(1:2, matches(2,:));
    
    inliers = [];
    M = zeros(2, 2);
    T = zeros(2,1);
    for i = 1:n
        
        % randomly select 'p' points
        msize = size(matches, 2);
        indices_selected = randperm(msize, p);
        mp1_selected = mp1(:, indices_selected);
        mp2_selected = mp2(:, indices_selected);
        
        % estimate rotation+scaling and translation matrices 
        % based on selected points
        [M_current, T_current] = estimate_transformation(mp1_selected, mp2_selected);
        
        % transform all matched points from image 1
        mp1_transformed = M_current * mp1 + T_current;
                
        % count inliers and update result values
        % when the number of inliers has increased 
        mp_diffs = mp1_transformed - mp2;
        distances_sq = mp_diffs(1,:) .^ 2 + mp_diffs(2,:) .^ 2; 
        inliers_current = distances_sq < 100;
        if sum(inliers_current) > sum(inliers)
            inliers = inliers_current;
            M = M_current;
            T = T_current;
        end
        
        if nargin == 7 % images are passed for visualization
             
            % random sample of size 50
            r = randperm(size(matches, 2), 20);
            sample_mp1 = mp1(:, r);
            sample_mp1_transformed = mp1_transformed(:, r);
            X1 = sample_mp1(1,:);
            Y1 = sample_mp1(2,:);
            X2 = sample_mp1_transformed(1,:) + size(im1, 2);
            Y2 = sample_mp1_transformed(2,:);

            X1_selected = mp1_selected(1,:);
            Y1_selected = mp1_selected(2,:);
            X2_selected = mp2_selected(1,:) + size(im1, 2);
            Y2_selected = mp2_selected(2,:);
            
            im_concatenated = concatenate_images(im1, im2);
            
            figure();
            imshow(im_concatenated);
            title(strcat('#inliers: ', num2str(sum(inliers_current)), '#P: ', num2str(p) ));
            hold on;
            lines = plot([X1; X2], [Y1; Y2]);
            set(lines,'color','y');
            
            lines = plot([X1_selected; X2_selected], [Y1_selected; Y2_selected]);
            set(lines,'color','r', 'LineWidth', 2);
            plot([X1_selected; X2_selected], [Y1_selected; Y2_selected], 'r*', 'LineWidth', 2, 'MarkerSize', 15);

            hold off;
            
            % print info 
            fprintf('number of points: %d \n', p);
            fprintf('iteration: %d \n', i);
            fprintf('current number of inliers: %d \n', sum(inliers_current));
            fprintf('total of inliers:          %d \n \n', sum(inliers));
        end

    end
    
    % re-compute least-squares estimate on all of the inliers
    [M, T] = estimate_transformation(mp1(:, inliers), mp2(:, inliers));



end

function [M, T] = estimate_transformation(mp1_selected, mp2_selected)
        % construct transformation parameters 'x' by solving
        % the equation Ax = b
        nr_of_points = size(mp1_selected, 2);
        A = zeros(nr_of_points * 2, 6);
        for i = 1 : nr_of_points
            x = mp1_selected(1, i);
            y = mp1_selected(2, i);
            A_index = 2 * i - 1;
            A(A_index : A_index + 1, :) = [
                x,y,0,0,1,0;
                0,0,x,y,0,1
            ];
        end
        b = mp2_selected(:);
        x = pinv(A) * b;

        % construct rotation+scaling and translation matrices
        M = [
            x(1), x(2);
            x(3), x(4)
        ];
        T = [x(5); x(6)];
end

