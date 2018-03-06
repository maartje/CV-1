function flow = lucas_kanade(im1, im2)

% settings
region_size = 15;

% convert to grey scale
if ndims(im1) == 3
    im_gray1 = im2double(rgb2gray(im1));
    im_gray2 = im2double(rgb2gray(im2));
else
    im_gray1 = im2double(im1);
    im_gray2 = im2double(im2);    
end 

% build 3D representation with 'time' as the third dimension
I = im_gray1;
I(:,:,2) = im_gray2;

% get the gradients in the x,y and t direction for the first image frame
[Ix, Iy, It] = gradient(I);
Ix = Ix(:,:,1);
Iy = Iy(:,:,1);
It = It(:,:,1);


[rows, columns] = size(Ix);
number_of_regions = ceil(rows/region_size) * ceil(columns/region_size)
x = zeros([1,number_of_regions]);
y = zeros([1,number_of_regions]);
Vx = zeros([1,number_of_regions]);
Vy = zeros([1,number_of_regions]);
region_index = 1;
flowX = zeros(size(Ix));
flowY = zeros(size(Ix));
for r = 1 : region_size : rows
    for c = 1 : region_size : columns
        r_start = r;
        r_end = min(r + region_size - 1, rows);
        c_start = c;
        c_end = min(c + region_size - 1, columns);
        
        Ix_region = Ix(r_start : r_end, c_start : c_end);
        Iy_region = Iy(r_start : r_end, c_start : c_end);
        It_region = It(r_start : r_end, c_start : c_end);
        
        A = [Ix_region(:), Iy_region(:)];
        b = - It_region(:);
        
        % (A^T A)^-1 A^T b
        % v = inv(transpose(A) * A) * (transpose(A) * b);
        v = (transpose(A) * A) \ (transpose(A) * b);
        
        flowX(r_start : r_end, c_start : c_end) = v(1,1);
        flowY(r_start : r_end, c_start : c_end) = v(2,1);

        y(region_index) = r_start + floor((r_end - r_start)/2); 
        x(region_index) = c_start + floor((c_end - c_start)/2);
        Vx(region_index) = v(1,1);
        Vy(region_index) = v(2,1);
        region_index = region_index + 1;
    end
end

flow = flowX;
flow(:,:,2) = flowY;

figure;
imshow(im1);
hold on
quiver((8:15:rows), (8:15:columns), flow(8:15:end,8:15:end,1), flow(8:15:end,8:15:end,2),'color',[1 0 0]);
hold off


figure;
imshow(im1);
hold on
quiver(x, y, Vx, Vy,'color',[1 0 0]);
hold off
end