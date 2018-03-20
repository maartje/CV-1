function vocabulary = build_vocabulary(fun_extract_features, fnames, vocabulary_size, replicates)
% Builds a vocabulary by applying kmeans clustering on features
% fun_extract_features: function to extract features for an image
% fnames: cell array of file paths to image files
% vocabulary_size: size of vocabulary
% replicates (optional): number of replications to search for optimal clustering
% vocabulary: k by p matrix with 
%     k the number of visual words and 
%     p the dimension determined by the extracted features

    if nargin < 2
        vocabulary_size = 400;
    end
    if nargin < 3
        replicates = 5;
    end
    descriptors = 0;
    for i=1:length(fnames)
        fname = fnames(i);
        im = imread(fname{1});
        d = fun_extract_features(im); % 128 (* 3) x 410
        if descriptors
            descriptors = horzcat(descriptors,d);
        else
            descriptors = d;
        end
    end
    vocabulary = build_vocabulary_from_features(transpose(descriptors), vocabulary_size, replicates);

end

function vocabulary = build_vocabulary_from_features(features, vocabulary_size, replicates)
% Builds a vocabulary by applying kmeans clustering on features
% features: n by p matrix with 
%    p the dimensionality and 
%    n the number of observations
% vocabulary_size: size of vocabulary
% replicates (optional): number of replications to search for optimal clustering
% vocabulary: k by p matrix containing k p-dimensional visual words 

    
    % TODO: preprocessing such as normalization?

    [~, vocabulary] = kmeans(features, vocabulary_size, 'Replicates', replicates);
end