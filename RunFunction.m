clear;
imAdd = 'test13.jpg';
image = imread(imAdd);
redbox = RedBoxDetector(image);
% image2 = imread('btest.png');
% imtool(image2);
% imshow(image);
% [scalFac, lenCol] = GreenSeparator(image);
[letters, lengthOfCol] = Cropper(image);