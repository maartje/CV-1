% run ../vlfeat0921/toolbox/vl_setup

function mj()

    im_example = imread('Caltech4/ImageData/airplanes_test/img014.jpg');
    f1 = extract_features(im_example, 'rgb', 'dense', 10);
    f2 = extract_features(im_example, 'opponent');
end