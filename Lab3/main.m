close all
clear

%im_person = imread('person_toy/00000001.jpg');
%im_pingpong = imread('pingpong/0000.jpeg'); 
%dgrees = randi([1,360]);
%im_rotated = imrotate(im_person, dgrees);

%harris_corner_detector(im_person);
%harris_corner_detector(im_pingpong);
%harris_corner_detector(im_rotated);

im_synth1 = imread('synth1.pgm');
im_synth2 = imread('synth2.pgm');
lucas_kanade(im_synth1, im_synth2);

% im_sphere1 = imread('sphere1.ppm');
% im_sphere2 = imread('sphere2.ppm');
% lucas_kanade(im_sphere1, im_sphere2);


