function [M, T] = ransac(f1, f2, matches, n, p)
    
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
        
        % TODO: plot im1,T + im2, T_tr
        
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
%         fprintf('%d %d \n', sum(inliers_current), sum(inliers));
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

