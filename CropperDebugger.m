clear;
imAdd = 'snap1.jpg';
im1 = imread(imAdd);
% im1 = image;
im1 = imresize(im1, 0.25);
redbox = RedBoxDetector(im1);
% imtool(im1small);
noBB = int16(length(redbox));
listAvg = zeros(1, noBB);
high= size(im1,1);
wid = size(im1,2);
% imshow(im1small);
for w = 1:noBB-1
    listAvg = (redbox(w).BoundingBox(1) + redbox(w+1).BoundingBox(1))/2;
end

listAvg(noBB) =  wid;
lastCorr = 0;
letters = blanks(1);
lengthOfCol = zeros(noBB,1);

for noOfImages = 1 : noBB;
    boxes = [lastCorr 0 listAvg(noOfImages) high];
    croppedImage = imcrop(im1, boxes);
%     figure;
%     imwrite(croppedImage, 'exp1.jpg');
    
    greenBox = GreenSeparator(croppedImage);
    xCordGreen = greenBox.BoundingBox(1)
    xWidthGreen = greenBox.BoundingBox(3)
    imtool(croppedImage);
    imwrite(croppedImage, 'exp1.jpg');
    lastCorr = listAvg(noOfImages);
    xCord = redbox(noOfImages).BoundingBox(1)
    xWidth = redbox(noOfImages).BoundingBox(3)
    widthPic = size(croppedImage, 2)
    if (xCord < 1) || (xCord+xWidth > (widthPic - 4)) || (xCordGreen < 1) || ((xCordGreen + xWidthGreen) > (widthPic - 4))
        continue
    end
%     figure;
%     imshow(croppedImage);    
%     pause;
%     letters = TextDetection(croppedImage);
%     letters = letters(find(~isspace(letters)));
%     disp('The letter detected is: ');
%     disp(letters);
%     lengthOfCol(noBB) = GreenSeparator(croppedImage);
%     letters(noBB: size(TextDetection(croppedImage),2)) = TextDetection(croppedImage);  
end

