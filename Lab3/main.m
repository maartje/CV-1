close all
clear

im_person = imread('person_toy/00000001.jpg');
im_pingpong = imread('pingpong/0000.jpeg'); 
dgrees = randi([1,360]);
im_rotated = imrotate(im_person, dgrees);

%harris_corner_detector(im_person);
%harris_corner_detector(im_pingpong);
harris_corner_detector(im_rotated);