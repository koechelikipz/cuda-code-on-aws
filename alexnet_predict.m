function out = alexnet_predict(filename) %#codegen

% This entry point function takes a filename for a JPG/JPEG image of size
% less than or equal to 1280*720, and returns the classification output from Alexnet.
% An ASCII file is used to store the classification labels because
% a MAT file creates a struct with a cell array field to store the labels when loaded and non-constant
% indexing into a cell array is not supported for code generation.


% A persistent object mynet is used to load the series network object.
% At the first call to this function, the persistent object is constructed and
% setup. When the function is called subsequent times, the same object is reused 
% to call predict on inputs, thus avoiding reconstructing and reloading the
% network object.

persistent mynet;
persistent labels;

im = imread(filename);

% An upper limit is set on the image size, because the 'predict' function
% expects a constant size input for code generation.
coder.varsize('im',[1280,720,3],[1, 1, 0]);

img = imresize(im, [227,227]);

if isempty(mynet)
    mynet = coder.loadDeepLearningNetwork('alexnet');
end
   
if isempty(labels)
    labels=coder.load('labels.txt','-ascii');
end

% Index of the maximum prediction score is used to obtain the
% classification output.
scores = predict(mynet,img);
[~,label_idx] = max(scores);

% Using line breaks(ASCII value 10) to index into labels vector
line_breaks = find(labels==10);
start = line_breaks(label_idx-1);
last = line_breaks(label_idx);

out=char(labels(start+1:last-1));

end
