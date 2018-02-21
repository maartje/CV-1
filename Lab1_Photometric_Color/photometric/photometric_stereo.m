close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')

photometric_stereo_on_colorImage('./photometrics_images/SphereColor/');
photometric_stereo_on_colorImage('./photometrics_images/MonkeyColor/');

image_dir = './photometrics_images/SphereGray5/';   
% image_dir = './photometrics_images/MonkeyGray/';
% image_dir = './photometrics_images/SphereGray25/';   
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir, 3);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
fprintf('Percentage of outliers: %d\n\n', sum(sum(SE > threshold))/numel(SE));


%% compute the surface height
height_map = construct_surface( p, q, 'row');

%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map);


%% Face
% [image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02_without_problematic/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
fprintf('Percentage of outliers: %d\n\n', sum(sum(SE > threshold))/numel(SE));

%% compute the surface height
height_map = construct_surface( p, q , 'column');

show_results(albedo, normals, SE);
show_model(albedo, height_map);

function photometric_stereo_on_colorImage(image_dir)
    [image_stack1, scriptV] = load_syn_images(image_dir, 1);
    [image_stack2, ~] = load_syn_images(image_dir, 2);
    [image_stack3, ~] = load_syn_images(image_dir, 3);

    [albedo1, normals1] = estimate_alb_nrm(image_stack1, scriptV, true);
    [albedo2, normals2] = estimate_alb_nrm(image_stack2, scriptV, true);
    [albedo3, normals3] = estimate_alb_nrm(image_stack3, scriptV, true);

    albedo = albedo1;
    albedo(:,:,2) = albedo2;
    albedo(:,:,3) = albedo3;

    normals = normals1 + normals2 + normals3;
    norms = arrayfun(@(x,y,z) norm([x,y,z]), normals(:,:,1), normals(:,:,2), normals(:,:,3));
    normals = normals ./ norms;

    [p, q, SE] = check_integrability(normals);

    threshold = 0.005;
    SE(SE <= threshold) = NaN; % for good visualization
    fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
    fprintf('Percentage of outliers: %d\n\n', sum(sum(SE > threshold))/numel(SE));

    height_map = construct_surface( p, q, 'column');
    show_results(albedo, normals, SE);
    show_model(albedo, height_map);
end