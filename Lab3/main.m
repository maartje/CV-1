close all
clear

%im_person = imread('person_toy/00000001.jpg');
% im_pingpong = imread('pingpong/0000.jpeg'); 
%dgrees = randi([1,360]);
%im_rotated = imrotate(im_person, dgrees);

%harris_corner_detector(im_person);
% harris_corner_detector(im_pingpong);
%harris_corner_detector(im_rotated);

% im_synth1 = imread('synth1.pgm');
% im_synth2 = imread('synth2.pgm');
% lucas_kanade(im_synth1, im_synth2);
% 
% im_sphere1 = imread('sphere1.ppm');
% im_sphere2 = imread('sphere2.ppm');
% lucas_kanade(im_sphere1, im_sphere2);

% Finding a reasonable threshold
% by visual inspection on one image
% for i=(0:0.25:2)
%     harris_corner_detector(im_person, i);
% end

% Finetuning a reasonable threshold
% by visual inspection on two images
% for i=(0.1:0.1:0.3)
%     harris_corner_detector(im_person, i);
%     harris_corner_detector(im_pingpong, i);
% end

imagefiles = dir('person_toy/*.jpg');   
for i=1:length(imagefiles)
   fname = fullfile('person_toy', imagefiles(i).name);
   frame = imread(fname);
   frames(:,:,i) = im2double(rgb2gray(frame));
   fprintf('%s \n', fname);
end
tracking(frames, 'person_toy.avi');

% im_toy1 = imread('person_toy/00000001.jpg');
% im_toy2 = imread('person_toy/00000002.jpg');
% lucas_kanade(im_toy1, im_toy2);