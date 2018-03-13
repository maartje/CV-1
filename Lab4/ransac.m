function ransac(f1, f2, matches, n, p)
    
    % pixel coordinates (x,y) for matchpoints
    % in first image (mp_1) and second image (mp_2)
    mp1 = f1(1:2, matches(1,:));
    mp2 = f2(1:2, matches(2,:));
    
    inliers = [];
    for i = 1:n
        
        % randomly select 'p' points
        msize = size(matches, 2);
        indices_selected = randperm(msize, p);
        mp1_selected = mp1(:, indices_selected);
        mp2_selected = mp2(:, indices_selected);
        
        % construct transformation vector 'x' by solving
        % the equation Ax = b
        A = zeros(8, 6);
        for i = 1 : size(mp1_selected, 2)
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

        % transform all matches in image 1
        M = [
            x(1), x(2);
            x(3), x(4)
        ];
        T = [x(5); x(6)];
        mp1_transformed = M * mp1 + T;
        
        % TODO: plot im1,T + im2, T_tr
        
        % count inliers
        mp_diffs = mp1_transformed - mp2;
        distances = sqrt(mp_diffs(1,:) .^ 2 + mp_diffs(2,:) .^ 2);
        if sum(distances < 10) > length(inliers)
            inliers = distances < 10;
        end
        
        fprintf('%d \n', sum(distances < 10));


        

    end


end