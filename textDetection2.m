function letter = TextDetection(image)
% imAdd = 'croptest1.jpg';
imAdd = 'exp1.jpg';
image = imread(imAdd);
% image=imresize(image,0.25);
% cropBox= [0, 90, size(image,2), 400];
% image=imcrop(image, cropBox);
boxes = RedBoxDetector(image);
boxes = boxes.BoundingBox;
cropped = imcrop(image, boxes);
gray = rgb2gray(cropped);
imshow(gray);
bw = im2bw(gray);
imshow(bw);
onlyLetter = bwareaopen(bw, 50);
imshow(onlyLetter);
postProcessed = bwmorph(onlyLetter, 'thicken');
postProcessed = bwmorph(postProcessed, 'majority');
postProcessed = bwmorph(postProcessed, 'bridge');
imshow(postProcessed);

ocrtxt = ocr(onlyLetter, 'CharacterSet','ABCDEFGHIJKLMNOP','TextLayout','Block'); % use the binary image instead of the color image
letter = [ocrtxt.Text];
figure;
disp('the letter is: ')
disp(letter)
imshow(cropped);
