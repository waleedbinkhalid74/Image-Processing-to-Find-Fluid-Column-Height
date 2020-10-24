function [letters, lengthOfCol] = Cropper(image)
% imAdd = 'print1.png'
im1 = image;
redbox = RedBoxDetector(im1);
noBB = int16(length(redbox));
if noBB == 0
    d=input('Is this image without a letter/column (Y/N) ', s);
    if d=='Y'
        letters = '';
        lengthOfCol = [];
        return
    else
        imshow(im1);
        letters=input('What letter is this? ', s);
        lengthOfCol=input('What is the length of this column', s);
        return
    end
    
end
listAvg = zeros(1, noBB);
high= size(im1,1);
wid = size(im1,2);
for w = 1:noBB-1
    listAvg = (redbox(w).BoundingBox(1) + redbox(w+1).BoundingBox(1))/2;
end
listAvg(noBB) =  wid;
lastCorr = 0;
letters = '';
lengthOfCol = [];

for noOfImages = 1 : noBB;
    boxes = [lastCorr 0 listAvg(noOfImages) high];
    croppedImage = imcrop(im1, boxes);
    redbox1 = RedBoxDetector(croppedImage);
%     figure;
    [greenBox, scalFac] = GreenSeparator(croppedImage);
    
    if length(redbox1)>1
        imshow(croppedImage);
        a=input('What letter is this? ','s');
        letters = [letters, a];
        b=input('What is the length? ');
        lengthOfCol = [lengthOfCol, b];
        lastCorr = listAvg(noOfImages);
        continue
    end
%     
    if length(greenBox)==1
        xCordGreen = greenBox.BoundingBox(1);
        xWidthGreen = greenBox.BoundingBox(3);
        redbox1 = RedBoxDetector(croppedImage);
        lastCorr = listAvg(noOfImages);
        xCord = redbox1.BoundingBox(1);
        xWidth = redbox1.BoundingBox(3);
        widthPic = size(croppedImage, 2);
        if (xCord < 1) || (xCord+xWidth > (widthPic - 4)) || (xCordGreen < 1) || ((xCordGreen + xWidthGreen) > (widthPic - 4))
            continue
        end
        lengthOfCol = [lengthOfCol, greenBox.BoundingBox(4)*scalFac];
    elseif length(greenBox)==0
        lengthOfCol = [lengthOfCol, 0];
    else
        imshow(croppedImage);
        c=input('What is the length? ');
        lengthOfCol = [lengthOfCol, c];
        lastCorr = listAvg(noOfImages);
    end
%     figure;
%     imshow(croppedImage);
    imwrite(croppedImage, 'exp1.jpg');

    detectedLetter = TextDetection(croppedImage);
    if length(detectedLetter) == 0 
        imshow(croppedImage)
        a=input('What letter is this? ','s');
        letters = [letters, a];
    else
        letters = [letters, detectedLetter];
    end
%     disp('The letter detected is: ');
%     disp(letters);    
%     figure;
%     imshow(croppedImage);
%     title(strcat('Length: ', num2str(lengthOfCol(1, noOfImages)), ' Letter: ', letters));
%     imagename=strcat('exp',int2str(noOfImages), '.jpg');

end
letters = letters(find(~isspace(letters)));

