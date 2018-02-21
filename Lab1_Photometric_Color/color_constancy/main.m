clear all
close all
clc

im = imread('awb.jpg');
im_result = AWB(im);

figure;
subplot(1,2,1);
imshow(im);

subplot(1,2,2);
imshow(im_result);

im_nature = imread('nature.png');
im_nature_result = AWB(im_nature);

figure;
subplot(1,2,1);
imshow(im_nature);

subplot(1,2,2);
imshow(im_nature_result);
