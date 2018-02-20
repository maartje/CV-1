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
