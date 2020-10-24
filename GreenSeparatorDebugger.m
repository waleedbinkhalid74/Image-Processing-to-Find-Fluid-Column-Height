clear;
im1 = imread('snap6.jpg');
im1 = imresize(im1, 0.25);
% figure;
imtool(im1);
[h, v, l] = size(im1);

imG = im1;
for k=1:h
    for j=1:v
        if (imG(k,j,1)>90 && imG(k,j,1)<200 && imG(k,j,2)>105 && imG(k,j,3)>18 && imG(k,j,2)<230 && imG(k,j,3)<65)
            imG(k,j,:) = 255;
        else
            imG(k,j,:)=0;
        end
    end
end
imGBW = im2bw(imG);
% figure;
% imshow(imGBW);
% pause;
imGA = bwareaopen(imGBW, 100);
imGA = imfill(imGA, 'holes');
% figure;
imshow(imGA);
% [scalFac, baseTape] = ColourSeparation(im1);
greenbox = regionprops(imGA, 'BoundingBox');
% noBB = length(greenbox);
% noBB = int16(noBB);
% 
% for k = 1:noBB
%     rectangle('Position', greenbox(k).BoundingBox,'EdgeColor','b');
% end
% lenCol = 0;
% if noBB>=1
%     lenCol = greenbox(2).BoundingBox(4);
%     lenCol = lenCol*scalFac + 238;
%     
% else
%     lenCol = baseTape - greenbox.BoundingBox(2);
%     lenCol = lenCol*scalFac;
%     lenCol = 220 - lenCol;
% end