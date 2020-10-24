function [greenbox, scalFac] = GreenSeparator(image)
% im1small = imread(imAdd);
% image = imresize(image, 0.25);
% imtool(im1small);
[h, v, l] = size(image);

imG = image;
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
imGA = bwareaopen(imGBW, 100);
imGA = imfill(imGA, 'holes');
% figure;
% imshow(imGA);
[scalFac, baseTape] = ColourSeparation(image);
greenbox = regionprops(imGA, 'BoundingBox');
% display(greenbox(1).BoundingBox);
% display(greenbox(2).BoundingBox);
noBB = length(greenbox);
noBB = int16(noBB);
% 
% for k = 1:noBB
%     rectangle('Position', greenbox(k).BoundingBox,'EdgeColor','b');
% end
% % lenCol = 0;

% lenCol = greenbox.BoundingBox(4);
% lenCol = lenCol*scalFac;

% if noBB>1
%     lenCol = greenbox(2).BoundingBox(4);
% %     display(lenCol);
%     lenCol = lenCol*scalFac + 238;
% %     display(lenCol);
%     
% else
%     lenCol = baseTape - greenbox.BoundingBox(2);
%     lenCol = lenCol*scalFac;
%     lenCol = 220 - lenCol;
% end
% xlswrite('C:\Users\User\Desktop\Fluid Project Image Processing\heights.xlsx',lenCol);    