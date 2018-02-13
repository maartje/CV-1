clear
clc
close all

ball_original = imread('ball.png');
ball_reflectance = imread('ball_reflectance.png');
ball_shading = imread('ball_shading.png');
ball_reconstructed = iid_image_formation(ball_reflectance, ball_shading);
ball_recolored_green = recoloring(ball_reflectance, ball_shading, 0, 255, 0);
ball_recolored_magenta = recoloring(ball_reflectance, ball_shading, 255, 0, 255);

figure;
subplot(2,2,1);
imshow(ball_original);

subplot(2,2,2);
imshow(ball_reflectance);

subplot(2,2,3);
imshow(ball_shading);

subplot(2,2,4);
imshow(ball_reconstructed);

figure;
subplot(2,2,1);
imshow(ball_original);

subplot(2,2,2);
imshow(ball_recolored_green);

subplot(2,2,3);
imshow(ball_recolored_magenta);